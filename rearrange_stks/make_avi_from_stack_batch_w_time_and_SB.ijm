//makes .avi movies from a directory full of tiff stacks

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);
print(data_dir)
save_dir = data_dir + "avi/"
File.makeDirectory(save_dir);

//set some parameters
px_size = 6.45/20*2; //in microns (binning=2)
//px_size = 0.1083333
time_int = 15; //in minutes
sb_size = 50; //in microns

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	if (matches(imagename,".*.tif")) {
		
		//get image name and slice number
		
		open(data_dir + imagename);
		basename = substring(imagename, 0, lengthOf(imagename) - 4);
	
		//Stack.setChannel(1);
		//run("Enhance Contrast...", "saturated=0.01 process_all use");
		//run("8-bit");
	
		//adds scale bar
		run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
		w = getWidth();
		h = getHeight();
		makeRectangle(w-100, h-40, 10, 10);
		run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");
	
		//adds time stamp
		setForegroundColor(255, 255, 255);
		run("Time Stamper", "starting=0 interval=" + time_int + " x=-50 y=80 font=70 '00 decimal=0 anti-aliased or=sec");
		//saveAs("tiff", dir + basename +  "_comb.tif");
	
		
		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_w" + sb_size + "umSB" + ".avi" + "]");
		
		run("Close All");

	}
	
}