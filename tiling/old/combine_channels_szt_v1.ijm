//combines channels for several stage positions
//in a directory of images

no_positions = 9;
ch1_keyword = "BF";
ch2_keyword = "GFP";

//data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-02";
data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-11-18/stks";
dir_list = getFileList(data_dir);

for (i=1; i<no_positions+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		print(j);
		filename = dir_list[j];
		print(filename);
		if (matches(filename, ".*" + ch1_keyword + ".*" + "s" + i + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			rename("ch1");
			Stack.getDimensions(w, h, no_channels, no_slices, no_frames)
		}
		if (matches(filename, ".*" + ch2_keyword + ".*" + "s" + i + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			rename("ch2");
		}
	}

	run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	saveAs("tiff", data_dir + "/comb_s" + i + ".tif");
	print("Saved!");
	close();
}
