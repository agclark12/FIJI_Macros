setBatchMode(true);
data_dir = getDirectory("Choose a Directory");
dir_list = getFileList(data_dir);
keyword = "GFP_s";
for (i=0;i<lengthOf(dir_list);i++) {
	filename = dir_list[i];
	if (matches(filename,".*"+keyword+".*tif")) {
		open(data_dir + filename);
		print(filename + " " + nSlices);
		close();
	}
}
