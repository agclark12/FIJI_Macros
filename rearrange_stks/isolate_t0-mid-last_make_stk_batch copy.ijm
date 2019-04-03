//This script isolates the first frame of all images in a directory
//and combines them into a single stack. This is useful for training
//for segmentation.

function copy_slice(orig,new,slice_no) {

	selectWindow(orig);
	setSlice(slice_no);
	run("Select All");
	run("Copy");
	//close();

	selectWindow(new);
	setSlice(nSlices);
	run("Paste");
	run("Select None");
	run("Add Slice");
			
}

setBatchMode(true);
run("Close All");

//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);

toggle = 1;

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	if (matches(imagename,".*.tif")) {

		print(imagename);
		open(data_dir + imagename);
		rename("stk");
		getDimensions(width, height, channels, slices, frames);
		
		if (toggle) {
			//makes image for collecting the slices
			getDimensions(width, height, channels, slices, frames);
			newImage("master", "8-bit black", width, height, 1);
			toggle = 0;
		}


		print("go");
		copy_slice("stk","master",1);
		print("go2");
		copy_slice("stk","master",round(frames/2));
		print("go3");
		copy_slice("stk","master",frames-1);
		print("go4");

		selectWindow("stk");
		close();

	}
}

selectWindow("master");
setSlice(nSlices);
run("Delete Slice");

//make sure the stack is over time, not z (for loading in ilastik)
run("Properties...", "channels=1 slices=1 frames=" + nSlices +" unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");

//save
saveAs("tiff", data_dir + "all_t_selected.tif");
run("Close All");