// #include "../inc/ooo_cpu.h"
#include "testpred.h"
#include <gtest/gtest.h>

TEST(SampleTest, AssertionTrue) { EXPECT_TRUE(true); }

// TEST(SampleTest, Addition) {
//     EXPECT_EQ(1 + 1, 2);
// }

// Test that, when pred is called on a PC, it returns the correct value
TEST(PerceptronTests, PredRetTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();
  // out = O3_CPU::predict_branch(ip);
  out = cpu.predict_branch(ip); // Need to include header from somewhere...

  EXPECT_EQ(out, 1); // ?
}

int main(int argc, char** argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}