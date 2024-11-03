#ifndef TAGE_HPP
#define TAGE_HPP

#include "../../../include/gold_standard.hpp"
#include "../../../include/Components/lfsr.hpp"
#include "Util.hpp"
#include <unistd.h>
#include <iostream>
#include<bitset>
#include<optional>


/*
TAGE paper

In order to limit this phenomenon, it was proposed in [24] to include non-conditional
branches in the branch history ghist (by inserting a taken bit) and to also use a (limited)
16-bit path history phist consisting of 1 address bit per branch.

*/


namespace gold_standard {
    // Default values of 0
    
    #define U_COUNTER_SIZE 2
    #define COUNTER_SIZE 3
    #define BIMODAL_COUNTER_SIZE 2

    #define BIMODAL_PREDICTION_BITS 13
    #define BIMODAL_HYSTERESIS_BITS 9
    #define ALT_ON_NA_BITS 4

    constexpr uint16_t prediction_entries = (( 1 << BIMODAL_PREDICTION_BITS) / 64);
    constexpr uint16_t hysteresis_entries = (( 1 << BIMODAL_HYSTERESIS_BITS) / 64);

    // Index size, Tag size, History length
    std::bitset<GLOBAL_SIZE> global_history;
    std::bitset<PATH_HISTORY_SIZE> path_history;

    std::array<uint64_t, prediction_entries> bimodal_prediction_bits;
    std::array<uint64_t, hysteresis_entries> bimodal_hysteresis_bits;
    tagged_tables_type tagged_tables;
    trainingInfo last_training_data;
    uint8_t alt_on_na = (1 << 4)/2 - 1;

    constexpr table_parameters t1{9,9,5};   
    constexpr table_parameters t2{9,9,9};
    constexpr table_parameters t3{9,10,15};
    constexpr table_parameters t4{9,10,25};
    constexpr table_parameters t5{9,11,44};
    constexpr table_parameters t6{9,11,76};
    constexpr table_parameters t7{9,12,130};

    void gold_standard_predictor::impl_initialise(){

        tagged_tables.push_back(std::make_unique<tagged_table<t1>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t2>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t3>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t4>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t5>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t6>>());
        tagged_tables.push_back(std::make_unique<tagged_table<t7>>());


        global_history = 1;
        std::cout << global_history << std::endl;

        for(int i = 0; i < 10; i++){
            for(const auto& t : tagged_tables){
                t->update_history(global_history, path_history);
            }
            global_history <<= 1;
            //std::cout << global_history << std::endl;
        }
        
    }

    #ifdef DEBUG_DATA
    std::pair<uint8_t,DebugData> gold_standard_predictor::impl_predict_branch(uint64_t ip){
            uint16_t index = (ip >> 2) & 0xFFF;
            uint8_t entry = table[index];
            DebugData debug{index, entry, 0};
            return {entry > 1, debug};    
    }
    #else
    uint8_t gold_standard_predictor::impl_predict_branch(uint64_t ip){
        
        bool found_provider = false;
        bool found_alt = false;
        int provider;
        int  alt;
        tagged_entry provider_entry;
        tagged_entry alt_entry;
        trainingInfo train;
        
        for(int i = tagged_tables.size()-1; i >= 0; i++){
            auto entry = tagged_tables[i]->access_entry(ip);
            if(entry.has_value()){
                if(!found_provider){
                    found_provider = true;
                    provider = i;
                    provider_entry = entry.value();
                }else if(!found_alt){
                    found_alt = true;
                    alt = i;
                    alt_entry = entry.value();
                }
            }
        }

        // Set up training data, half of it is not really necessary
        if(!found_provider){
            last_training_data.use_bimodal = true;
            return access_bimodal_entry(ip) > 1;
        }else{
            last_training_data.use_bimodal = false;
            last_training_data.pred_table = provider;
            
            if(!found_alt){
               last_training_data.alt_bimodal = true;
            }else{
                last_training_data.alt_bimodal = false;
                last_training_data.alt_table = alt;
                
                // Is this also true if the alternative is bimodal?
                if(provider_entry.useful_counter == 0 && (provider_entry.counter < 6 || provider_entry.counter > 1) && alt_on_na <= ALT_ON_NA_BITS/2){
                    return alt_entry.counter > 3;
                }
            }
            return provider_entry.counter > 3;
        }

    }
    #endif

