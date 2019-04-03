//Makes an 8-bit image for a directory of images

keyword = "seg_clean_v2.tif";

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	print(imagename);
	
	if (matches(imagename,".*" + keyword + ".*")) {

		imagepath = data_dir + imagename;
		print(imagepath);
		open(imagepath);
	
		run("8-bit");
		saveAs("Tiff",imagepath);
		run("Close All");
	
	}
}