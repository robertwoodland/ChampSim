/*
 * Generated by Bluespec Compiler, version 2024.01 (build ae2a2fc6)
 * 
 * On Sun Oct  6 02:08:50 BST 2024
 * 
 */

/* Generation options: keep-fires */
#ifndef __mkTestbench_h__
#define __mkTestbench_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"


/* Class declaration for the mkTestbench module */
class MOD_mkTestbench : public Module {
 
 /* Clock handles */
 private:
  tClock __clk_handle_0;
 
 /* Clock gate handles */
 public:
  tUInt8 *clk_gate[0];
 
 /* Instantiation parameters */
 public:
 
 /* Module state */
 public:
  MOD_Wire<tUInt8> INST_abort;
  MOD_Reg<tUInt8> INST_debug;
  MOD_Reg<tUWide> INST_message;
  MOD_Reg<tUInt8> INST_prediction;
  MOD_Reg<tUInt8> INST_running;
  MOD_Reg<tUInt8> INST_start_reg;
  MOD_Reg<tUInt8> INST_start_reg_1;
  MOD_Wire<tUInt8> INST_start_reg_2;
  MOD_Wire<tUInt8> INST_start_wire;
  MOD_Reg<tUInt8> INST_state_can_overlap;
  MOD_Reg<tUInt8> INST_state_fired;
  MOD_Wire<tUInt8> INST_state_fired_1;
  MOD_ConfigReg<tUInt8> INST_state_mkFSMstate;
  MOD_Wire<tUInt8> INST_state_overlap_pw;
  MOD_Wire<tUInt8> INST_state_set_pw;
  MOD_Reg<tUWide> INST_update;
 
 /* Constructor */
 public:
  MOD_mkTestbench(tSimStateHdl simHdl, char const *name, Module *parent);
 
 /* Symbol init methods */
 private:
  void init_symbols_0();
 
 /* Reset signal definitions */
 private:
  tUInt8 PORT_RST_N;
 
 /* Port definitions */
 public:
 
 /* Publicly accessible definitions */
 public:
  tUInt8 DEF_WILL_FIRE___me_check_11;
  tUInt8 DEF_CAN_FIRE___me_check_11;
  tUInt8 DEF_WILL_FIRE___me_check_10;
  tUInt8 DEF_CAN_FIRE___me_check_10;
  tUInt8 DEF_WILL_FIRE___me_check_9;
  tUInt8 DEF_CAN_FIRE___me_check_9;
  tUInt8 DEF_WILL_FIRE___me_check_8;
  tUInt8 DEF_CAN_FIRE___me_check_8;
  tUInt8 DEF_WILL_FIRE___me_check_7;
  tUInt8 DEF_CAN_FIRE___me_check_7;
  tUInt8 DEF_WILL_FIRE___me_check_6;
  tUInt8 DEF_CAN_FIRE___me_check_6;
  tUInt8 DEF_WILL_FIRE___me_check_5;
  tUInt8 DEF_CAN_FIRE___me_check_5;
  tUInt8 DEF_WILL_FIRE_RL_auto_finish;
  tUInt8 DEF_CAN_FIRE_RL_auto_finish;
  tUInt8 DEF_WILL_FIRE_RL_auto_start;
  tUInt8 DEF_CAN_FIRE_RL_auto_start;
  tUInt8 DEF_WILL_FIRE_RL_fsm_start;
  tUInt8 DEF_CAN_FIRE_RL_fsm_start;
  tUInt8 DEF_WILL_FIRE_RL_action_l81c38;
  tUInt8 DEF_CAN_FIRE_RL_action_l81c38;
  tUInt8 DEF_WILL_FIRE_RL_action_l80c24;
  tUInt8 DEF_CAN_FIRE_RL_action_l80c24;
  tUInt8 DEF_WILL_FIRE_RL_action_l77c33;
  tUInt8 DEF_CAN_FIRE_RL_action_l77c33;
  tUInt8 DEF_WILL_FIRE_RL_action_l76c45;
  tUInt8 DEF_CAN_FIRE_RL_action_l76c45;
  tUInt8 DEF_WILL_FIRE_RL_action_l75c28;
  tUInt8 DEF_CAN_FIRE_RL_action_l75c28;
  tUInt8 DEF_WILL_FIRE_RL_action_l73c15;
  tUInt8 DEF_CAN_FIRE_RL_action_l73c15;
  tUInt8 DEF_WILL_FIRE_RL_action_l71c9;
  tUInt8 DEF_CAN_FIRE_RL_action_l71c9;
  tUInt8 DEF_WILL_FIRE_RL_action_l70c29;
  tUInt8 DEF_CAN_FIRE_RL_action_l70c29;
  tUInt8 DEF_WILL_FIRE_RL_restart;
  tUInt8 DEF_CAN_FIRE_RL_restart;
  tUInt8 DEF_WILL_FIRE_RL_state_every;
  tUInt8 DEF_CAN_FIRE_RL_state_every;
  tUInt8 DEF_WILL_FIRE_RL_state_fired__dreg_update;
  tUInt8 DEF_CAN_FIRE_RL_state_fired__dreg_update;
  tUInt8 DEF_WILL_FIRE_RL_state_handle_abort;
  tUInt8 DEF_CAN_FIRE_RL_state_handle_abort;
  tUInt8 DEF_WILL_FIRE_RL_start_reg__dreg_update;
  tUInt8 DEF_CAN_FIRE_RL_start_reg__dreg_update;
  tUWide DEF_message___d41;
 
