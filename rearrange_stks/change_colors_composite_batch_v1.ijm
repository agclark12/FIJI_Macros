//caution: this will overwrite your hyperstacks!!

setBatchMode(true);

data_dir = getDirectory("Choose Data Directory");
dir_list = getFileList(data_dir);
keyword = "comb.tif";

for (j=0; j<dir_list.length; j++) {
	filename = dir_list[j];
	if (matches(filename,".*"+keyword+".*")) {
		print(filename);
		open(data_dir + filename);
		Stack.setDisplayMode("composite");
		Stack.setChannel(1);
		run("Blue");
		Stack.setChannel(2);
		run("Green");
		Stack.setChannel(3);
		run("Magenta");
		Stack.setChannel(4);
		run("Grays");
		saveAs("tiff", data_dir + filename);
		run("Close All");
	}
}