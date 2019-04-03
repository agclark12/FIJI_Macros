//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

setBatchMode(true);

//defines some variables for going through the stacks
keyword = "flow";
start_position = 16;
end_position = 30;

function get_stk_range() {
	stk_min = 99999999;
	stk_max = 0;
	for (z=1; z<nSlices+1; z++) {

		setSlice(z);
		getStatistics(area_slice, mean_slice, min_slice, max_slice);
		if (min_slice<stk_min) {
			stk_min = min_slice;
		}
		if (max_slice>stk_max) {
			stk_max = max_slice;
		}
	}
	print(stk_min,stk_max);
	return newArray(stk_min, stk_max)
}

//gets directory and dir list
data_dir = getDirectory("Which dir?");
dir_list = getFileList(data_dir);

//initializes min and max bounds for each channel
ch1_min = 9999999;
ch1_max = 0;


//gets min and max bounds for each channel
//for (i=start_position; i<end_position+1; i++) {
for (i=start_position; i<1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		if (matches(filename, ".*" + keyword + ".*" + "s" + i + ".*.TIF")) {

			//opens file
			print(filename);
			open(data_dir + "/" + filename);
			Stack.getDimensions(w, h, no_channels, no_slices, no_frames);
			rename("stk");

			range = get_stk_range();
			min = range[0];
			max = range[1];
			if (min<ch1_min) {
				ch1_min = min;
			}
			if (max>ch1_max) {
				ch1_max=max;
			}

			run("Close All");
		}
	}
}			

print(ch1_min, ch1_max);

//sets min and max bounds for each channel and converts to 8-bit
for (i=start_position; i<end_position+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		if (matches(filename, ".*" + keyword + ".*" + "s" + i + ".*.tif")) {
			print(filename);
			open(data_dir + "/" + filename);
			Stack.getDimensions(w, h, no_channels, no_slices, no_frames);
			//setMinAndMax(ch1_min,ch1_max);
			run("8-bit");
			resetMinAndMax();
			saveAs("tiff",data_dir + "/" + replace(filename,".tif","_8bit.tif"));
			close();
		}
	}
}



		