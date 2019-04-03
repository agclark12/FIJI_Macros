/*
 * This script processes a directory of files, reducing the hyperstack
 * to a specified z-range and enhancing contrast (doesn't write these contrasted
 * levels to the image, it can be easily reversed and is just for ease of looking through the stack).
 *
 * Written 20 July 2017, by Andrew Clark
 */

setBatchMode(true);

extension = ".tif";

//data_dir = getDirectory("Image directory (containing " + extension + " files)");
data_dir = "/Users/clark/Documents/Work/Data/_microscope_data/2017-03-08_SDUpright/";
save_dir = data_dir + "z-cropped/"
File.makeDirectory(save_dir);

//open file and generate slice list
infile = File.openAsString(data_dir + "z_range_list.dat");
slice_list = split(infile,"\n");

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(slice_list); i++) {

	//get image name and slice number
	line = split(slice_list[i]," ");
	imagename = line[0];
	min_slice = line[1];
	max_slice = line[2];

	open(data_dir + imagename);
	run("Duplicate...", "duplicate slices=" + min_slice + "-" + max_slice);

	Stack.getDimensions(w, h, ch, no_slices, no_frames);
	Stack.setSlice(round(no_slices/2));
	run("Enhance Contrast...", "saturated=0.2");

	out_path = save_dir + replace(imagename,extension,"_z-crop.tif");
	saveAs("Tiff", out_path);
	run("Close All");
	
}