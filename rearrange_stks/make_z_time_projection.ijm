//this macro makes a projection over z (max) and time (mean) for compressing
//a hstk to a single frame (useful for getting an average gradient pattern, e.g.)
//this macro works in batch

function make_z_time_proj(file_path) {

	open(file_path);
	dir = getInfo("image.directory");
	im_name = getInfo("image.filename");
	rename("hstk");
	getDimensions(width, height, channels, slices, frames);

	//makes a max z-proj over all time points
	run("Z Project...", "projection=[Max Intensity] all");
	run("Enhance Contrast...", "saturated=0.3");
	run("Apply LUT", "stack");
	run("Duplicate...", " ");

	//starts a new stack to put the registered images
	newImage("registered", "8-bit", width, height, frames);

	//registers the stack
	for (j=1;j<frames+1;j++) {

		selectWindow("MAX_hstk");
		setSlice(j);
		run("Duplicate...", " ");
		rename("curr");
	
		run("TurboReg ",
			"-align " // Register 
			+ "-window curr "// Source (window reference).
			+ "0 0 " + (width - 1) + " " + (height - 1) + " " // No cropping.
			+ "-window MAX_hstk-1 " // Target (window reference).
			+ "0 0 " + (width - 1) + " " + (height - 1) + " " // No cropping.
			+ "-rigidBody " // This corresponds to rotation and translation.
			+ (width / 2) + " " + (height / 2) + " " // Source translation landmark.
			+ (width / 2) + " " + (height / 2) + " " // Target translation landmark.
			+ "0 " + (height / 2) + " " // Source first rotation landmark.
			+ "0 " + (height / 2) + " " // Target first rotation landmark.
			+ (width - 1) + " " + (height / 2) + " " // Source second rotation landmark.
			+ (width - 1) + " " + (height / 2) + " " // Target second rotation landmark.
			+ "-showOutput"); // In case -hideOutput is selected, the only way to
	
		//get the newly registered image for the current frame and convert it
		selectWindow("Output");
		setMinAndMax(0, 255);
		run("8-bit");
	
		//now add it to the registered image stack
		run("Select All");
		run("Copy");
		selectWindow("registered");
		setSlice(j);
		run("Paste");

		close("curr");
		close("Output");

	}

	//do average z projection over time
	run("Select None");
	run("Z Project...", "projection=[Average Intensity]");

	//save and close all
	path_new = dir + replace(im_name,".tif","_proj.tif");
	saveAs(path_new);
	run("Close All");
	
}

function main() {

	keyword = "mCherry"
	dir = getDirectory("Select Directory");
	dir_list = getFileList(dir);
	for (i=0;i<dir_list.length;i++) {
		filename = dir_list[i];
		if (matches(filename,".*"+keyword+".*\.tif")) {
			file_path = dir + filename;
			make_z_time_proj(file_path);
		}
	}
	
}

run("Close All");
setBatchMode(true);
main()



run("Apply LUT", "stack");
run("Duplicate...", " ");
run("TurboReg ");
selectWindow("MAX_mCherry_s22.tif");
selectWindow("Registered");
run("Z Project...", "projection=[Average Intensity]");
saveAs("Tiff", "/Users/clark/Documents/Work/Data/_microscope_data/_tmp/Luc/2021-01-28_PRIMO/dots/stks/mCherry_s22_proj.tif");
close();
close();
selectWindow("MAX_mCherry_s22-1.tif");
close();
close();
selectWindow("mCherry_s22.tif");
close();
selectWindow("mCherry_s3.tif");
resetMinAndMax();
close();
