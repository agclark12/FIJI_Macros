//registers tz tiff series for a whole directory and converts to 8-bit
//v3 only performs the registration

setBatchMode(true);

//gets directories for loading and saving
data_dir = getDirectory("Which Directory?");
dir_list = getFileList(data_dir);
save_dir = data_dir + "reg/";
File.makeDirectory(save_dir);
keyword = ".tif";

for (i=0; i<lengthOf(dir_list); i++) {

	filename = dir_list[i];
	if (matches(filename, ".*" + keyword + ".*")) {

		//opens file
		print(filename);
		open(data_dir + "/" + filename);
		basename = substring(filename, 0, lengthOf(filename) - 4);
		Stack.getDimensions(width, height, channels, slices, frames);
		rename("stk");

		//correct drift
		print("correcting drift");
		run("Correct 3D drift", "channel=1");

		selectWindow("registered time points");
		saveAs("tiff",save_dir + basename + "_reg.tif");
		run("Close All");
	}
}			

		