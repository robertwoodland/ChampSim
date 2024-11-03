import LFSR::*;
import GlobalBranchHistory::*;
import FoldedHistory::*;
import BranchParams::*;



(* synthesize *)
module mkTestbench(Empty);
    GlobalBranchHistory#(GlobalHistoryLength) gb <- mkGLobalBranchHistory;
    FoldedHistory#(4) fh <- mkFoldedHistory(6);
    Reg#(Bool) starting <- mkReg(True);
    Reg#(UInt#(5)) count <- mkReg(0);
    Reg#(Bit#(1)) x <- mkReg(0);

    rule start(starting);
        starting <= False;
    endrule

    rule run (!starting);
        x <= ~x;
        gb.addHistory(x);
        fh.updateHistory(gb, x);
        if(count == 20) begin
            $finish(0);
        end
        count <= count +1;
        $display("%b\n", gb.history);   
        $display("%b\n", fh.history);   
        
        
        
    endrule
endmodule