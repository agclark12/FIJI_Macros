
setBatchMode(true);

//defines some variables for going through the stacks
start_position = 1;
end_position = 18;
keyword = "comb";

//gets directory and dir list
data_dir = getDirectory("Which dir?");
dir_list = getFileList(data_dir);

//makes dir for saving
save_dir = data_dir + "reshuffled/"
File.makeDirectory(save_dir);

//reshuffles hstk
for (i=start_position; i<end_position+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		//if (matches(filename, ".*" + "_s" + i + ".*" + keyword + ".*")) {
		if (matches(filename, ".*" + keyword + ".*" + "_s" + i + ".tif")) {

			open(data_dir + filename);
			stack = getInfo("image.filename");
			basename = substring(filename, 0, lengthOf(filename) - 4);
	
			run("Split Channels");
			
			selectWindow("C1-" + stack);
			//run("Z Project...", "projection=[Average Intensity] all");
			Stack.setSlice(1);
			run("Reduce Dimensionality...", "frames");
			no_frames = nSlices;
			rename("channel1");

			selectWindow("C2-" + stack);
			run("Z Project...", "projection=[Max Intensity] all");
			//Stack.setSlice(1);
			//run("Reduce Dimensionality...", "frames");
			rename("channel2");

			selectWindow("C3-" + stack);
			Stack.setSlice(3);
			run("Reduce Dimensionality...", "frames");
			rename("channel3");

			run("Concatenate...", "  title=[Concatenated Stacks] image1=channel1 image2=channel2 image3=channel3 image4=[-- None --]");
			run("Stack to Hyperstack...", "order=xyztc channels=3 slices=1 frames=" + no_frames + " display=Grayscale");
			//run("Concatenate...", "  title=[Concatenated Stacks] image1=channel1 image2=channel2 image3=[-- None --]");
			//run("Stack to Hyperstack...", "order=xyztc channels=2 slices=1 frames=" + no_frames + " display=Grayscale");
			
			saveAs("tiff", save_dir + "/" + basename + "_reshuffled.tif");
			run("Close All");
		}
	}
	run("Close All");
}		


				