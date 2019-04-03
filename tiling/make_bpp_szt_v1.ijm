//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

no_positions = 9;
keyword = "8bit.tif";

data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-11-18/stks";
dir_list = getFileList(data_dir);

for (i=1; i<no_positions+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		if (matches(filename, ".*" + keyword + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			//Stack.getDimensions(w, h, no_channels, no_slices, no_frames);
			//Stack.setSlice(sliceNumber);
			run("Z Project...", "projection=[Max Intensity] all");
			outPath = data_dir + "/" + filename;
			outPath = substring(outPath, 0, lengthOf(outPath) - 4);
			saveAs("tiff", outPath + "_BPP.tif");
			close();
			close();
		}
	}
}



		