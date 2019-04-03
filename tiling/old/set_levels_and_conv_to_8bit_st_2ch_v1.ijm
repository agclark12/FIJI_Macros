//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

ch1_min = 3000;
ch1_max = 26000;
ch2_min = 450;
ch2_max = 14500;

no_positions = 9;
keyword = "reshuffled";

data_dir= "/Users/clark/Documents/Work/Data/_microscope_data/2015-05-05/stks";
dir_list = getFileList(data_dir);

for (i=1; i<no_positions+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		if (matches(filename, ".*" + keyword + ".*" + "s" + i + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			Stack.getDimensions(w, h, no_channels, no_slices, no_frames);
			Stack.setChannel(1);
			setMinAndMax(ch1_min,ch1_max);
			Stack.setChannel(2);
			setMinAndMax(ch2_min,ch2_max);
			run("8-bit");
			resetMinAndMax();
			saveAs("tiff",data_dir + "/" + replace(filename,".tif","_8bit.tif"));
			close();
		}
	}
}



		