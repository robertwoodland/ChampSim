#include <map>
#include <iostream>
#include <optional>
#include <utility>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <poll.h>

#include "ooo_cpu.h"
#include "tracereader.h"

#include "include/types.h"

#define SCRIPT_LOCATION "/home/katy/project/Predictors/ChampSim/branch/testpred/src/Build/script.sh"

#ifndef DEBUG
#define DEBUG 1
#endif

#define debug_printf(fmt, ...) \
  do { if(DEBUG) { \
    printf(fmt, __VA_ARGS__); \
    }}\
  while(0);

void init_bsim();

namespace
{
    int req_pipe[2];
    int resp_pipe[2];
    std::optional<std::pair<uint64_t, uint8_t>> last_prediction{};
    struct pollfd to_poll;
    
    // Debug
    u_int64_t count = 0;

    uint64_t since_prefetch = 0;
    uint64_t total_prefetched = 0;
    uint64_t last_recieved;
    
} // namespace

// Only for numerical types
template<typename T>
void contiguous_buff(T val, unsigned char* buff, int buff_size, int start){
    int val_size = sizeof(val);
    T mask = 0xFF;
    int index = start;
    while(val_size > 0){
        buff[index] = val & mask; 
        val >>= 8; val_size--; index ++;
    }
}

void O3_CPU::initialize_branch_predictor() {
  init_bsim();

  to_poll.events = POLLIN;
  to_poll.fd = resp_pipe[0];

  std::function<void(uint64_t)> send = [fd = ::req_pipe[1]](uint64_t branch_ip){
    std::array<char, MSG_LENGTH> buff;
    debug_printf("Prediction Request %ld\n", branch_ip);
    buff[0] = PREDICT_REQ;
    memcpy(std::data(buff)+1, &branch_ip, sizeof(branch_ip));
    
    if(write(fd, std::data(buff), MSG_LENGTH) == -1){
      perror("Requesting prediction");
    }
    total_prefetched++;
  };
  
  champsim::enable_ahead_predictions(::req_pipe[1], send, &total_prefetched);
}


uint8_t O3_CPU::predict_branch(uint64_t ip)
{
   char buff[9];
   uint8_t out = 0;
   uint64_t recieved_ip;

   debug_printf("Predict %ld\n", ip);
   
   if(last_prediction){
    if((*last_prediction).first == ip){
      debug_printf("Prediction Recieved %ld\n", ip);
      out = (*last_prediction).second;
      last_prediction.reset();
      count++; last_recieved = ip;
    }
   }else{
    
    debug_printf("total prefetch: %ld, since prefetch: %ld\n", total_prefetched, count);
    if (poll(&to_poll, 1, 0)==1 || total_prefetched > count) {
      if(read(resp_pipe[0], buff, 9) > 0){
        memcpy(&recieved_ip, &buff[1], 8);
        if(recieved_ip == ip){
          out = buff[0] - '0';
          count++; last_recieved = ip;
          debug_printf("Prediction Done %ld\n", recieved_ip);
        }
        else{
          ::last_prediction = {recieved_ip, buff[0]-'0'};
        }
      }else{
        perror("Recieving prediction");
      }
    }else{
      debug_printf("Skipped %ld\n", ip);
    }
  }
  return out;
}



void O3_CPU::last_branch_result(uint64_t ip, uint64_t branch_target, uint8_t taken, uint8_t branch_type)
{
    
    debug_printf("Update %ld, branch targed: %ld, taken: %d, branch type: %d, count: %ld\n", ip, branch_target, taken, branch_type, count);
    assert(last_recieved == ip);

    unsigned char buff[MSG_LENGTH];
    buff[0] = UPDATE_REQ;

    // Use memcpy instead
    contiguous_buff<uint64_t>(ip, buff, MSG_LENGTH, 1);
    contiguous_buff<uint64_t>(branch_target, buff, MSG_LENGTH, 9);
    buff[17] = taken + '0';
    buff[18] = branch_type + '0';
    if(write(req_pipe[1], buff, MSG_LENGTH) == -1){
      perror("Requesting update");
    }
    return;
}


void init_bsim(){
  pid_t pid;

  if(pipe(::req_pipe) < 0) exit(1);
  if(pipe(::resp_pipe) < 0) exit(1);

  pid = fork();
  if(pid == -1){
    perror("Fork");
    exit(EXIT_FAILURE);
  }

  if(pid == 0){
    char run[] = SCRIPT_LOCATION;
    char* args[] = {run, NULL};
    char pred_in_arg[20], pred_out_arg[20];

    
    sprintf(pred_in_arg, "%s=%d", ENV_FIFO_IN, req_pipe[0]);
    sprintf(pred_out_arg, "%s=%d", ENV_FIFO_OUT, resp_pipe[1]);
    char* env[] = {pred_in_arg, pred_out_arg, NULL};

    execve(run, args, env);
    perror("execve");
    exit(EXIT_FAILURE);
  }
  std::cout << "Completed init\n";
}