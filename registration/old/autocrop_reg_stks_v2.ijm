//autocropper for timelapse (already registered) 
//v2 does the same but is a little more memory efficienct, but it (probably) only works on a single-channel movie



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


function mask_to_selection() {
	// Mask to Selection
	// Michael Schmid, version 05-Nov-2004

	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		run("Close");
	}
	
	maskImageID=getImageID();
	
	run("Select None");
	tempname=getTitle()+"-mask2roiTemp";
	unThresholded=(indexOf(getInfo(), "No Threshold")>=0); //upper and lower might be set even without thresholding
	getThreshold(lower, upper);
	run("Duplicate...", "title="+tempname);
	workImageID=getImageID();
	if(!unThresholded) {			//thresholded image to mask
	setThreshold(lower, upper);
	run("Threshold", "thresholded remaining black");
	}
	
	found=createSelection(workImageID,debug);
	selectImage(maskImageID);
	if (found) run("Restore Selection"); 	//apply selection to original image
	
	setBatchMode(false);
	if (isOpen("ROI Manager")) {
	selectWindow("ROI Manager");
	run("Close");
	}
	showStatus("Mask to Selection - Done");

} //end of macro 'Mask to Selection'
 
function find_first_min_intensity(array,val) {

	for (i=0;i<lengthOf(array);i++) {
		if (array[i] > val) {
			return(i);
		}
	}
	//return(0);
}

function autocrop_hstk(cutoff){

	print("opening stack");
	open(stk_path);
	rename("stk");
	Stack.getDimensions(width, height, channels, slices, frames);

	//gets a time projection stack
	print("doing time projection");
	rename("time_proj_stk");
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	run("Z Project...", "projection=[Max Intensity] all");
	rename("time_proj");

	//get mean intensities for each z-slice - find range where mean intensity is within 10% of max mean intensity for crop range
	selectWindow("time_proj");
	mean_int_list = newArray(nSlices);
	for (i=1;i<nSlices+1;i++) {
		setSlice(i);
		getRawStatistics(nPixels, mean, min, max, std, histogram);
		mean_int_list[i-1] = mean;
	}
	Array.getStatistics(mean_int_list, min, max, mean, stdDev);
	mean_int_list_norm = newArray(nSlices);
	for (i=0;i<lengthOf(mean_int_list_norm);i++) {
		mean_int_list_norm[i] = mean_int_list[i] / max;
	}
	start_slice = find_first_min_intensity(mean_int_list_norm,cutoff) + 1;
	Array.reverse(mean_int_list_norm);
	end_slice = lengthOf(mean_int_list_norm) - find_first_min_intensity(mean_int_list_norm,cutoff) - 1;
	run("Close All");
	run("Collect Garbage");
	
	//go to max intensity slice - going through z-slices, threshold all values over 0
	print("finding bounding box");
	open(stk_path);
	rename("stk");
	run("Z Project...", "projection=[Max Intensity] all");
	rename("z_proj");
	setThreshold(1,255); //for 8bit
	run("Threshold", "thresholded remaining black");
	run("Invert", "stack");
	run("Fill Holes", "stack");
	
	//find the minimal bounding box - this sets the ROI for cropping
	x0 = 0;
	x1 = getWidth();
	y0 = 0;
	y1 = getHeight();
	for (i=1;i<nSlices+1;i++) {
		setSlice(i);
		doWand(getWidth()/2, getHeight()/2);
		Roi.getBounds(x, y, width, height);
		if (x > x0) {
			x0 = x;
		}
		if ((width+x) < x1) {
			x1 = width+x-1; //-1 because arrays start at zero and returns here start at 1
		}
		if (y > y0) {
			y0 = y;
		}
		if ((height+y) < y1) {
			y1 = height+y-1; //-1 because arrays start at zero and returns here start at 1
		}
	}
	close();

	//crop the stack
	print("cropping stack");
	selectWindow("stk");
	//run("Specify...", "width="+x1-x0+" height="+y1-y0+" x="+x0+" y="+y0+" slice=1");
	//run("Duplicate...", "duplicate slices="+start_slice+"-"+end_slice);
	run("TransformJ Crop", "x-range="+x0+","+x1-1+" y-range="+y0+","+y1-1+" z-range="+start_slice+","+end_slice+" t-range="+1+","+frames);

	//adjust intensities
	getDimensions(w,h,ch,z,t);
	for (i=1;i<ch+1;i++1) {
		Stack.setChannel(i);
		Stack.setFrame(1);
		Stack.setSlice(find_brightest_slice_hstk());		
	}

}

function main() {

	//data_dir = getDirectory("Choose a Directory");
	data_dir = "/Users/clark/Documents/Work/Data/_microscope_data/2019-05-27_spinning2/";
	dir_list = getFileList(data_dir);
	cutoff = 0.12;
	print(data_dir);
	for (i=0;i<lengthOf(dir_list);i++) {

		//opens and crops hstk
		img_name = dir_list[i];
		Array.print(dir_list);
		print(i);
		print(img_name);
		if (endsWith(img_name, "shifted\.tif")) {
			print(img_name);
			stk_path = data_dir + "/" + dir_list[i];
			open(stk_path);
			autocrop_hstk(cutoff);
			
			//saves image and close all open windows
			saveAs(replace(stk_path,".tif","_crop.tif"));
			run("Close All");
			run("Collect Garbage");
		}
		
	}
	
}

run("Close All");
run("Collect Garbage");
setBatchMode(true);
main();