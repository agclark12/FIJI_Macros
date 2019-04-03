//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

setBatchMode(true);

sliceNumber = 3;

no_positions = 21;
keyword = "Ph";

//data_dir= "/Users/clark/Documents/Work/Data/_microscope_data/2015-01-23/stks";
data_dir = getDirectory("which dir?");
dir_list = getFileList(data_dir);


for (i=1; i<no_positions+1; i++) {
	
	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		print(filename);
		if (matches(filename, ".*" + keyword + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			Stack.getDimensions(w, h, no_channels, no_slices, no_frames);
			Stack.setSlice(sliceNumber);
			run("Reduce Dimensionality...", "channels frames");
			outPath = data_dir + "/" + filename;
			outPath = substring(outPath, 0, lengthOf(outPath) - 4);
			saveAs("tiff", outPath + "_z" + sliceNumber + ".tif");
			print("saved!");
			close();
		}
	}
}

setBatchMode(false);

		