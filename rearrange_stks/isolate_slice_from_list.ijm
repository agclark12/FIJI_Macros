//This script will isolate slices from hyperstacks in a directory
//and save a new image of the isolated slice

setBatchMode(true);

//select directory
directory = getDirectory("Image directory containing files");
save_dir = directory + "slices/";
File.makeDirectory(save_dir);

//open file and generate slice list
infile = File.openAsString(directory + "slice_list.dat");
slicelist = split(infile,"\n");

//loop through slice list, isolate slices and save
for (i = 0; i < slicelist.length; i++) {

	//get image name and slice number
	line = split(slicelist[i]," ");
	imagename = line[0];
	slicenumber = line[1];
	print(imagename);
	print (slicenumber);
	basename = substring(imagename, 0, lengthOf(imagename) - 4);

	//open image and isolate slice
	//run("Bio-Formats Importer", "open=" + directory + imagename + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	open(directory + imagename);
	rename("stk");
	Stack.setSlice(slicenumber);
	//Stack.setChannel(2); //ch2 is collagen
	run("Reduce Dimensionality...", "frames");
	
	//adjust contrast and bleach correct
	run("Enhance Contrast...", "saturated=0.1");
	run("Bleach Correction", "correction=[Simple Ratio] background=0");
	//run("Apply LUT", "slice");
	//resetMinAndMax();
	//run("8-bit");
	
	//save
	saveAs("tiff", save_dir + basename + "_z" + slicenumber +  ".tif");
	run("Close All");

}