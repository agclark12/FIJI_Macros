//This script will isolate specific slices from hyperstacks in a directory
//and save a new image of the isolated slices

setBatchMode(false);

//select directory
directory = getDirectory("Image directory containing files");
save_dir = directory + "slices/";
File.makeDirectory(save_dir);

//open file and generate slice list
infile = File.openAsString(directory + "slice_list.dat");
slice_list = split(infile,"\n");

//loop through slice list, isolate slices and save
for (i = 1; i < slice_list.length; i++) {

	//get image name and slice number
	line = split(slice_list[i]);
	imagename = line[0];
	slice_nos = line[1];
	print(imagename);
	basename = substring(imagename, 0, lengthOf(imagename) - 4);
	slice_no_list = split(slice_nos,",");
	Array.print(slice_no_list);



	//open image and isolate slice
	//run("Bio-Formats Importer", "open=" + directory + imagename + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	open(directory + imagename);
	rename("stk");
	toggle = true;

	for (j=0; j<slice_no_list.length; j++) {
		print(j);
		selectWindow("stk");
		print(slice_no_list[j]);
		run("Duplicate...", "title=current duplicate slices="+slice_no_list[j]+" frames="+(j+1));
		if (toggle) {
			rename("stk_new");
			toggle = false;
		} else {
			run("Concatenate...", "title=stk_new open image1=stk_new image2=current");
		}
	}
	
	//save
	saveAs("tiff", save_dir + basename + "_z_shifted.tif");
	run("Close All");

}