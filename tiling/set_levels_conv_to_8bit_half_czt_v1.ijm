//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

setBatchMode(true);

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

//gets min and max bounds for each channel
data_dir = getDirectory("Which Directory?");
dir_list = getFileList(data_dir);
keyword = "TRANS";

for (i=0; i<lengthOf(dir_list); i++) {

	filename = dir_list[i];
	if (matches(filename, ".*" + keyword + ".*")) {

		//opens file
		print(filename);
		open(data_dir + "/" + filename);
		basename = substring(filename, 0, lengthOf(filename) - 4);
		Stack.getDimensions(width, height, channels, slices, frames);
		rename("stk");

		//set levels and convert to 8-bit
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

		saveAs("tiff",data_dir + basename + "_small.tif");
		close();
	}
}			

		