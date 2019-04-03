//registers tz tiff series for a whole directory and converts to 8-bit

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
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);
save_dir = getDirectory("Directory to save files");

//save_dir = data_dir + "reg/"
//File.makeDirectory(save_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	if (matches(imagename,".*tif")) {
		
		//get image name and slice number
		print(imagename);
		open(data_dir + imagename);
		//basename = substring(imagename, 0, lengthOf(imagename) - 4);

		//converts to 8-bit
		print("converting to 8-bit");
		Stack.getDimensions(width, height, channels, slices, frames);
		for (j=1; j<channels+1; j++) {
			Stack.setChannel(j);
			idx = find_brightest_slice_hstk();
			Stack.setSlice(idx);
			resetMinAndMax();
		}
		run("8-bit");

		//correct drift
		print("correcting drift");
		run("Correct 3D drift", "channel=1");
		
		selectWindow("registered time points");
		
		//saves image
		saveAs("tiff", save_dir + replace(imagename,".tif","_reg.tif"));
		run("Close All");
		run("Collect Garbage");
	}
}