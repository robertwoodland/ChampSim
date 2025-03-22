// #include "../inc/ooo_cpu.h"
#include "testpred.h"
#include <gtest/gtest.h>

TEST(SampleTest, AssertionTrue) { EXPECT_TRUE(true); }

// TEST(SampleTest, Addition) {
//     EXPECT_EQ(1 + 1, 2);
// }

// Check we get a value back on first prediction
TEST(PerceptronTests, PredRetTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();
  out = cpu.predict_branch(ip);

  EXPECT_EQ(out, 1);
}

// Check that we always predict taken if history is always taken
TEST(PerceptronTests, PredTrueTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count < 100; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
  }

  // Check that we always predict taken
  for (uint64_t count = 1; count < 10000; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
    // assert predicted true
    EXPECT_EQ(out, 1);
  }
}
// Check that we always predict not taken if history is always not taken
TEST(PerceptronTests, PredFalseTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count < 100; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 0, 3);
  }

  // Check that we always predict taken
  for (uint64_t count = 1; count < 10000; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 0, 3);
    // assert predicted true
    EXPECT_EQ(out, 0);
  }
}

int main(int argc, char** argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}