//this macro segments brightfield images and makes a binary image of the segmented region
//for semiautomated segmentation and correction on the fly

min_size = 5000

//segments image
rename("stk");
run("Make Substack...", "  slices="+getSliceNumber());
rename("slice");
//run("Enhance Contrast...", "saturated=0 equalize");
//run("Gaussian Blur...", "sigma=2");
run("Canny Edge Detector", "gaussian=2 low=0.1 high=8");
run("Maximum...", "radius=1.67");

//does some morphology and filters out small particles
run("Options...", "iterations=10 count=1 pad do=Close");
run("Fill Holes");
run("Options...", "iterations = 10 count=1 do=Open");
//run("Options...", "iterations=1 count=1 pad do=Erode");
run("Analyze Particles...", "size="+min_size+"-Infinity show=Masks clear");
run("Create Selection");
run("Fit Spline");
roiManager("Add");
close();
selectImage("slice");
close();
selectImage("stk");
roiManager("Select", roiManager("count")-1);

//waits for user to adjust segmentation
waitForUser("Click OK when finished adjusting the segmentation");

//makes a segmentation image from the segmentation region
dir = getInfo("image.directory");
filename = getInfo("image.filename");
roiManager("Add");
newImage("Untitled", "8-bit black", 1024, 1024, 1);
roiManager("Select", roiManager("count")-1);
setForegroundColor(255, 255, 255);
run("Draw", "slice");
run("Select None");
run("Save", "save="+dir+replace(filename,"crop_BF","seg"));
run("Close All");