import Types::*;
import Vector::*;

typedef struct {
    Bool taken;
    trainInfoT train; // info that a branch must keep for future training
} DirPredResult#(type trainInfoT) deriving(Bits, Eq, FShow);

interface DirPred#(type trainInfoT);
    method ActionValue#(DirPredResult#(trainInfoT)) pred;
endinterface

function Addr offsetPc(Addr pc, Integer i) = {truncateLSB(pc), pc[7:0] + (fromInteger(i)*4)};

interface DirPredictor#(type trainInfoT);
    method Action nextPc(Addr nextPc);
    interface Vector#(SupSize, DirPred#(trainInfoT)) pred;
    method Action update(Bool taken, trainInfoT train, Bool mispred);
    method Action flush;
    method Bool flush_done;
endinterface
