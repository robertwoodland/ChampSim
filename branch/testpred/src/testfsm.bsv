import StmtFSM::*;

import "BDPI" function Action branch_pred_resp(Bit#(8) taken, Address ip);
import "BDPI" function ActionValue#(Bit#(160)) recieve();
import "BDPI" function Action set_file_descriptors;
import "BDPI" function Action debug;
import Assert::*;
import Types::*;
import ProcTypes::*;
import Vector::*;
import BrPred::*;
import Bht::*;
// import GSelectPred::*;
// import GSharePred::*;
// import TourPred::*;
// import TourPredSecure::*;

typedef UInt#(64) Address;


// Local BHT Typedefs
typedef 128 BhtEntries;
typedef Bit#(TLog#(BhtEntries)) BhtIndex;

typedef BhtIndex BhtTrainInfo;

typedef struct {
    UInt#(64) ip;
    UInt#(64) target;
    UInt#(8) taken;
    UInt#(8) branch_type;
} BranchUpdateInfo deriving(Bits, Eq, FShow);

typedef union tagged{
  BranchUpdateInfo UpdateReq;
  Address PredictReq;
} Message deriving(Bits, Eq, FShow);

(* synthesize *)
module mkTestbench(Empty);
    DirPredictor#(BhtTrainInfo) myPredictor <- mkBht();
    
    function ActionValue #(Bit#(8)) predict(Address ip) = actionvalue
      // TODO: Set next pc before calling
      let nextPc <- myPredictor.pred[0].nextPc(ip); 
      let prediction <- myPredictor.pred[0].pred();
      return zeroExtend(pack(prediction.taken)); endactionvalue;

    method Action update(BranchUpdateInfo b);
      let index = myPredictor.getIndex(b.ip);
      BhtTrainInfo train = index;
      myPredictor.update(b.taken, index, b.branch_type);
    endmethod

    function BranchUpdateInfo convertUpdate(Bit#(160) b);
      UInt#(64) ip = unpack(b[65:2]);
      UInt#(64) target = unpack(b[129:66]);
      UInt#(8) taken = unpack(b[137:130]);
      UInt#(8) branch_type = unpack(b[145:138]);
      return BranchUpdateInfo{ip: ip, target: target, taken: taken, branch_type: branch_type};
    endfunction

    function Message convertToMessage(Bit#(160) m);
      UInt#(2) t = unpack(m[1:0]);
      Message ret;
      if (t == fromInteger(1)) begin 
        ret = PredictReq(unpack(m[65:2]));
      end
      else  begin
        ret = UpdateReq(convertUpdate(m));
      end
      return ret;
    endfunction

    function Action debugUpdate(BranchUpdateInfo b);
      $display("BSV Update IP: %d, target : %d, taken: %d, Type %d:", b.ip, b.target, b.taken, b.branch_type);
    endfunction

    function Action debugPredictionReq(Address ip);
      $display("BSV Predict IP: %d", ip);
    endfunction

    function Bool isPred(Message m);
      Bool x = False;
      case(m) matches
        tagged PredictReq .pr : x = True;
      endcase
      return x;
    endfunction

    Reg#(BranchUpdateInfo) updateInfo <- mkReg(?);
    Reg#(Bit#(8)) prediction <- mkReg(0);
    Reg#(Message) message <- mkReg(?);
    let pred <- mkReg(?);
    Reg#(Bool) debug <- mkReg(?);
    Stmt stmt = seq 
        set_file_descriptors;
        action let a <- $test$plusargs("DEBUG"); debug <= a; endaction
            while(True) seq
              action let a <- recieve; message <= convertToMessage(a); let b <- predict(message.PredictReq); pred <= b; endaction
              if (isPred(message)) seq
                prediction <= pred;
                if(debug) debugPredictionReq(message.PredictReq);
                branch_pred_resp(prediction, message.PredictReq);  
              endseq
              if (!isPred(message)) seq
                updateInfo <= message.UpdateReq;
                update(updateInfo);
                if(debug) debugUpdate(update);
              endseq
            endseq
            /*while(True) seq
              action let a <- branch_update_req; update <= a; endaction  
              debugUpdate(convertUpdate(update));
            endseq*/
        //my_display(b);
    endseq;

  mkAutoFSM(stmt);
endmodule
