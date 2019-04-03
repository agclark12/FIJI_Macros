//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//data_dir = getDirectory("Choose Directory");

setBatchMode(true);

no_positions = 9;
no_frames = 171;
no_slices = 1;

ch_keyword = "BF";

data_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/microscope_data/2015-01-13";

save_dir = data_dir + "/stks";
File.makeDirectory(save_dir);

//loops through data directory
dir_list = getFileList(data_dir);

for (i=1; i<no_positions+1; i++) {
	run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=["+ ch_keyword + "_s" + i + "_t] sort");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	//rename(i);
	//run("8-bit");
	//resetMinAndMax();
	outPath = save_dir + "/" + ch_keyword + "_s" + i + ".tif";
	print(outPath);
	saveAs("tiff", outPath);
	close();
}

setBatchMode(false);