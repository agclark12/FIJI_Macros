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
//px_size = 6.45/20*1; //in microns (*binning)
px_size = 0.275
time_int = 20; //in minutes
sb_size = 50; //in microns

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {
//for (i = 0; i < 3; i++) {

	imagename = dir_list[i];
	print(imagename);
	if (matches(imagename,".*.tif")) {
		
		//get image name and slice number
		
		open(data_dir + imagename);
		basename = substring(imagename, 0, lengthOf(imagename) - 4);
		print(basename);
	
		Stack.setChannel(1);
		run("Enhance Contrast...", "saturated=1.0 process_all use");
		run("8-bit");
	
		//adds scale bar
		run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
		w = getWidth();
		h = getHeight();
		makeRectangle(w-200, h-45, 10, 10);
		run("Scale Bar...", "width=" + sb_size + " height=14 font=28 color=White background=None location=[At Selection] bold hide label");
	
		//adds time stamp
		setForegroundColor(255, 255, 255);
		run("Time Stamper", "starting=0 interval=" + time_int + " x=-140 y=140 font=100 '00 decimal=0 anti-aliased or=sec");
		//saveAs("tiff", dir + basename +  "_comb.tif");
		
		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + basename + "_w" + sb_size + "umSB" + ".avi" + "]");
		
		run("Close All");
		

	}
	
}