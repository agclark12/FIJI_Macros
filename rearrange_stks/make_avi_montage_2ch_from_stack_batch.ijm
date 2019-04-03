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
filelist = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(filelist); i++) {

	//get image name and slice number
	imagename = filelist[i];
	print(imagename);
	if (matches(imagename,".*tif")) {
		open(data_dir + imagename);
		stack = getInfo("image.filename");
		basename = substring(imagename, 0, lengthOf(imagename) - 4);
	
		run("Split Channels");
		selectWindow("C1-" + stack);
		//run("Enhance Contrast...", "saturated=0.01 process_all use");
		//run("8-bit");
		selectWindow("C2-" + stack);
		//run("Enhance Contrast...", "saturated=0.55 process_all use");
		//run("8-bit");
		run("Combine...", "stack1=C1-" + stack + " stack2=C2-" + stack);
		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_mont.avi" + "]");
		run("Close All");
	}
}