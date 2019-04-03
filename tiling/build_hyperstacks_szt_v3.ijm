//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//v3 reduces the stacks to half the size and 8-bit and
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

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);
save_dir = getDirectory("Directory to save files");

//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("Image Keyword", "spinning  mCherry");
Dialog.addNumber("Number of Positions:", 4);
Dialog.addNumber("Start Position:", 1);
Dialog.addNumber("Number of Time Frames:", 7);
Dialog.addNumber("Number of Z-Slices:", 15);
Dialog.show();
keyword = Dialog.getString();
no_positions = Dialog.getNumber();
start_position = Dialog.getNumber();
no_frames = Dialog.getNumber();
no_slices = Dialog.getNumber();

//loops through data directory
for (i=start_position; i<start_position+no_positions; i++) {

	//opens the images and puts them into a hyperstack
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + ".*_s" + i + "_t.*TIF)] sort");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	Stack.getDimensions(width, height, channels, slices, frames);
	
	//set levels and convert to 8-bit
	print("converting to 8-bit and reducing size");
	for (j=1; j<channels+1; j++) {
		Stack.setChannel(j);
		idx = find_brightest_slice_hstk();
		Stack.setSlice(idx);
		resetMinAndMax();
	}
	run("8-bit");

	//halves image size
	width_new = floor(width/2);
	height_new = floor(height/2);
	run("Size...", "width=" + width_new + " height=" + height_new + " time=" + frames + " constrain average interpolation=Bilinear");
	
	//saves
	print("saving");
	outPath = save_dir + "/" + keyword + "_s" + i + "_small.tif";
	print(outPath);
	saveAs("tiff", outPath);
	close();
}

setBatchMode(false);