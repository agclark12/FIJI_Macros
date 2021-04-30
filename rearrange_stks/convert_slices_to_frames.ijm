//Makes an 8-bit image for a directory of images

keyword = "Caco";

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	print(imagename);
	
	if (matches(imagename,".*" + keyword + ".*tif")) {

		imagepath = data_dir + imagename;
		print(imagepath);
		open(imagepath);
	
//		run("8-bit");
		run("Properties...", "channels=1 slices=1 frames="+nSlices+" pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
		saveAs("Tiff",imagepath);
		run("Close All");
	
	}
}