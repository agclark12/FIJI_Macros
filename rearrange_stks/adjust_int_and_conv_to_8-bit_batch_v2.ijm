//Makes an 8-bit image with optimized intensity for a directory of hyperstacks


function find_max_slice_hstk() {

	max_int = 0;
	max_idx = 0;
	Stack.getDimensions(w, h, ch, sl, fr);
	for (k=1;k<sl+1;k++) {
		Stack.setSlice(k);
		getStatistics(area, mean, min, max, std, histogram);
		if (mean > max_int) {
			max_int = mean;
			max_idx = k;
		}
	}
	
	return max_idx;
	
}

function convert_dir(data_dir) {

	dir_list = getFileList(data_dir);
	
	//loop through slice list, isolate slices and save
	for (i = 0; i < lengthOf(dir_list); i++) {
	
		imagename = dir_list[i];
		
		if (matches(imagename,".*" + keyword + ".*")) {
	
			basename = substring(imagename, 0, lengthOf(imagename) - 4);
			open(data_dir + imagename);
	
			Stack.getDimensions(width, height, channels, slices, frames);
			for (j=1;j<channels+1;j++) {
				Stack.setChannel(j);
				max_slice = find_max_slice_hstk();
				Stack.setSlice(max_slice);
				run("Enhance Contrast", "saturated=0.1");
			}
	
			run("8-bit");
			saveAs("Tiff",data_dir + basename + "_8bit.tif");
			run("Close All");
		
		}
	}
}


setBatchMode(true);
keyword = "comb";
run("Close All");

//select directory
data_dir = getDirectory("Image directory containing files");
convert_dir(data_dir);