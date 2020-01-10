//makes a .avi from a single slice of a multi-channel hyperstack
//The slices and stack names are dictated by a file within the directory
//called "slice_list.dat" The format of this should be:
//"filename slice_number"

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
print(data_dir)
save_dir = data_dir + "avi/"
File.makeDirectory(save_dir);

//set some parameters
px_size = 0.275; //in microns (binning=2)
time_int = 20; //in minutes
sb_size = 50; //in microns

//open file and generate slice list
infile = File.openAsString(data_dir + "slice_list.dat");
slicelist = split(infile,"\n");

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(slicelist); i++) {

	//get image name and slice number
	line = split(slicelist[i]," ");
	imagename = line[0];
	slicenumber = line[1];
	print(imagename);
	print (slicenumber);
	open(data_dir + imagename);
	basename = substring(imagename, 0, lengthOf(imagename) - 4);
	
	Stack.setSlice(slicenumber);
	run("Reduce Dimensionality...", "channels frames");
	run("Enhance Contrast...", "saturated=0.01 process_all use");
	run("8-bit");

	//adds scale bar
	run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
	w = getWidth();
	h = getHeight();
	makeRectangle(w-120, h-40, 10, 10);
	run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");

	//adds time stamp
	setForegroundColor(255, 255, 255);
	run("Time Stamper", "starting=0 interval=" + time_int + " x=-60 y=80 font=50 '00 decimal=0 anti-aliased or=sec");
	//saveAs("tiff", dir + basename +  "_comb.tif");

	
	run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_z" + slicenumber + "_w" + sb_size + "umSB" + ".avi" + "]");
	
	run("Close All");

	
}