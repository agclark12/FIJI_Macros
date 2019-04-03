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
	run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_z" + slicenumber + ".avi" + "]");
}