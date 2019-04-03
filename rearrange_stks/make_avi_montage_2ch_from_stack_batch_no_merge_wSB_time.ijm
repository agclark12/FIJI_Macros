//makes a .avi from a single slice of a multi-channel hyperstack
//The slices and stack names are dictated by a file within the directory
//called "slice_list.dat" The format of this should be:
//"filename slice_number"

px_size = 0.3225*2; //20x, in microns (mult. because of binning)
time_int = 15; //in minutes
sb_size = 100; //in microns

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
		//run("Duplicate...", "duplicate frames=1-7");
		//rename("stk");
		//stack="stk";
		basename = substring(imagename, 0, lengthOf(imagename) - 4);	
		run("Split Channels");
		selectWindow("C1-" + stack);
		//Stack.setSlice(2);
		//run("Reduce Dimensionality...", "frames");
		run("Enhance Contrast...", "saturated=0.01 process_all use");
		run("8-bit");
		selectWindow("C2-" + stack);
		//Stack.setSlice(2);
		//run("Reduce Dimensionality...", "frames");
		run("Enhance Contrast...", "saturated=0.1 process_all use");
		run("8-bit");
		run("Combine...", "stack1=C1-" + stack + " stack2=C2-" + stack);
		
		//adds scale bar
		run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
		w = getWidth();
		h = getHeight();
		makeRectangle(w-120, h-40, 10, 10);
		run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");

		//adds time stamp
		setForegroundColor(255, 255, 255);
		run("Time Stamper", "starting=0 interval=" + time_int + " x=-30 y=80 font=50 '00 decimal=0 anti-aliased or=sec");
		//saveAs("tiff", dir + basename +  "_comb.tif");

		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_mont_w" + sb_size + "umSB.avi" + "]");
		run("Close All");
	}
}