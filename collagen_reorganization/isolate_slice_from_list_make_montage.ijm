//This script will isolate slices from hyperstacks in a directory
//and make multi-color montage images in a new directory
//The slices isolated are dictated by a file within the directory
//called "sliceList." The format of this should be:
//line0: "date" ... lineN: "filename sliceNumber"

setBatchMode(true);

//select directory
directory = getDirectory("Image directory containing files");
save_dir = directory + "montage/";
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

	//open image and isolate slice
	//run("Bio-Formats Importer", "open=" + directory + imagename + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	open(directory + imagename);
	rename("stk");
	Stack.setSlice(slicenumber);
	run("Reduce Dimensionality...", "channels frames");
	//run("8-bit");

	//rearrange sstack and adjust contrast
	//TODO : make BPP for actin/DAPI channels
	run("Make Substack...", "channels=3,1,4,2"); //BF, DAPI, Actin, Collagen
	//Stack.setChannel(1);
	//run("Enhance Contrast...", "saturated=0.01");
	//run("Apply LUT", "slice");
	Stack.setChannel(2);
	run("Enhance Contrast...", "saturated=0.05");	
	run("Apply LUT", "slice");
	Stack.setChannel(3);
	run("Enhance Contrast...", "saturated=0.05");
	run("Apply LUT", "slice");
	Stack.setChannel(4);
	run("Enhance Contrast...", "saturated=0.5");
	run("Apply LUT", "slice");
	
	//make merge
	run("Split Channels");
	run("Merge Channels...", "c1=C3-stk-1 c2=C4-stk-1 c3=C2-stk-1 keep"); //c1=R c2=G c3=B
	rename("merge");
	
	//convert channels to RGB
	selectWindow("C1-stk-1");
	run("RGB Color");
	selectWindow("C2-stk-1");
	run("RGB Color");
	selectWindow("C3-stk-1");
	run("RGB Color");
	selectWindow("C4-stk-1");
	run("RGB Color");

	//make montage
	run("Concatenate...", "  title=stk_new image1=C1-stk-1 image2=C2-stk-1 image3=C3-stk-1 image4=C4-stk-1 image5=merge image6=[-- None --]");
	run("Make Montage...", "columns=5 rows=1 scale=1 border=2");
	
	saveAs("tiff", save_dir + substring(imagename, 0, lengthOf(imagename) - 4) + "_z" + slicenumber +  "_merge.tif");
	run("Close All");
}
setBatchMode(false);