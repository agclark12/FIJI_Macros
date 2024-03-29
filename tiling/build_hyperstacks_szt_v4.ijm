//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//v4 does this without using Open Image Sequence because sometimes this
//command hangs for some reason. The images are opened sequentially and concatenated

setBatchMode(true);

data_dir = getDirectory("Choose Directory");

//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("Image Keyword", "mCherry");
Dialog.addNumber("Number of Positions:", 10);
Dialog.addNumber("Start Position:", 1);
Dialog.addNumber("Number of Time Frames:", 53);
Dialog.addNumber("Number of Z-Slices:",35);
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

	//converts to a hyperstack with the proper dimensions and makes projection if necessary
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	run("Z Project...", "projection=[Max Intensity] all");
	
	//saves image
	outPath = save_dir + "/" + keyword + "_s" + i + ".tif";
	print(outPath);
	saveAs("tiff", outPath);
	run("Close All");
	run("Collect Garbage");
}

setBatchMode(false);