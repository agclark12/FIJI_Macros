//makes multichannel bpp's and avi's
//4 channels

setBatchMode(true);

keyword_C1 = "w2405-QUAD-DAPI"
keyword_C2 = "w3491-QUAD-GFP"
keyword_C3 = "w4561-QUAD-DsRed"
keyword_C4 = "w5642-QUAD-QUAD"
extension = ".TIF"

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);

save_dir = data_dir + "avi/";
File.makeDirectory(save_dir);


//goes through directory and gets all the basenames
basename_list = newArray();
for (i=0; i<lengthOf(dir_list); i++) {
	if (matches(dir_list[i],".*"+keyword_C1+extension)) {
		print(dir_list[i]);
		basename = substring(dir_list[i],0,indexOf(dir_list[i],keyword_C1));
		print(basename);
		basename_list = Array.concat(basename_list,newArray(basename));
	}
}

//goes through directory and does stuff with the images
for (i=0; i<lengthOf(basename_list); i++) {

	basename = basename_list[i];
	print(basename);

	print(data_dir + basename + keyword_C1 + extension);
	print("Opening Images");

	//opens each channel
	open(data_dir + basename + keyword_C1 + extension);
	rename("C1");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");
	getDimensions(width, height, channels, slices, frames);

	open(data_dir + basename + keyword_C2 + extension);
	rename("C2");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.5 process_all use");
	run("8-bit");

	open(data_dir + basename + keyword_C3 + extension);
	rename("C3");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.5 process_all use");
	run("8-bit");

	open(data_dir + basename + keyword_C4 + extension);
	rename("C4");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.05 process_all use");
	run("8-bit");

	/*
	open(data_dir + basename + "_" + i + "_" + keyword_C5 + ".TIF");
	rename("C5");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");
	*/

	//makes hyperstack
	print("Making combined hyperstack");
	run("Concatenate...", "  title=concat keep image1=C1 image2=C2 image3=C3 image4=C4 image5=[-- None --]");
	run("Stack to Hyperstack...", "order=xyzct channels=4 slices=" + slices + " frames=1 display=Grayscale");
	saveAs("tiff", data_dir + basename + "_" + i + "_comb.tif");

	//merges channels
	//C1 (red);
	//C2 (green);
	//C3 (blue);
	//C4 (gray);
	//C5 (cyan);
	//C6 (magenta);
	//C7 (yellow);
	run("Merge Channels...", "c2=C3 c3=C1 c6=C4 create keep");
	rename("merge");
	run("RGB Color", "slices");

	//makes avi of 3D projection of merge
	/* 
	print("Making 3D merge projection");
	selectWindow("merge");
	run("3D Project...", "projection=[Brightest Point] axis=Y-Axis slice=1 initial=0 total=360 rotation=10 lower=1 upper=255 opacity=0 surface=100 interior=50");
	run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_" + i + "_3D.avi" + "]");
	*/

	//combines stacks
	print("Combining Stacks");
	run("Combine...", "stack1=C1 stack2=C2");
	run("Combine...", "stack1=[Combined Stacks] stack2=C3");
	run("Combine...", "stack1=[Combined Stacks] stack2=C4");
	run("RGB Color", "slices");
	run("Combine...", "stack1=[Combined Stacks] stack2=merge");

	//makes avi of stack
	run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_" + i + "_mont.avi" + "]");

	//makes bpp
	print("Making BPP");
	run("Z Project...", "projection=[Max Intensity]");
	saveAs("tiff", save_dir + basename + "_" + i + "_bpp.tif");

	//closes
	run("Close All");
	
}
