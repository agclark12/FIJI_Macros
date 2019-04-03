//This macro goes through a directory and makes max
//intensity projections for images in batch. The images
//should all contain a unique keyword. The images are also
//converted to 8-bit and saved.

setBatchMode(true);

function get_brightest_slice() {
	max_int = 0;
	max_slice = 1;
	for (j=1; j<nSlices+1; j++) {
		setSlice(j);
		getStatistics(area, mean, min, max, std, histogram);
		if (max > max_int) {
			max_int = max;
			max_slice = j;
		}
	}
	return(max_slice);
}

dir = getDirectory("Which Directory?");
dir_list = getFileList(dir);
keyword = getString("Please Enter the Keyword","405");

for (i=0; i<lengthOf(dir_list); i++) {
	if (matches(dir_list[i],".*" + keyword + ".*")) {
		path = dir + dir_list[i];
		open(path);
		setSlice(get_brightest_slice());
		resetMinAndMax();
		run("Z Project...", "projection=[Max Intensity]");
		run("8-bit");
		saveAs(dir + "MAX_" + dir_list[i]);
		run("Close All");
	}
}

setBatchMode(false);