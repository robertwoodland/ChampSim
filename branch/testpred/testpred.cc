#include <map>
#include <iostream>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

#include "ooo_cpu.h"
#include "tracereader.h"

#include "include/types.h"

#define SCRIPT_LOCATION "/home/katy/project/Predictors/ChampSim/branch/testpred/src/Build/script.sh"

void init_bsim();

namespace
{
    int req_pipe[2];
    int resp_pipe[2];
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

  std::function<void(int)> send = [fd = ::req_pipe[1]](int branch_ip){
    std::array<char, MSG_LENGTH> buff;
    buff[0] = PREDICT_REQ;
    memcpy(std::data(buff)+1, &branch_ip, sizeof(branch_ip));
    
    if(write(fd, std::data(buff), MSG_LENGTH) == -1){
      perror("Requesting prediction");
    }
  };
  
  champsim::enable_ahead_predictions(::req_pipe[1], send);
}


uint8_t O3_CPU::predict_branch(uint64_t ip)
{
   char out = 0;
   std::cout << "Predict " << ip << std::endl;
   sleep(1);
    
   if(read(resp_pipe[0], &out, 1) > 0){
     return out - '0';
   }else{
     perror("Recieving prediction");
   }
   return 1;
   
}



void O3_CPU::last_branch_result(uint64_t ip, uint64_t branch_target, uint8_t taken, uint8_t branch_type)
{
    //std::cout << "Update " << ip << " " << branch_target << " " << uint64_t(taken) << " " << uint64_t(branch_type) << std::endl;
    unsigned char buff[MSG_LENGTH];
    buff[0] = UPDATE_REQ;
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