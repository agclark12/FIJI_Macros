//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//this version reduces the stacks to half the size and 8-bit and
//saves them in a user-defined directory

function find_brightest_slice_hstk() {
	brightest_idx = 1;
	brightest_val = 0;
	getDimensions(w,h,ch,z,t);
	for (j=1;j<z+1;j++) {
		Stack.setSlice(j);
		getStatistics(area, mean, min, max, std, histogram);
		if (mean>brightest_val) {
			brightest_val = mean;
			brightest_idx = j;
		}
	}
	return brightest_idx;
}

setBatchMode(true);
run("Collect Garbage");

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);
//save_dir = getDirectory("Directory to save files");
save_dir = data_dir + "stks/";
File.makeDirectory(save_dir);

//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("Image Keyword", "mCherry");
Dialog.addNumber("Start Position:", 1);
Dialog.addNumber("End Position:", 10);
Dialog.addNumber("Number of Time Frames:", 17);
Dialog.addNumber("Number of Z-Slices:", 34);
Dialog.show();
keyword = Dialog.getString();
start_position = Dialog.getNumber();
end_position = Dialog.getNumber();
no_frames = Dialog.getNumber();
no_slices = Dialog.getNumber();

//loops through data directory
for (i=start_position; i<end_position+1; i++) {

	//opens the images and puts them into a hyperstack
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + ".*_s" + i + "_t.*TIF)] sort");
	//run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + "_t.*TIF)] sort");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	Stack.getDimensions(width, height, channels, slices, frames);
	
	//set levels and convert to 8-bit
	print("converting to 8-bit");
	for (j=1; j<channels+1; j++) {
		Stack.setChannel(j);
		idx = find_brightest_slice_hstk();
		Stack.setSlice(idx);
		resetMinAndMax();
	}
	run("8-bit");
	outPath = save_dir + "/" + keyword + "_s" + i + ".tif";
	print(outPath);
	saveAs("tiff", outPath);
	run("Close All");
	run("Collect Garbage");

}

setBatchMode(false);
