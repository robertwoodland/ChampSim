import GlobalBranchHistory::*;
import BranchParams::*;

// Simple folding history, no speculative update

interface FoldedHistory#(numeric type length);
    method Bit#(length) history;
    method Action updateHistory(GlobalBranchHistory#(GlobalHistoryLength) global, Bit#(1) newHistory);
endinterface

module mkFoldedHistory#(Integer histLength)(FoldedHistory#(length));
    Reg#(Bit#(length)) folded_history <- mkReg(0);
    
    method Bit#(length) history = folded_history;

    method Action updateHistory(GlobalBranchHistory#(GlobalHistoryLength) global, Bit#(1) newHistory);
        Bit#(1) new_bit = newHistory ^ folded_history[valueOf(length)-1];
        Bit#(length) new_folded_history = truncateLSB({folded_history, new_bit} << 1);

        Integer i = histLength % valueOf(length);
        Bit#(1) eliminateBit = global.history[histLength-1];
        new_folded_history[i] = new_folded_history[i] ^ eliminateBit;
        
        folded_history <= new_folded_history;
    endmethod

endmodule