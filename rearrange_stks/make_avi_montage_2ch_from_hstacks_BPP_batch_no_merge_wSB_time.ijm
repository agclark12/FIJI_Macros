//makes a .avi from a single slice of a multi-channel hyperstack
//The slices and stack names are dictated by a file within the directory
//called "slice_list.dat" The format of this should be:
//"filename slice_number"

px_size = 6.5/20*2; //20x, in microns (*2 because of binning)
time_int = 15; //in minutes
sb_size = 50; //in microns
ch1_keyword = "Trans";
ch2_keyword = "mCherry";
no_positions = 33;


run("Close All");
setBatchMode(1);
//select directory
data_dir = getDirectory("Image directory containing files");
print(data_dir)
save_dir = data_dir + "avi/"
File.makeDirectory(save_dir);

//open file and generate slice list
filelist = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 1; i < no_positions+1; i++) {

	for (j=0; j<filelist.length; j++) {

		filename = filelist[j];

		if (matches(filename, ".*" + ch1_keyword + ".*" + "s" + i + ".tif")) {
			//print(filename);
			open(data_dir + "/" + filename);
			rename("ch1");
			run("Enhance Contrast...", "saturated=0.01 process_all use");
			run("8-bit");
		}
		if (matches(filename, ".*" + ch2_keyword + ".*" + "s" + i + ".tif")) {
			//print(filename);
			open(data_dir + "/" + filename);
			rename("ch2_");
			Stack.getDimensions(w, h, ch, no_slices, no_frames);
			run("Z Project...", "projection=[Max Intensity] all");
			rename("ch2");
			selectWindow("ch2_");
			close();
			selectWindow("ch2");
			run("Enhance Contrast...", "saturated=0.1 process_all use");
			run("8-bit");
		}
	}

	run("Combine...", "stack1=ch1 stack2=ch2");
	
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

	run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + "comb_s" + i + "_mont_w" + sb_size + "umSB.avi" + "]");
	run("Close All");
	
}