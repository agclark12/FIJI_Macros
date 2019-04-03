setBatchMode(true);

no_slices = 3;

ch_keyword = "s10";
img_extension = "STK";

//data_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-09/shrunken";
data_dir = getDirectory("Which Dir?");

//loops through data directory
dir_list = getFileList(data_dir);

for (i=0; i<dir_list.length; i++) {
	if (matches(dir_list[i],".*" + ch_keyword + ".*" + img_extension)) {
		open(data_dir + "/" + dir_list[i]);
		//print(nSlices);
		if (nSlices!=no_slices) {
			print("Culprit: " + dir_list[i]);
		}
		close();
	}
}

print("Done!");