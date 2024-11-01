#ifndef TAGE_HPP
#define TAGE_HPP

#include "../../../include/gold_standard.hpp"
#include "../../../include/Components/lfsr.hpp"

#include <unistd.h>

/*
    64KB
    L(1)=5 and
    L(7)=130. 
    8 component

    For a 8-component TAGE predictor, we use respectively 9-bit tags for T1 and T2, 10-bit
tags for T3 and T4, 11-bit tags for T5 and T6, 12-bit tags for T7. The tagged tables feature
512 entries, and represent a total of 53.5 Kbits.

*/
namespace gold_standard {
    // Default values of 0
    #define INDEX_SIZE 9
    #define U_COUNTER_SIZE 2
    #define COUNTER_SIZE 3
    #define TOTAL_HISTORY 641

    constexpr uint16_t num_tagged_entries = 1 << INDEX_SIZE;

    typedef struct {
        uint32_t tag;
        uint8_t useful_counter;
        uint8_t counter;
    } tagged_entry;

    template <int size>
    struct tagged_table{
        std::array<tagged_entry,size> entries;
        uint16_t history_length;
        uint8_t tag_size;
    };

    template<int ... table_sizes>
    using tagged_tables_type = std::tuple<tagged_table<table_sizes>...>;
    
    template<int ... table_sizes>
    tagged_tables_type<table_sizes...> create() {
        return tagged_tables_type<table_sizes...>{tagged_table<table_sizes>()...};
    }
    auto tagged_tables = create<10,10,12,12>();
    //std::array<uint8_t,8192> bimodal;
    //std::array<std::array<uint32_t,num_entries>, 8> tagged_tables;


    void gold_standard_predictor::impl_initialise(){
        printf("%ld\n", std::get<0>(tagged_tables).entries.size());
    }

    

    // Luckily updates are immediately after the predictions
    void gold_standard_predictor::impl_last_branch_result(uint64_t ip, uint64_t target, uint8_t taken, uint8_t branch_type){
        uint16_t index = (ip >> 2) & 0xFFF;
        uint8_t entry = table[index];
        
        //printf("gold index: %d ip:%ld %d\n", index,  ip, entry);
        if(taken) entry = std::min(entry +1,3);
        else entry = std::max(entry-1, 0);
        table[index] = entry;
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
            uint16_t index = (ip >> 2) & 0xFFF;
            uint8_t entry = table[index];
            
            return entry > 1;    
        }
    #endif
};

#endif