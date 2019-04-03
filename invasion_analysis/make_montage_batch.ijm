ending = ".tif"
new_ending = "_mont.tif"

dir = getDirectory("Choose directory containing stacks");
dir_list = getFileList(dir);

for (i=0; i<lengthOf(dir_list); i++) {
	filename = dir_list[i];
	if (matches(filename,".*" + ending)) {
		path = dir + filename;
		open(path);
		run("Make Montage...", "columns=" + nSlices + " rows=1 scale=1 first=1 last=5 increment=1 border=1 font=12");
		saveAs("tiff",replace(path,ending,new_ending));
		close();
		close();
	}
}
