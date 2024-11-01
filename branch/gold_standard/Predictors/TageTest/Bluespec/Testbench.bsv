import LFSR::*;



(* synthesize *)
module mkTestbench(Empty);
    Reg#(Bool) starting <- mkReg(True);
    LFSR#(Bit#(4)) random <- mkFeedLFSR( 4'h9 );
    Reg#(UInt#(5)) count <- mkReg(0);

    rule start(starting);
        starting <= False;
        random.seed(4'h2);
    endrule

    rule run (!starting);
        if(count == 20) begin
            $finish(0);
        end
        count <= count +1;
        $display("%d\n", random.value[3:2]);   
        random.next;
    endrule
endmodule