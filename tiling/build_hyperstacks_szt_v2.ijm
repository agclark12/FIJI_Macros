//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

setBatchMode(true);

data_dir = getDirectory("Choose Directory");

//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("Image Keyword", "Trans");
Dialog.addNumber("Number of Positions:", 10);
Dialog.addNumber("Start Position:", 3);
Dialog.addNumber("Number of Time Frames:", 53);
Dialog.addNumber("Number of Z-Slices:",1);
Dialog.show();
keyword = Dialog.getString();
no_positions = Dialog.getNumber();
start_position = Dialog.getNumber();
no_frames = Dialog.getNumber();
no_slices = Dialog.getNumber();

save_dir = data_dir + "stks";
File.makeDirectory(save_dir);

dir_list = getFileList(data_dir);
//loops through data directory
for (i=start_position; i<start_position+no_positions; i++) {
	
	//if (no_positions==1) {
	//	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + ".*" + "_t.*TIF)] sort");
	//} else {
	//	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + ".*_s" + i + "_t.*TIF)] sort");
	//}
	
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + keyword + ".*_s" + i + "_t.*TIF)] sort");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	//run("8-bit");
	outPath = save_dir + "/" + keyword + "_s" + i + ".tif";
	print(outPath);
	saveAs("tiff", outPath);
	close();
	run("Collect Garbage");
}

setBatchMode(false);