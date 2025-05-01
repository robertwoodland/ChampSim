// #include "../inc/ooo_cpu.h"
#include "testpred.h"
#include <gtest/gtest.h>

// TEST(SampleTest, AssertionTrue) { EXPECT_TRUE(true); }

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
  for (uint64_t count = 1; count < 200; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
  }

  // Check that we always predict taken
  for (uint64_t count = 1; count < 2000; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
    // assert predicted taken
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
  for (uint64_t count = 1; count < 200; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 0, 3);
  }

  // Check that we always predict taken
  for (uint64_t count = 1; count < 2000; count++) {
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 0, 3);
    // assert predicted not taken
    EXPECT_EQ(out, 0);
  }
}

// Check that the predictor deals well with a nested loop
TEST(PerceptronTests, PredNestedTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count < 150; count++) {
    for (uint64_t countInner = 1; countInner < 20; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 1, 3);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
  }

  // Check that we always predict taken for both inner and outer loops
  for (uint64_t count = 1; count < 50; count++) {
    for (uint64_t countInner = 1; countInner < 20; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 1, 3);
      EXPECT_EQ(out, 1);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
    EXPECT_EQ(out, 1);
  }
}

// Check that the predictor deals well with a loop containing a branch not taken inside
// This will make global history less straightforward!
TEST(PerceptronTests, PredInnerNTTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count < 50; count++) {
    for (uint64_t countInner = 1; countInner < 100; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 0, 3);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
  }

  // Check that we always predict taken for both inner and outer loops
  for (uint64_t count = 1; count < 50; count++) {
    for (uint64_t countInner = 1; countInner < 100; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 0, 3);
      EXPECT_EQ(out, 0);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
    EXPECT_EQ(out, 1);
  }
}

// Check that the predictor deals well with a loop containing a branch not taken inside
// This will make global history less straightforward!
TEST(PerceptronTests, PredInnerTTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count < 50; count++) {
    for (uint64_t countInner = 1; countInner < 100; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 1, 3);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
  }

  // Check that we always predict taken for both inner and outer loops
  for (uint64_t count = 1; count < 50; count++) {
    for (uint64_t countInner = 1; countInner < 100; countInner++) {
      // predict
      out = cpu.predict_branch(ip + 10);
      // update
      cpu.last_branch_result(ip + 10, 1, 1, 3);
      EXPECT_EQ(out, 1);
    }
    // predict
    out = cpu.predict_branch(ip);
    // update
    cpu.last_branch_result(ip, 0, 1, 3);
    EXPECT_EQ(out, 1);
  }
}

// Check that updates are made to the correct local history (black box)
TEST(PerceptronTests, PredLocalTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor for two branches
  for (uint64_t count = 1; count < 200; count++) {
    // predict 1
    out = cpu.predict_branch(ip);
    // update 1
    cpu.last_branch_result(ip, 0, 1, 3);
    // predict 2
    out = cpu.predict_branch(ip + 10);
    // update 2
    cpu.last_branch_result(ip + 10, 8, 0, 3);
  }

  // Assert that they trained correctly
  // predict 1
  out = cpu.predict_branch(ip);
  EXPECT_EQ(out, 1);

  // predict 2
  out = cpu.predict_branch(ip + 10);
  EXPECT_EQ(out, 0);
}

// Check repeated patterns are predicted well (black box)
TEST(PerceptronTests, PredPatternTest)
{
  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  uint64_t mispreds = 0;
  cpu.initialize_branch_predictor();

  // Warm up the predictor
  for (uint64_t count = 1; count <= 300; count++) {
    // predict
    out = cpu.predict_branch(ip);

    // Taken every 5th time
    if (count % 5 == 0) {
      // update
      cpu.last_branch_result(ip, 0, 1, 3);
      if (out == 0) {
        mispreds++;
      }
    } else {
      // update
      cpu.last_branch_result(ip, 0, 0, 3);
      if (out == 1) {
        mispreds++;
      }
    }
  }

  // Check that we always predict correctly
  for (uint64_t count = 1; count < 1000; count++) {
    // predict
    out = cpu.predict_branch(ip);

    if (count % 5 == 0) {
      EXPECT_EQ(out, 1);
      // update
      cpu.last_branch_result(ip, 0, 1, 3);
      if (out == 0) {
        mispreds++;
      }
    } else {
      EXPECT_EQ(out, 0);
      // update
      cpu.last_branch_result(ip, 0, 0, 3);
      if (out == 1) {
        mispreds++;
      }
    }
  }
  printf("Total mispredictions: %ld\n", mispreds);
}

// Test flush
TEST(PerceptronTests, FlushTest)
{

  uint8_t out;
  uint64_t ip = 1;
  O3_CPU cpu;
  cpu.initialize_branch_predictor();

  // Warm up the predictor for two branches
  for (uint64_t count = 1; count < 200; count++) {
    // predict 1
    out = cpu.predict_branch(ip);
    // update 1
    cpu.last_branch_result(ip, 0, 1, 3);
    // predict 2
    out = cpu.predict_branch(ip + 10);
    // update 2
    cpu.last_branch_result(ip + 10, 8, 0, 3);
  }

  // Assert that they trained correctly
  // predict 1
  out = cpu.predict_branch(ip);
  EXPECT_EQ(out, 1);

  // predict 2
  out = cpu.predict_branch(ip + 10);
  EXPECT_EQ(out, 0);

  // Flush predictor
  cpu.flush_branch_predictor();

  // Check that the predictor is reset
  for (uint64_t i = 0; i < 10; i++) {
    // Train a little to 0 and 1 (flipped from before)
    out = cpu.predict_branch(ip);
    cpu.last_branch_result(ip, 0, 0, 3);

    out = cpu.predict_branch(ip + 10);
    cpu.last_branch_result(ip + 10, 8, 1, 3);
  }

  // Pred and assert we have unlearnt (successful flush)
  out = cpu.predict_branch(ip);
  EXPECT_EQ(out, 0);

  out = cpu.predict_branch(ip + 10);
  EXPECT_EQ(out, 1);
}


int main(int argc, char** argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

// TODO (RW): Check if consecutive addresses alias

// TODO (RW): Write something to make sure bluectl exits!

// TODO (RW): Make some black box (works on any predictor) and white box (perceptron specific) tests

// Tests for bias?
// Tests against random workflow
// Etc
