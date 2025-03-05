#include <array>
#include <bitset>
#include <cassert>
#include <deque>
#include <limits>
#include <memory>
#include <optional>
#include <queue>
#include <stdexcept>
#include <vector>

// cpu
class O3_CPU
{
public:
  void initialize_branch_predictor();
  uint8_t predict_branch(uint64_t);
  void last_branch_result(uint64_t, uint64_t, uint8_t, uint8_t);
};
