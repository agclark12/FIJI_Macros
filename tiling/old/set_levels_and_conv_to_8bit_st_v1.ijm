//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

ch1_min = 550;
ch1_max = 4100;
ch2_min = 130;
ch2_max = 200;
ch3_min = 140;
ch3_max = 1800;

no_positions = 18;
start_position = 1;
keyword = "comb";

//data_dir= "/Users/clark/Documents/Work/Data/_microscope_data/2015-05-04/stks";
data_dir = getDirectory("Which dir?");

dir_list = getFileList(data_dir);

for (i=start_position; i<no_positions+start_position; i++) {

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
			Stack.setChannel(3);
			setMinAndMax(ch3_min,ch3_max);
			run("8-bit");
			resetMinAndMax();
			saveAs("tiff",data_dir + "/" + replace(filename,".tif","_8bit.tif"));
			close();
		}
	}
}



		