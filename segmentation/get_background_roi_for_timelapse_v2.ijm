//makes an image with a background roi for normalizing density measurements over time
//from a collagen movie and segmentation image
//v2 includes an overlay of the original segmentation while choosing the reference region

function make_spline() {

	min_size = 100;
	rename("stk");
	run("Make Substack...", "  slices="+getSliceNumber());
	rename("slice");
	//run("Enhance Contrast...", "saturated=0 equalize");
	//run("Gaussian Blur...", "sigma=2");
	run("Canny Edge Detector", "gaussian=2 low=0.1 high=5");
	run("Maximum...", "radius=1.67");
	
	run("Options...", "iterations=10 count=1 pad do=Close");
	run("Fill Holes");
	//run("Options...", "iterations = 10 count=1 do=Open");
	//run("Options...", "iterations=1 count=1 pad do=Erode");
	run("Analyze Particles...", "size="+min_size+"-Infinity show=Masks clear");
	run("Create Selection");
	run("Fit Spline");
	roiManager("Add");
	close();
	selectImage("slice");
	close();
	selectImage("stk");
	close();
	
}

run("Close All");
setBatchMode(false);

key1 = "seg";
key2 = "mCherry_reg_crop";
start_pos = 1;
end_pos = 10;
data_dir = getDirectory("Choose a data directory");
dir_list = getFileList(data_dir);

for (i=start_pos;i<end_pos+1;i++) {
	print("position",i);
	for (j=0;j<lengthOf(dir_list);j++) {
		if (matches(dir_list[j],".*"+key1+"_s"+i+".tif")) {
		//if (matches(dir_list[j],".*"+key1+"_s6b.tif")) {
		//if (matches(dir_list[j],"GFP_s" + i + "_bpp_seg.tif")) {
			path1 = data_dir + dir_list[j];
			print(path1);
			open(path1);
			rename("seg");
		}
		if (matches(dir_list[j],".*"+key2+"_s"+i+".tif")) {
		//if (matches(dir_list[j],".*"+key2+"_s6b.tif")) {
		//if (matches(dir_list[j],".*"+key2+"_s"+i+"_bpp_deep.tif")) {
			path2 = data_dir + dir_list[j];
			print(path2);
			open(path2);
			rename("collagen");
		}
	}

	//gets the spline
	selectWindow("seg");
	run("Duplicate...", "title=seg2");
	make_spline();
	
	//adds the segmentation contour to the collagen image 
	selectWindow("collagen");
	getDimensions(width, height, channels, slices, frames);
	selectWindow("seg");
	for (j=1;j<slices*frames;j++) {
		run("Add Slice");
		setSlice(1);
		run("Select All");
		run("Copy");
		setSlice(j+1);
		run("Paste");
	}
	run("Select None");
	run("Merge Channels...", "c4=collagen c6=seg create");
	run("RGB Color", "slices frames");
	rename("merge");

	//put the contour roi on top to select the reference region
	roiManager("Select", roiManager("count")-1);

	//waits for user to adjust segmentation
	waitForUser("Click OK when finished selecting region for background normalization");

	//saves the background region as a contour image in the same directory
	roiManager("Add");
	getDimensions(width, height, channels, slices, frames);
	newImage("Untitled", "8-bit black", width, height, 1);
	roiManager("Select", roiManager("count")-1);
	setForegroundColor(255, 255, 255);
	run("Draw", "slice");
	run("Select None");
	run("Save", "save="+replace(path1,key1,"reference"));
	run("Close All");
}