 /* Local definitions */
 private:
  tUWide DEF_TASK_recieve___d57;
  tUInt8 DEF_TASK_testplusargs___d37;
  tUInt64 DEF_IF_message_1_BIT_144_2_THEN_message_1_BITS_63__ETC___d76;
  tUWide DEF_update___d90;
  tUWide DEF_TASK_recieve_7_BITS_145_TO_2___d60;
  tUWide DEF_message_1_BITS_143_TO_0___d88;
  tUWide DEF_IF_TASK_recieve_7_BITS_1_TO_0_8_EQ_1_9_THEN_TA_ETC___d67;
  tUWide DEF_TASK_recieve_7_BITS_65_TO_2_1_CONCAT_TASK_reci_ETC___d66;
  tUWide DEF_TASK_recieve_7_BITS_1_TO_0_8_EQ_1_9_CONCAT_IF__ETC___d68;
  tUWide DEF_TASK_recieve_7_BITS_129_TO_66_2_CONCAT_TASK_re_ETC___d64;
 
 /* Rules */
 public:
  void RL_start_reg__dreg_update();
  void RL_state_handle_abort();
  void RL_state_fired__dreg_update();
  void RL_state_every();
  void RL_restart();
  void RL_action_l70c29();
  void RL_action_l71c9();
  void RL_action_l73c15();
  void RL_action_l75c28();
  void RL_action_l76c45();
  void RL_action_l77c33();
  void RL_action_l80c24();
  void RL_action_l81c38();
  void RL_fsm_start();
  void RL_auto_start();
  void RL_auto_finish();
  void __me_check_5();
  void __me_check_6();
  void __me_check_7();
  void __me_check_8();
  void __me_check_9();
  void __me_check_10();
  void __me_check_11();
 
 /* Methods */
 public:
 
 /* Reset routines */
 public:
  void reset_RST_N(tUInt8 ARG_rst_in);
 
 /* Static handles to reset routines */
 public:
 
 /* Pointers to reset fns in parent module for asserting output resets */
 private:
 
 /* Functions for the parent module to register its reset fns */
 public:
 
 /* Functions to set the elaborated clock id */
 public:
  void set_clk_0(char const *s);
 
 /* State dumping routine */
 public:
  void dump_state(unsigned int indent);
 
 /* VCD dumping routines */
 public:
  unsigned int dump_VCD_defs(unsigned int levels);
  void dump_VCD(tVCDDumpType dt, unsigned int levels, MOD_mkTestbench &backing);
  void vcd_defs(tVCDDumpType dt, MOD_mkTestbench &backing);
  void vcd_prims(tVCDDumpType dt, MOD_mkTestbench &backing);
};

#endif /* ifndef __mkTestbench_h__ */
