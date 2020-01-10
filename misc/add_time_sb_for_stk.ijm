//this macro goes through a directory and adds a
//timestamp and scale bar for each image stack in a directory
//that contains a keyword

setBatchMode(true);

//px_size = 0.645; //px size in microns
//scale_bar_size = 100 //in microns
time_int = 5; //time interval in minutes

time_offset_x = 430;
time_offset_y = 120;
font_size = 85; //for timestamp
sb_height = 12; //scale bar heights


keyword = "crop_adj.tif";

text_color = "White"; //"White" or "Black"
if (matches(text_color,"Black")) {
	setForegroundColor(0,0,0);
	setBackgroundColor(0,0,0);
} else if (matches(text_color,"White")) {
	setForegroundColor(255,255,255);
	setBackgroundColor(255,255,255);
}

data_dir = getDirectory("Please select a directory containing your stacks");
dir_list = getFileList(data_dir);

for (i=0; i<lengthOf(dir_list); i++) {
	filename = dir_list[i];
	if (matches(filename, ".*" + keyword + ".*")) {
		open(data_dir + filename);
		//run("8-bit");
		img_width = getWidth();
		//run("Set Scale...", "distance=1 known=" + px_size + " unit=um");
		//run("Scale Bar...", "width=" + scale_bar_size + " height=" + sb_height + " font=14 color=" + text_color + " background=None location=[Lower Right] bold hide label");
		run("Time Stamper", "starting=0 interval=" + time_int + " x=" + img_width - time_offset_x + " y=" + time_offset_y + " font=" + font_size + " '00 decimal=0 anti-aliased or=sec");
		outPath = data_dir + substring(filename,0,lengthOf(filename)-4) + "_HHMM_w" + scale_bar_size + "umSB.tif";
		print(outPath);
		saveAs("tiff", outPath);
		outPath_avi = data_dir + substring(filename,0,lengthOf(filename)-4) + "_HHMM_w" + scale_bar_size + "umSB.avi";
		run("AVI... ", "compression=JPEG frame=12 save=" + outPath_avi);
		close();
	}
}

setBatchMode(false);