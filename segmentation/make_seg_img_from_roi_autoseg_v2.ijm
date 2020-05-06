//this macro segments brightfield images and makes a binary image of the segmented region
//for semiautomated segmentation and correction on the fly

min_size = 5000

//segments image
rename("stk");
run("Make Substack...", "  slices="+getSliceNumber());
rename("slice");
run("Morphological Filters", "operation=Gradient element=Square radius=2");
run("Enhance Contrast...", "saturated=0 equalize");
run("Auto Threshold", "method=Otsu white");


//does some morphology and filters out small particles
run("Invert");
run("Options...", "iterations=1 count=1 pad do=Erode");
run("Fill Holes");
run("Analyze Particles...", "size="+min_size+"-Infinity show=Masks clear");
run("Options...", "iterations=10 count=1 pad do=Close");
run("Options...", "iterations = 10 count=1 do=Open");

//creates a spline for correcting the segmentation
run("Create Selection");
run("Fit Spline");
roiManager("Add");
close();
selectImage("slice");
close();
selectImage("slice-Gradient");
close();
selectImage("stk");
roiManager("Select", roiManager("count")-1);
selectImage("stk");

//waits for user to adjust segmentation
waitForUser("Click OK when finished adjusting the segmentation");

//makes a segmentation image from the segmentation region
dir = getInfo("image.directory");
filename = getInfo("image.filename");
roiManager("Add");
getDimensions(width, height, channels, slices, frames);
newImage("Untitled", "8-bit black", width, height, 1);
roiManager("Select", roiManager("count")-1);
setForegroundColor(255, 255, 255);
run("Draw", "slice");
run("Select None");
run("Save", "save="+dir+replace(filename,"crop_BF","seg"));
run("Close All");