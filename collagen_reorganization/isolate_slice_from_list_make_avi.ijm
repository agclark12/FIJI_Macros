//This script will isolate slices from hyperstacks in a directory
//and make multi-color montage images in a new directory
//The slices isolated are dictated by a file within the directory
//called "sliceList." The format of this should be:
//line0: "date" ... lineN: "filename sliceNumber"

setBatchMode(true);

//set some parameters
//px_size = 0.5676335358; //in microns - this should already be set, otherwise, uncomment the 'setScale command below'
//px_size = 0.1083333
time_int = 15; //in minutes
sb_size = 50; //in microns

//select directory
directory = getDirectory("Image directory containing files");
save_dir = directory + "slices/";
File.makeDirectory(save_dir);

avi_dir = directory + "avi/";
File.makeDirectory(avi_dir);

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
	run("Enhance Contrast...", "saturated=0.35");	
	run("Bleach Correction", "correction=[Simple Ratio] background=0");
	//run("Apply LUT", "slice");
	//resetMinAndMax();
	//run("8-bit");
	
	//save
	saveAs("tiff", save_dir + basename + "_z" + slicenumber +  ".tif");

	//adds scale bar
	//run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
	w = getWidth();
	h = getHeight();
	makeRectangle(w-120, h-40, 10, 10);
	run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");

	//adds time stamp
	setForegroundColor(255, 255, 255);
	run("Time Stamper", "starting=0 interval=" + time_int + " x=-60 y=80 font=70 '00 decimal=0 anti-aliased or=sec");
	//saveAs("tiff", dir + basename +  "_comb.tif");

	
	run("AVI... ", "compression=JPEG frame=12 save=[" + avi_dir + basename + "_w" + sb_size + "umSB" + ".avi" + "]");
	run("Close All");

}