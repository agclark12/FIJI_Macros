//This script shifts a stack starting from the second frame to accomodate for a sudden shift
//in the position associated with addition of a drug, etc
//The shift is performed according to a line that is drawn from the initial position (some object in the frame)
//to the position in frame 2

filename = getInfo("image.filename")
rename("stk");

//get the shift positions
getLine(x1, y1, x2, y2, lineWidth);
shift_x = x1-x2;
shift_y = y1-y2;

//duplicates the frames
run("Duplicate...", "use");
rename("t1");
selectWindow("stk");
run("Duplicate...", "duplicate range=2-"+nSlices);
rename("rest");

//shifts the rest
selectWindow("rest");
run("TransformJ Translate", "x-distance="+shift_x+" y-distance="+shift_y+" z-distance=0.0 interpolation=Linear background=0.0");

//concatenates the stacks and renames
run("Concatenate...", "image1=t1 image2=[rest translated] image3=[-- None --]");
filename_new_start = substring(filename, 0, indexOf(filename,"_s"));
filename_new_end = substring(filename, indexOf(filename,"_s"), lengthOf(filename));
filename_new = filename_new_start + "_shift" + filename_new_end;
rename(filename_new);