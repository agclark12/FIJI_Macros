setBatchMode(true);

data_dir = getDirectory("Data Directory");
dir_list = getFileList(data_dir);
save_dir = getDirectory("Select Save directory");
extension = ".tif"

for (i = 0; i < lengthOf(dir_list); i++) {
	if (endsWith(dir_list[i], extension)) {
		
		open(data_dir + dir_list[i]);
		Stack.setChannel(1);
		run("Duplicate...", "duplicate channels=1");

		//resetMinAndMax();
		//run("8-bit");
		run("Grays");
		
		outPath = save_dir + dir_list[i];
		saveAs("tiff", outPath);
		run("Close All");
	}
}
