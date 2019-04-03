//Makes an 8-bit image with optimized intensity for a directory of images

keyword = "comb";

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	
	if (matches(imagename,".*" + keyword + ".*")) {

		basename = substring(imagename, 0, lengthOf(imagename) - 4);
		open(data_dir + imagename);
	
		run("Enhance Contrast...", "saturated=0.1 process_all use");
		run("8-bit");
		saveAs("Tiff",data_dir + basename + "_8bit.tif");
		run("Close All");
	
	}
}