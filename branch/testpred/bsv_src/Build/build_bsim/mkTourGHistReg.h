/*
 * Generated by Bluespec Compiler, version 2024.01 (build ae2a2fc6)
 * 
 * On Tue Oct 15 18:36:35 BST 2024
 * 
 */

/* Generation options: keep-fires */
#ifndef __mkTourGHistReg_h__
#define __mkTourGHistReg_h__

#include "bluesim_types.h"
#include "bs_module.h"
#include "bluesim_primitives.h"
#include "bs_vcd.h"


/* Class declaration for the mkTourGHistReg module */
class MOD_mkTourGHistReg : public Module {
 
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
  MOD_Wire<tUInt8> INST_m_addHist;
  MOD_Reg<tUInt32> INST_m_hist;
  MOD_Wire<tUInt32> INST_m_redirectHist;
 
 /* Constructor */
 public:
  MOD_mkTourGHistReg(tSimStateHdl simHdl, char const *name, Module *parent);
 
 /* Symbol init methods */
 private:
  void init_symbols_0();
 
 /* Reset signal definitions */
 private:
  tUInt8 PORT_RST_N;
 
 /* Port definitions */
 public:
  tUInt8 PORT_EN_addHistory;
  tUInt8 PORT_EN_redirect;
  tUInt8 PORT_addHistory_taken;
  tUInt8 PORT_addHistory_num;
  tUInt32 PORT_redirect_newHist;
  tUInt32 PORT_history;
  tUInt8 PORT_RDY_history;
  tUInt8 PORT_RDY_addHistory;
  tUInt8 PORT_RDY_redirect;
 
 /* Publicly accessible definitions */
 public:
  tUInt8 DEF_WILL_FIRE_redirect;
  tUInt8 DEF_WILL_FIRE_addHistory;
  tUInt8 DEF_WILL_FIRE_RL_m_canon_addHistory;
  tUInt8 DEF_CAN_FIRE_RL_m_canon_addHistory;
  tUInt8 DEF_WILL_FIRE_RL_m_canon_redirect;
  tUInt8 DEF_CAN_FIRE_RL_m_canon_redirect;
  tUInt8 DEF_CAN_FIRE_redirect;
  tUInt8 DEF_CAN_FIRE_addHistory;
  tUInt8 DEF_CAN_FIRE_history;
 
 /* Local definitions */
 private:
  tUInt32 DEF__read__h52;
 
 /* Rules */
 public:
  void RL_m_canon_redirect();
  void RL_m_canon_addHistory();
 
 /* Methods */
 public:
  tUInt32 METH_history();
  tUInt8 METH_RDY_history();
  void METH_addHistory(tUInt8 ARG_addHistory_taken, tUInt8 ARG_addHistory_num);
  tUInt8 METH_RDY_addHistory();
  void METH_redirect(tUInt32 ARG_redirect_newHist);
  tUInt8 METH_RDY_redirect();
 
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
  void dump_VCD(tVCDDumpType dt, unsigned int levels, MOD_mkTourGHistReg &backing);
  void vcd_defs(tVCDDumpType dt, MOD_mkTourGHistReg &backing);
  void vcd_prims(tVCDDumpType dt, MOD_mkTourGHistReg &backing);
};

#endif /* ifndef __mkTourGHistReg_h__ */