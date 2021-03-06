//makes multichannel bpp's and avi's

setBatchMode(true);

basename = "A431_wt_CollNet_DAPI_YAP488_Pan-cyto568_Phall633";
keyword_C1 = "w1TRANS"
keyword_C2 = "w2405-QUAD-DAPI"
keyword_C3 = "w3491-QUAD-GFP"
keyword_C4 = "w4561-QUAD-DsRed"
keyword_C5 = "w5642-QUAD-QUAD"

start_position = 1;
no_positions = 99; //this will just raise an error when the last position is reached

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);

save_dir = data_dir + "avi/";
File.makeDirectory(save_dir);

//loops through number of positions/examples
for (i=start_position; i<start_position+no_positions; i++) {

	print(data_dir + basename + "_" + i + "_" + keyword_C1 + ".TIF");
	print("Opening Images");

	//opens each channel
	open(data_dir + basename + "_" + i + "_" + keyword_C1 + ".TIF");
	rename("C1");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");
	getDimensions(width, height, channels, slices, frames);

	open(data_dir + basename + "_" + i + "_" + keyword_C2 + ".TIF");
	rename("C2");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");

	open(data_dir + basename + "_" + i + "_" + keyword_C3 + ".TIF");
	rename("C3");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");

	open(data_dir + basename + "_" + i + "_" + keyword_C4 + ".TIF");
	rename("C4");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");

	open(data_dir + basename + "_" + i + "_" + keyword_C5 + ".TIF");
	rename("C5");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	run("8-bit");

	//makes hyperstack
	print("Making combined hyperstack");
	run("Concatenate...", "  title=concat keep image1=C1 image2=C2 image3=C3 image4=C4 image5=C5 image6=[-- None --]");
	run("Stack to Hyperstack...", "order=xyzct channels=5 slices=" + slices + " frames=1 display=Grayscale");
	saveAs("tiff", data_dir + basename + "_" + i + "_comb.tif");

	//merges channels
	run("Merge Channels...", "c2=C3 c3=C2 c4=C4 c5=C5 create keep");
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
	run("Combine...", "stack1=[Combined Stacks] stack2=C5");
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
