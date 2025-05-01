import StmtFSM::*;

import "BDPI" function Action branch_pred_resp(Bit#(8) taken, Address ip);
import "BDPI" function ActionValue#(Bit#(160)) recieve();
import "BDPI" function Action set_file_descriptors;
import "BDPI" function Action debug;
import Assert::*;
import Types::*;
import ProcTypes::*;
import Vector::*;
import FIFO::*;
import FIFOF::*;
import BrPred::*;
import Perceptron::*;
// import GSelectPred::*;
// import GSharePred::*;
// import TourPred::*;
// import TourPredSecure::*;

typedef UInt#(64) Address;

typedef struct {
    UInt#(64) ip;
    UInt#(64) target;
    UInt#(8) taken;
    UInt#(8) branch_type;
} BranchUpdateInfo deriving(Bits, Eq, FShow);

typedef union tagged{
  BranchUpdateInfo UpdateReq;
  Address PredictReq;
  Bit#(1) FlushReq;
} Message deriving(Bits, Eq, FShow);

(* synthesize *)
module mkTestbench(Empty);
    DirPredictor#(PerceptronTrainInfo) myPredictor <- mkPerceptron();
    FIFO#(Tuple2#(PerceptronTrainInfo, Bool)) pendingUpdates <- mkSizedFIFO(35);
    
    function ActionValue#(Bit#(8)) predict(Address ip) = actionvalue
      Bit#(1) supScalarIndex = 0;
      DirPredResult#(PerceptronTrainInfo) pred <- myPredictor.pred[supScalarIndex].pred();
      // print taken!
      // $display("BSV TestFSM Predict IP: %d, taken: %d", ip, pred.taken); // Wrong!
      pendingUpdates.enq(tuple2(pred.train, pred.taken));
      return zeroExtend(pack(pred.taken));
    endactionvalue; // TODO (RW): Could have this write straight to register

    function Action update(Tuple2#(PerceptronTrainInfo, Bool) b, Bool truthTaken) = action
      PerceptronTrainInfo trainInfo = tpl_1(b);
      Bool predTaken = tpl_2(b);
      myPredictor.update(truthTaken, trainInfo, (truthTaken != predTaken));
    endaction;

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
      else if (t == fromInteger(2)) begin
        ret = UpdateReq(convertUpdate(m));
      end
      else begin
        ret = FlushReq(1); // Probs works?
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

    function Bool isUpdate(Message m);
      Bool x = False;
      case(m) matches
        tagged UpdateReq .ur : x = True;
      endcase
      return x;
    endfunction

    Reg#(BranchUpdateInfo) updateInfo <- mkReg(?);
    Reg#(Bit#(8)) prediction <- mkReg(0);
    Reg#(Bit#(8)) pred <- mkRegU();
    Reg#(Bool) debug <- mkReg(?);
    Reg#(Bit#(16)) temp <- mkReg(0);
    FIFOF#(Message) recieveFIFO <- mkFIFOF1;
    FIFOF#(Address) predReqFIFO <- mkFIFOF1;
    Reg#(Bool) init <- mkReg(True);

    
    // rule showCycles;
    //   $display("Cycle. FIFO: %b", predReqFIFO.notEmpty);
    // endrule

    rule initFsm(init);
      set_file_descriptors;
      let a <- $test$plusargs("DEBUG"); 
      debug <= a;
      init <= False;
    endrule

    rule recieveMessage(!init && !predReqFIFO.notEmpty); // Can only run if FIFO empty
      let a <- recieve; 
      let message = convertToMessage(a);
      recieveFIFO.enq(message);
    endrule

    rule handlePred(isPred(recieveFIFO.first()));
      let message = recieveFIFO.first();
      recieveFIFO.deq();
      // $display("BSV TestFSM Predict IP: %d", message.PredictReq);
      myPredictor.nextPc(pack(message.PredictReq));
      predReqFIFO.enq(message.PredictReq);      
    endrule  

    rule handleUpdate(isUpdate(recieveFIFO.first()));
      let message = recieveFIFO.first();
      recieveFIFO.deq();
      // $display("BSV TestFSM Update IP: %d, target: %d, taken: %d, Type %d:", message.UpdateReq.ip, message.UpdateReq.target, message.UpdateReq.taken, message.UpdateReq.branch_type);
      update(pendingUpdates.first(), (message.UpdateReq.taken == 1)); // TODO (RW): Check that FIFO is in the right order
      pendingUpdates.deq();
    endrule

    rule handleFlush(!isPred(recieveFIFO.first()) && !isUpdate(recieveFIFO.first()));
      recieveFIFO.deq();
      myPredictor.flush();
    endrule

    rule doPrediction;
      // $display("BSV TestFSM Prediction Rule");
      let predReq = predReqFIFO.first();
      predReqFIFO.deq();
      let pred <- predict(predReq); 
      if(debug) debugPredictionReq(predReq);
      branch_pred_resp(pred, predReq);
    endrule

  // mkAutoFSM(stmt);
endmodule
