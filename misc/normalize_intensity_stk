//normalizes intensity for a stack using the
//built-in bleach correction plugin in fiji

function find_brightest_frame(){
	max_int = 0;
	max_idx = 0;
	for (j = 1; j < nSlices+1; j++){
		getStatistics(area, mean, min, max, std, histogram);
		total_int = area * mean;
		if (total_int>max_int) {
			max_int = total_int;
			max_idx = j;
		}
	}
	return max_idx;
}

function normalize_intensity() {

	//preps image
	orig_name = getInfo("image.filename")
	rename("stk");
	run("Grays");

	//puts the brightest frame in front temporarily
	idx = find_brightest_frame();
	setSlice(idx);
	run("Duplicate...", "title=brightest");
	run("Concatenate...", "  title=concat image1=brightest image2=stk image3=[-- None --]");

	//uses bleach correction to equalize intensities
	run("Bleach Correction", "correction=[Simple Ratio]");
	run("Enhance Contrast...", "saturated=0.1 process_all use");

	//removes the extra frame in front
	setSlice(1);
	run("Delete Slice");
	rename("stk");

	//closes extra windows
	selectWindow("concat");
	close();

	//renames to original
	selectWindow("stk");
	rename(orig_name);
	
}

normalize_intensity();