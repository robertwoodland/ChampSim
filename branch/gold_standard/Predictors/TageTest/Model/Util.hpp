#include "../../../include/gold_standard.hpp"
#include "../../../include/Components/lfsr.hpp"
#include <memory>
#include <iostream>
#include <optional>
#include <utility>

namespace gold_standard {

    #define GLOBAL_SIZE 256
    #define PATH_HISTORY_SIZE 16

    

    typedef struct {
        uint32_t tag;
        uint8_t useful_counter;
        uint8_t counter;
    } tagged_entry;

    typedef struct {
        uint16_t index_size;
        uint16_t tag_size;
        uint16_t history_length;
    } table_parameters;

    class table{
        public:
            virtual void print_size() = 0;
            virtual void update_history(std::bitset<GLOBAL_SIZE>& global, std::bitset<PATH_HISTORY_SIZE> path) = 0;
            virtual uint64_t get_index(uint64_t pc) = 0;
            virtual std::optional<tagged_entry> access_entry(uint64_t pc) = 0;
            ~table() = default;

    };

    template <const table_parameters& params>
    class tagged_table : public table {
        public:
            static constexpr uint64_t num_entries = ( 1 << params.index_size);
            std::array<tagged_entry, num_entries> entries;
            uint16_t history_length;
            uint8_t tag_size;
            
            
            std::bitset<params.index_size> folded_history;
            std::bitset<params.index_size> folded_path_history;
            std::bitset<params.tag_size> folded_tag; // History for the tag
            
            tagged_table(){
                entries.fill(tagged_entry{0,0,2});
            }
            
            
            uint64_t get_index(uint64_t pc);
            std::optional<tagged_entry> access_entry(uint64_t pc);
            
            void update_history(std::bitset<GLOBAL_SIZE>& global, std::bitset<PATH_HISTORY_SIZE> path);

            void print_size() override {
                printf("%ld\n", entries.size());
            }
    };

    using tagged_tables_type = std::vector<std::unique_ptr<table>>;

    typedef struct {
        public:
        bool use_bimodal = false;
        bool alt_bimodal = false;
        
        // Indices used
        uint32_t alt_table;
        uint32_t pred_table;
    } trainingInfo;


    uint8_t access_bimodal_entry(uint64_t pc);
    std::pair<uint32_t, uint32_t> get_bimodal_index(uint64_t pc);
}
