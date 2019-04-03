//makes a .avi from a single slice of a multi-channel hyperstack
//The slices and stack names are dictated by a file within the directory
//called "slice_list.dat" The format of this should be:
//"filename slice_number"

px_size = 6.45/63; //in microns
time_int = 5; //in minutes
sb_size = 20; //in microns
keyword = ".*bpp.tif"

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
	if (matches(imagename,keyword)) {
		open(data_dir + imagename);
		stack = getInfo("image.filename");
		basename = substring(imagename, 0, lengthOf(imagename) - 4);
	
		run("Split Channels");
		selectWindow("C1-" + stack);
		run("Enhance Contrast...", "saturated=0.25 process_all use");
		run("8-bit");
		selectWindow("C2-" + stack);
		run("Enhance Contrast...", "saturated=0.25 process_all use");
		run("8-bit");

		//C1 (red);
		//C2 (green);
		//C3 (blue);
		//C4 (gray);
		//C5 (cyan);
		//C6 (magenta);
		//C7 (yellow);
		run("Merge Channels...", "c2=C1-" + stack +  " c6=C2-" + stack + " keep");
		run("RGB Color", "frames");	
		rename("merge");

		selectWindow("C1-" + stack);
		run("RGB Color", "frames");	
		selectWindow("C2-" + stack);
		run("RGB Color", "frames");			

		run("Combine...", "stack1=C1-" + stack + " stack2=C2-" + stack);
		run("RGB Color", "frames");	
		run("Combine...", "stack1=[Combined Stacks] stack2=merge");

		//adds scale bar
		run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
		w = getWidth();
		h = getHeight();
		makeRectangle(w-200, h-40, 10, 10);
		run("Scale Bar...", "width=" + sb_size + " height=12 font=50 color=White background=None location=[At Selection] bold hide label");

		//adds time stamp
		setForegroundColor(255, 255, 255);
		run("Time Stamper", "starting=0 interval=" + time_int + " x=-60 y=100 font=100 '00 decimal=0 anti-aliased or=sec");
		//saveAs("tiff", dir + basename +  "_comb.tif");

		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_mont_w" + sb_size + "umSB.avi" + "]");
		run("Close All");
	}
}