// Simple global history
// No speculative recovery or anything

interface GlobalBranchHistory#(numeric type length);
    method Bit#(length) history;
    method Action addHistory(Bit#(1) taken);
endinterface

module mkGLobalBranchHistory(GlobalBranchHistory#(length));
    Reg#(Bit#(length)) shift_register <- mkReg(0);

    method Action addHistory(Bit#(1) taken);
        shift_register <= truncateLSB({shift_register, taken} << 1);
    endmethod

    method history = shift_register;
endmodule