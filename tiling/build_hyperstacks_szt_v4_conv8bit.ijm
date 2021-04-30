//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//v4 does this without using Open Image Sequence because sometimes this
//command hangs for some reason. The images are opened sequentially and concatenated

function find_brightest_slice_hstk() {
	brightest_idx = 1;
	brightest_val = 0;
	getDimensions(w,h,ch,z,t);
	for (j=1;j<z+1;j++) {
		Stack.setSlice(j);
		getStatistics(area, mean, min, max, std, histogram);
		if (mean>brightest_val) {
			brightest_val = mean;
			brightest_idx = j;
		}
	}
	return brightest_idx;
}

setBatchMode(true);

data_dir = getDirectory("Choose Directory");

//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("Image Keyword", "Trans");
Dialog.addNumber("Number of Positions:", 18);
Dialog.addNumber("Start Position:", 1);
Dialog.addNumber("Number of Time Frames:", 29);
Dialog.addNumber("Number of Z-Slices:", 23);
Dialog.show();
keyword = Dialog.getString();
no_positions = Dialog.getNumber();
start_position = Dialog.getNumber();
no_frames = Dialog.getNumber();
no_slices = Dialog.getNumber();

save_dir = data_dir + "stks";
File.makeDirectory(save_dir);

dir_list = getFileList(data_dir);

for (i=start_position; i<start_position+no_positions; i++) {

	print("Opening position s" + i);

	//opens the first frame
	for (k=0; k<lengthOf(dir_list); k++) {
		if (matches(dir_list[k],".*" + keyword + ".*_s" + i + "_t1.TIF")) {
			print("Opening timepoint t1");
			slice_path = data_dir + dir_list[k];
			open(slice_path);
			rename("hstk");
			dir_list = Array.deleteIndex(dir_list, k);
		}
	}

	//opens each subsequent frame and concatenates it
	for (j=2; j<no_frames+1; j++) {
		for (k=0; k<lengthOf(dir_list); k++) {
			if (matches(dir_list[k],".*" + keyword + ".*_s" + i + "_t" + j + ".TIF")) {
				print("Opening timepoint t" + j);
				slice_path = data_dir + dir_list[k];
				open(slice_path);
				rename("new_slice");
				dir_list = Array.deleteIndex(dir_list, k);
				run("Concatenate...", "  title=hstk open image1=hstk image2=new_slice");
			}
		}
	}

	//does the rest only if hstk exists (this accounts for missing positions)
	if (isOpen("hstk")) {

		//converts to a hyperstack with the proper dimensions
		run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
		
		//makes projection if necessary (comment out if unnecessary)
		//run("Z Project...", "projection=[Max Intensity] all");

		//reduces to a single z-slice if there are multiple slices if neccesary (comment out if unnecessary)
//		Stack.getDimensions(width, height, channels, slices, frames);
//		mid_plane = Math.ceil(slices/2);
//		run("Reduce Dimensionality...", "frames");
		
		//set levels and convert to 8-bit
		print("converting to 8-bit");
		Stack.getDimensions(width, height, channels, slices, frames);
		for (j=1; j<channels+1; j++) {
			Stack.setChannel(j);
			idx = find_brightest_slice_hstk();
			Stack.setSlice(idx);
			resetMinAndMax();
		}
		run("8-bit");
		
		//saves image
		outPath = save_dir + "/" + keyword + "_s" + i + ".tif";
		print(outPath);
		saveAs("tiff", outPath);
	
	} else {
		print("No data for position s"+i);	
	}

	run("Close All");
	run("Collect Garbage");
}

setBatchMode(false);