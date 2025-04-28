// import Types::*;
// import ProcTypes::*;
import RegFile::*;
import Vector::*;
// import BrPred::*;
// import GlobalBrHistReg::*;
// import Ehr::*;
import Real::* ;

// From Lib
typedef 64 AddrSz;
typedef Bit#(AddrSz) Addr;


// Local Perceptron Typedefs
// typedef 63 PerceptronEntries; // Numeric: Size of perceptron (length of history and weights) - typically 4 to 66 depending on hardware budget.
// typedef TLog#(TAdd#(PerceptronEntries, 1)) PerceptronIndexWidth; // Numeric: Number of bits to be used for indexing history and weights. 1 is to ensure index big enough to deal with biases.
// typedef Bit#(PerceptronIndexWidth) PerceptronIndex; // Value: Bits used as the index for history and weights.

// // TODO (RW): Allow size of global history to be different to that of each local history
// typedef PerceptronEntries PerceptronGHistEntries; // Numeric: Size of global history
// typedef Bit#(PerceptronGHistEntries) PerceptronGHist; // Value: Bits used as the global history.
// typedef GlobalBrHistReg#(PerceptronGHistEntries) PerceptronGHistReg; // Register: Global history register.

typedef SizeOf#(Addr) AddrWidth; // Numeric: Number of bits in an address.
// typedef TExp#(AddrWidth) AddrRange; // Numeric: Number of addresses in the range.
// typedef TDiv#(AddrRange, TExp#(40)) PerceptronCount; // Numeric: Number of perceptrons - depends on hash function. Made smaller as would take ages to initialise...
typedef 19 PerceptronCount; // Numeric: Number of perceptrons - depends on hash function. Made smaller as would take ages to initialise...
// // TODO (RW): Make this same size as BHT. Look at papers to see what is a reasonable size.
typedef TLog#(PerceptronCount) PerceptronsRegIndexWidth; // Numeric: Number of bits to be used for indexing the Regfile of perceptrons.
typedef Bit#(PerceptronsRegIndexWidth) PerceptronsRegIndex; // Value: Bits used as the index for the Regfile.
 
// // bookkeeping info a branch should keep for future training
// typedef struct {
//     PerceptronGHist gHist;
//     PerceptronsRegIndex index;
// } PerceptronTrainInfo deriving(Bits, Eq, FShow);

// typedef Vector#(PerceptronEntries, Bool) PerceptronHistory;
// typedef Vector#(TAdd#(PerceptronEntries, 1), Int#(8)) PerceptronWeights;
// typedef Vector#(PerceptronGHistEntries, Int#(8)) PerceptronGWeights;

(* synthesize *)
module mkHashTestBench();
    Reg#(Addr) pc_reg <- mkReg(0);

    // Truncate
    function PerceptronsRegIndex getIndexTruncate(Addr pc); // TODO (RW): Try better hash functions?
        return truncate(pc >> 1); // compressed instructions
    endfunction


    // Bit Mixing
    function PerceptronsRegIndex getIndexMix(Addr pc);
        // Dynamic length based on AddrWidth
        Bit#(TDiv#(AddrWidth, 2)) low_bits = truncate(pc & ((1 << (valueOf(AddrWidth) / 2)) - 1));
        Bit#(TDiv#(AddrWidth, 2)) high_bits = truncate((pc >> (valueOf(AddrWidth) / 2)) & ((1 << (valueOf(AddrWidth) / 2)) - 1));

        // Mix the low and high bits using XOR (this helps spread out the values)
        Bit#(TDiv#(AddrWidth, 2)) mix = low_bits ^ high_bits;

        Bit#(TDiv#(AddrWidth, 2)) mask = fromInteger(valueOf(PerceptronCount) - 1); // Power of two constraint
        PerceptronsRegIndex index = truncate(mix & mask);

        // Return the final index
        return index;
    endfunction
    
    
    // Bit Folding Modulus
    function PerceptronsRegIndex getIndexMod(Addr pc);
        // Break PC into chunks of size PerceptronsRegIndexWidth
        PerceptronsRegIndex folded = 0;
        for (Integer i = 0; i < valueOf(AddrWidth); i = i + valueOf(PerceptronsRegIndexWidth)) begin
            PerceptronsRegIndex chunk = truncate(pc >> i); // get chunk of appropriate size
            folded = folded ^ chunk;       // XOR fold it in
        end

        Bit#(TAdd#(PerceptronsRegIndexWidth, 1)) temp = zeroExtend(folded);
        temp = temp % fromInteger(valueOf(PerceptronCount));
        // Try doing the expensive thing... MOD(valueOf(PerceptronCount))
        // folded = folded % fromInteger(valueOf(PerceptronCount));
        
        // Return the final index
        return truncate(temp);
    endfunction


    // Hybrid Mod & Truncate
    function PerceptronsRegIndex getIndexHybrid(Addr pc);
        PerceptronsRegIndex folded = 0;
        UInt#(TAdd#(PerceptronsRegIndexWidth, 1)) count = fromInteger(valueOf(PerceptronCount));

        // If a power of two, just truncate to size
        if ((count & (count - 1)) == 0) begin
            folded = truncate(pc >> 1); 
        end else begin
            // Break PC into chunks of size PerceptronsRegIndexWidth
            for (Integer i = 0; i < valueOf(AddrWidth); i = i + valueOf(PerceptronsRegIndexWidth)) begin
                PerceptronsRegIndex chunk = truncate(pc >> i); // get chunk of appropriate size
                folded = folded ^ chunk;       // XOR fold it in
            end

            // Try doing the expensive thing... MOD(valueOf(PerceptronCount))            
            Bit#(TAdd#(PerceptronsRegIndexWidth, 1)) temp = zeroExtend(folded);
            temp = temp % fromInteger(valueOf(PerceptronCount));
        end
        
        // Return the final index
        return folded;
    endfunction


    // Bit Folding Drop MSB
    function PerceptronsRegIndex getIndexMSB(Addr pc);
        // Break PC into chunks of size PerceptronsRegIndexWidth
        PerceptronsRegIndex folded = 0;
        for (Integer i = 0; i < valueOf(AddrWidth); i = i + valueOf(PerceptronsRegIndexWidth)) begin
            PerceptronsRegIndex chunk = truncate(pc >> i); // get chunk of appropriate size
            folded = folded ^ chunk;       // XOR fold it in
        end

        // If out of range, drop MSB
        if (folded > fromInteger(valueOf(PerceptronCount) - 1)) begin
            folded = (truncate(folded << 1) >> 1);
        end
        
        // Return the final index
        return folded;
    endfunction


    // Local variables
    PerceptronsRegIndex index;
    
    Reg#(Bool) enabled <- mkReg(True);

    rule testHashFunction(enabled);
        $display("%d:%d", pc_reg, getIndex(pc_reg));

        // TODO (RW): Do up to higher number - Toooba uses 2^63 not 63...
        if (pc_reg < 0) begin
            pc_reg <= pc_reg + 1;
        end else begin
            pc_reg <= 0;
            enabled <= False;
            $finish;
        end
    endrule

    // Hash function to get the index for the perceptron register file
    // for (Addr pc = 0; pc < (1 << valueOf(AddrWidth)); pc = pc + 1) begin
    //     pc_reg <= pc;
    //     end
    //     index = getIndex(pc);
endmodule
