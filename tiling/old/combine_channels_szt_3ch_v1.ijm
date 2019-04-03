//combines channels for several stage positions
//in a directory of images

setBatchMode(true);

no_positions = 8;
ch1_keyword = "BF";
ch2_keyword = "GFP";
ch3_keyword = "mcherry";

data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-11-28/stks";
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
		if (matches(filename, ".*" + ch3_keyword + ".*" + "s" + i + ".*")) {
			print(filename);
			open(data_dir + "/" + filename);
			rename("ch3");
		}
	}

	run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=[-- None --]");
	run("Stack to Hyperstack...", "order=xyztc channels=3 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	saveAs("tiff", data_dir + "/" + ch1_keyword + "_" + ch2_keyword + "_" + ch3_keyword + "_comb_s" + i + ".tif");
	print("Saved!");
	close();
}
