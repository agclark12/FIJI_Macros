//combines channels for several z stacks in a directory


setBatchMode(true);

ch1_keyword = "_w1 BF-spinning";
ch2_keyword = "_w2405-QUAD-QUAD";
ch3_keyword = "_w3561-QUAD-QUAD";

data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-12-04";
save_dir = data_dir + "/comb";
dir_list = getFileList(data_dir);

for (i=0; i<dir_list.length; i++) {

	filename = dir_list[i];
	if (matches(filename, ".*" + ch1_keyword + ".*")) {
		basename = substring(filename,0,indexOf(filename,ch1_keyword,0));

		for (j=0; j<dir_list.length; j++) {

			filename2 = dir_list[j];

			//gets ch1
			if (matches(filename2, ".*" + basename + ".*")) {
				if (matches(filename2, ".*" + ch1_keyword + ".*")) {
					open(data_dir + "/" + filename2);
					rename("ch1");
					no_slices = nSlices;
				}
			}

			//gets ch2
			if (matches(filename2, ".*" + basename + ".*")) {
				if (matches(filename2, ".*" + ch2_keyword + ".*")) {
					open(data_dir + "/" + filename2);
					rename("ch2");
				}
			}

			//gets ch3
			if (matches(filename2, ".*" + basename + ".*")) {
				if (matches(filename2, ".*" + ch3_keyword + ".*")) {
					open(data_dir + "/" + filename2);
					rename("ch3");
				}
			}
		}

		run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=[-- None --]");
		run("Stack to Hyperstack...", "order=xyztc channels=3 slices=" + no_slices + " frames=1 display=Grayscale");
		saveAs("tiff", save_dir + "/" + basename + "_comb.tif");
		print("Saved!");
		close();
	}
}