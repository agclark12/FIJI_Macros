//adjusts the positions of slices for a tz hyperstack according to a slice list
//in v3, instead of using a list that is found manually, the z-histograms are matched to get the shift
//also v3 works in batch and just used TransformJ to do the shifting instead of doing the shift manually
//v4 keeps the same scheme for doing the shifts, but finds the key frame using the brightest frame

setBatchMode(true);

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

function shift_slices() {

	//set buffer range of images above/below for final image
	buffer = 13;
	ch_to_register = 1; //this channel will be used to find the shifts, all channels will be shifted equally

	getDimensions(width, height, channels, slices, frames);
	rename("orig");

	//generates the slice list for aligning slices
	print("Generating slice list");
	Stack.setChannel(ch_to_register);
	shift_list = newArray(frames);
	shift_list[0] = 0;
	for (i=1;i<frames+1;i++) {
		Stack.setFrame(i);
		slice_idx_list = newArray(slices);
		int_list = newArray(slices);
		for (j=1;j<slices+1;j++) {
			Stack.setSlice(j);
			getRawStatistics(nPixels, mean, min, max, std, histogram);
			int_list[j-1] = mean;
			slice_idx_list[j-1] = j;
		}

		//fits the intensity profile with a Gaussian
		brightest_slice = find_brightest_slice_hstk();
		shift_list[i-1] = brightest_slice - shift_list[0];
	}

	Array.print(shift_list);
	
	//make new hyperstack for saving the shifted results
	run("Duplicate...", "duplicate frames=1");
	rename("shifted");
	run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames=1 display=Grayscale");
	
	//loops through the frames and shifts the slices
	for (i=2;i<frames+1;i++) {
	//for (i=2;i<5;i++) {
		
		print("Shifting frame "+i+"/"+frames);
		selectWindow("orig");
		run("Duplicate...", "duplicate frames="+i+"-"+i+" channels=1-"+channels);
		run("TransformJ Translate", "x-distance=0.0 y-distance=0.0 z-distance="+-shift_list[i-1]+" interpolation=Linear background=0.0");
		rename("current");
		run("Concatenate...", "  title=tmp image1=shifted image2=current image3=[-- None --]");
		//print(nSlices);
		run("Stack to Hyperstack...", "order=xyztc channels="+channels+" slices="+slices+" frames="+i+" display=Grayscale");
		rename("shifted");
		selectWindow("orig-1");
		close();
		//setBatchMode("Stop and Display");
		//stop
	}
}

function main() {

	//gets directory and file list
	data_dir = getDirectory("Choose a Directory");
	print(data_dir);
	//data_dir = "/Users/clark/Documents/Work/Data/_microscope_data/2019-05-27_spinning2/";
	dir_list = getFileList(data_dir);
	for (idx=0;idx<lengthOf(dir_list);idx++) {
		if (matches(dir_list[idx],".*tif")) {
			filename = dir_list[idx];
			print(filename);
			base_name = substring(filename, 0, lengthOf(filename) - 4);
			img_path = data_dir + filename;
	
			//opens image and shifts the stack
			open(img_path);
			shift_slices();
	
			//save new stack and close everything
			print("Saving Shifted Stack");
			saveAs("tiff", data_dir + base_name +  "_shifted.tif");
			run("Close All");
		}
	}
}

main();
print("All Done!");
	