    // Luckily updates are immediately after the predictions
    void gold_standard_predictor::impl_last_branch_result(uint64_t ip, uint64_t target, uint8_t taken, uint8_t branch_type){
        
        // Include unconditional branches ?
        if (branch_type == BRANCH_DIRECT_JUMP){
            global_history <<= 1;
            global_history.set(0, true);
        }else if(branch_type == BRANCH_CONDITIONAL){
            global_history <<= 1;
            global_history.set(0, taken);
            
            path_history <<= 1;
            path_history.set(0, (bool)(ip & (1 << 5) >> 5));
        }
        
        
        return;
    }

    std::pair<uint32_t, uint32_t> get_bimodal_index(uint64_t pc){
        uint64_t mask1 = (1 << BIMODAL_PREDICTION_BITS) - 1;
        uint64_t mask2 = (1 << BIMODAL_HYSTERESIS_BITS) - 1;

        uint32_t prediction_index = mask1 & (pc >> 2) & static_cast<uint64_t>(global_history.to_ullong());
        uint32_t hysteresis_index = mask2 & (pc >> 2) & static_cast<uint64_t>(global_history.to_ullong());
        return {prediction_index, hysteresis_index};
    }

    uint8_t access_bimodal_entry(uint64_t pc){
        uint32_t prediction_index = get_bimodal_index(pc).first;
        uint32_t index = prediction_index / 64;
        uint16_t offset = prediction_index - ((prediction_index / 64) * index);
        return (bimodal_prediction_bits[index] & (1 << offset)) >> offset;
    }

    template<const table_parameters& params>
    uint64_t tagged_table<params>::get_index(uint64_t pc){
        uint64_t mask = (1 << params.index_size)-1;
        uint64_t folded_pc = ((pc >> 2) & mask) ^ (pc >> (2 + params.index_size) & mask);
        uint64_t index = folded_history.to_ulong() ^ folded_path_history.to_ulong() ^ folded_pc;
        return index;
    }

    template<const table_parameters& params>
    std::optional<tagged_entry> tagged_table<params>::access_entry(uint64_t pc){
        uint64_t mask = (1 << params.index_size)-1;
        uint64_t index = get_index(pc);
        uint64_t tag = ((pc >> 2) & mask) ^ (pc >> (5 + params.index_size) & mask) ^ folded_tag.to_ulong();
        
        tagged_entry t = entries[index];
        
        // Hash function for the tag??

        if(t.tag == tag){
            return std::optional<tagged_entry>{t};
        }
        return std::optional<tagged_entry>{};
    }


    // Shift registers
    template<const table_parameters& params>
    void tagged_table<params>::update_history(std::bitset<GLOBAL_SIZE>& global, std::bitset<PATH_HISTORY_SIZE> path) {
            // Global history
            bool last_bit = folded_history.test(params.index_size-1);
            folded_history <<= 1;
            folded_history.set(0, global.test(0) ^ last_bit);
            
            uint8_t i = params.history_length % params.index_size;
            folded_history.set(i, global.test(params.history_length) ^ folded_history.test(i));

            // Path history, could probably just merge this with the global history actually but path history must be 16 bits
            last_bit = folded_path_history.test(params.index_size-1);
            folded_path_history <<= 1;
            i = PATH_HISTORY_SIZE % params.index_size;
            folded_path_history.set(0, last_bit ^ path.test(0));
            folded_path_history.set(i, path.test(PATH_HISTORY_SIZE-1));

            // Not sure the best way to change this up so the tag is different enough
            last_bit = folded_tag.test(params.tag_size-1);
            folded_tag <<= 1;
            i = (params.history_length-3) % params.tag_size;
            folded_tag.set(0, global.test(0) ^ last_bit);
            folded_tag.set(i, global.test(params.history_length-3) ^ folded_tag.test(i));
    }
};

#endif