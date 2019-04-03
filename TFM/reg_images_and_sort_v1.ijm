//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

setBatchMode(true);

data_dir = getDirectory("Choose Directory");


//makes a dialog to set image parameters
Dialog.create("Set Image Stack Parameters");
Dialog.addString("BF Keyword", "BF-spinning");
Dialog.addString("Bead Keyword", "QUAD-GFP");
Dialog.addNumber("Number of Positions:", 8);
Dialog.addNumber("Start Position:", 1);
Dialog.addNumber("Number of Time Frames:", 65);
Dialog.addNumber("Number of Z-Slices:", 31);
Dialog.show();
bf_keyword = Dialog.getString();
bead_keyword = Dialog.getString();
no_positions = Dialog.getNumber();
start_position = Dialog.getNumber();
no_frames = Dialog.getNumber();
no_slices = Dialog.getNumber();

dir_list = getFileList(data_dir);
trypsin_dir = data_dir + "trypsin_reg/";
File.makeDirectory(trypsin_dir);

//loops through data directory
for (i=start_position; i<start_position+no_positions; i++) {

	print("working on s" + i);
	save_dir = data_dir + "s" + i + "/";
	File.makeDirectory(save_dir);

	//opens the bead images and adds the trypsin image at t=0
	print("opening bead image");
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + bead_keyword + ".*_s" + i + "_t.*TIF)] sort");
	rename("beads");
	run("Image Sequence...", "open=" + data_dir + "/trypsin/" + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + bead_keyword + ".*_s" + i + "_t.*TIF)] sort");
	rename("trypsin");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=[trypsin] image2=[beads] image3=[-- None --]");
	rename("beads");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames+1 + " display=Grayscale");
	
	//opens the bf images and adds the trypsin image at t=0
	print("opening brightfield image");
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + bf_keyword + ".*_s" + i + "_t.*TIF)] sort");
	rename("bf");
	run("Image Sequence...", "open=" + data_dir + "/trypsin/" + " number=" + no_frames + " starting=1 increment=1 scale=100 file=[(.*" + bf_keyword + ".*_s" + i + "_t.*TIF)] sort");
	rename("trypsin");
	resetMinAndMax();
	run("Concatenate...", "  title=[Concatenated Stacks] image1=[trypsin] image2=[bf] image3=[-- None --]");
	rename("bf");

	//multiplies bf image so it's same number of slices as beads
	print("multiplying brightfield image");
	selectWindow("bf");
	run("Duplicate...", "duplicate");
	rename("bf2");
	for (j=0; j<no_slices-1; j++) {
		print("slice " + j);
		selectWindow("bf2");
		run("Duplicate...", "duplicate");
		rename("tmp");
		run("Concatenate...", "  title=[Concatenated Stacks] image1=[bf] image2=[tmp] image3=[-- None --]");
		rename("bf");
	}	
	run("Stack to Hyperstack...", "order=xyctz channels=1 slices=" + no_slices + " frames=" + no_frames+1 + " display=Grayscale");
	selectWindow("bf2");
	close();

	//combines the bead and bf stacks
	print("combining stacks");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=[beads] image2=[bf] image3=[-- None --]");
	run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames+1 + " display=Grayscale");

	//registers the stacks
	print("registering stacks");
	//run("Correct 3D drift", "channel=1");
	run("Correct 3D drift", "channel=1 use choose=" + save_dir); //uses virtual stack

	//saves the trypsin images
	print("saving trypsing images");
	run("Duplicate...", "title=current duplicate channels=1 frames=1");
	run("Grays");
	saveAs(trypsin_dir + "beads" + "_s" + i + "_t1.tif");
	close();
	run("Duplicate...", "title=current duplicate channels=2 frames=1");
	run("Grays");
	saveAs(trypsin_dir + "cells" + "_s" + i + "_t1.tif");
	close();	

	//saves the registered beads and bf images
	print("saving registered time points");
	for (j=1; j<no_frames+1; j++) {
		run("Duplicate...", "title=current duplicate channels=1 frames=" + j+1);
		run("Grays");
		saveAs(save_dir + "beads" + "_s" + i + "_t" + j + ".tif");
		close();
		run("Duplicate...", "title=current duplicate channels=2 slices=1 frames=" + j+1);
		run("Grays");
		saveAs(save_dir + "cells" + "_s" + i + "_t" + j + ".tif");
		close();		
	}

	run("Close All");
	
}