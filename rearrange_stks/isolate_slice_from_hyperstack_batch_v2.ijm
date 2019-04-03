setBatchMode(true);

data_dir = getDirectory("Data Directory");
dir_list = getFileList(data_dir);
save_dir = getDirectory("Select Save directory");
sliceNumber = getNumber("Slice Number: ", sliceNumber);
extension = ".tif"

for (i = 0; i < lengthOf(dir_list); i++) {
	if (endsWith(dir_list[i], extension)) {
		
		open(data_dir + dir_list[i]);
		Stack.setSlice(sliceNumber);
		run("Duplicate...", "duplicate slices="+sliceNumber);

		resetMinAndMax();
		run("8-bit");
		
		outPath = save_dir + replace(dir_list[i],extension,"_z"+sliceNumber+extension);
		saveAs("tiff", outPath);
		run("Close All");
	}
}
