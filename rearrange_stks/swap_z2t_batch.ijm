setBatchMode(true);

data_dir = getDirectory("Which Directory?");
file_list = getFileList(data_dir);
keyword = "s[0-9]";

for (i=0; i<lengthOf(file_list); i++) {

	filename = file_list[i];
	if (matches(filename,".*" + keyword + ".*" + "\.tif")) {
		
		open(data_dir + filename);
		run("Properties...", "channels=1 slices=1 frames=" + nSlices + " unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
		saveAs("tiff",data_dir + filename);
		close();
		
	}

}