//this script goes through a directory of combined (3-channel)
//image stacks for different stage positions and sets the
//fluorescence levels specified by the user and then converts
//the images to 8bit

setBatchMode(true);

keyword = ".tif";

data_dir= getDirectory("Which directory?");
dir_list = getFileList(data_dir);

for (j=0; j<dir_list.length; j++) {

	filename = dir_list[j];
	//print(filename);
	if (matches(filename, ".*" + keyword + ".*")) {
		print(filename);
		open(data_dir + "/" + filename);
		resetMinAndMax();
		run("8-bit");
		saveAs("tiff", data_dir + "/" + filename);
		close();
		}
}

setBatchMode(false);

		