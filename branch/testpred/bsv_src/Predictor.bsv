import TourPred::*;
import BrPred::*;

export mkDirPredictor;
export DirPredTrainInfo(..);

typedef TourTrainInfo DirPredTrainInfo;

module mkDirPredictor(DirPredictor#(DirPredTrainInfo));
    let m <- mkTourPred;
    return m;
endmodule