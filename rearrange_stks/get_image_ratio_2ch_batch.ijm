//gets the intensity ratio of ch2:ch1 in batch for hyperstacks over time

setBatchMode(false);

keyword = "A431";
directory = getDirectory("Please select image directory");
dir_list = getFileList(directory);
//save_dir = getDirectory("Select Save directory");
save_dir = directory;
	
for (i = 0; i < dir_list.length; i++) {
	if (matches(dir_list[i], ".*"+keyword+".*")) {

		imagename = dir_list[i];
		open(directory + imagename);
		rename("stk");
		basename = substring(imagename, 0, lengthOf(imagename) - 4);

		getDimensions(width, height, channels, slices, frames);
		for (j=1;j<channels+1;j++) {
			selectWindow("stk");
			print(j);
			run("Duplicate...", "duplicate channels="+j);
			rename("stk-"+j);
		}

		stop
		
		
		outPath = directory + basename + "_color_corr.tif";
		saveAs(outPath);
		
		run("Close All");
	}
}

