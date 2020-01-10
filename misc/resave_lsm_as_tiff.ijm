//this script just opens lsm timelapse files and resaves them somewhere else

data_dir = getDirectory("Select image directory");
save_dir = getDirectory("Select save directory");
keyword = ".lsm";
run("Close All");

setBatchMode(true);
roiManager("reset");

dir_list = getFileList(data_dir);
for (i = 0; i < dir_list.length; i++) {
	if (matches(dir_list[i],".*" + keyword + ".*")) {

		//opens the image and gets the bleach roi (always region 0)
		file_path = data_dir + dir_list[i];
		print(file_path);
		//open(data_dir + dir_list[i]);
		run("Bio-Formats", "open="+ file_path +" autoscale color_mode=Default display_rois rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		getDimensions(width, height, channels, slices, frames);
		close();
		
		//makes a mask based on the bleach roi
		newImage("mask", "8-bit black", width, height, 1);
		roiManager("Select", 0);
		run("Fill", "stack");

		//saves the stack
		open(file_path);
		run("Duplicate...", "title=stk duplicate range=1-" + (nSlices-1)); //cut off last frame because it's usually half black
		run("Grays");
		save_path = save_dir + dir_list[i];
		save_path_base = substring(save_path, 0, lengthOf(save_path) - 4);
		saveAs("Tiff", save_path_base + ".tif");
		close();

		//saves the mask
		selectWindow("mask");
		run("Select None");
		roiManager("delete"); //prevents ROI overlay from being saved
		run("Grays");
		saveAs("Tiff", save_path_base + "_mask.tif");

		//close everything
		roiManager("reset"); 
		run("Close All");
	}
}