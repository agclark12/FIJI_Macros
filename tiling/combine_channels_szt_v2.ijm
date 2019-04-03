//combines channels for several stage positions
//in a directory of images

setBatchMode(true);

data_dir = getDirectory("Choose Directory");
no_channels = getNumber("Choose the number of channels (2 or 3)",2);

if (no_channels==2) {
	//makes a dialog to set image parameters (2 channels)
	Dialog.create("Set Combined Image Stack Parameters");
	Dialog.addNumber("Number of Positions:", 6);
	Dialog.addString("Channel 1 Keyword:","561");
	Dialog.addString("Channel 2 Keyword:","488");
	Dialog.show();
	no_positions = Dialog.getNumber();
	ch1_keyword = Dialog.getString();
	ch2_keyword = Dialog.getString();
	ch3_keyword = "xxxxxxx";
	
} else if (no_channels==3) {
	//makes a dialog to set image parameters (3 channels)
	Dialog.create("Set Combined Image Stack Parameters");
	Dialog.addNumber("Number of Positions:", 1);
	Dialog.addString("Channel 1 Keyword:","Trans DIC");
	Dialog.addString("Channel 2 Keyword:","spinning1 GFP");
	Dialog.addString("Channel 3 Keyword:","spinning 1 mCherry");
	Dialog.show();
	no_positions = Dialog.getNumber();
	ch1_keyword = Dialog.getString();
	ch2_keyword = Dialog.getString();
	ch3_keyword = Dialog.getString();
	
} else {
	exit("Please select 2 or 3 channels");
}

dir_list = getFileList(data_dir);

for (i=1; i<no_positions+1; i++) {

	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		
		//if (matches(filename, ".*" + ch1_keyword + ".*" + "s" + i + ".*tif")) {
		//if (matches(filename, ".*" + ch1_keyword + ".*" + ".tif")) {
		if (matches(filename, "20190125_" + i+ ".*" + ch1_keyword + ".*TIF")) {
			//print(filename);
			open(data_dir + "/" + filename);
			rename("ch1");
			Stack.getDimensions(w, h, ch, no_slices, no_frames);
		}
		//if (matches(filename, ".*" + ch2_keyword + ".*" + "s" + i + ".*tif")) {
		//if (matches(filename, ".*" + ch2_keyword + ".*" + ".tif")) {
		if (matches(filename, "20190125_" + i+ ".*" + ch2_keyword + ".*TIF")) {
			//print(filename);
			open(data_dir + "/" + filename);
			rename("ch2");
		}
		if (matches(filename, ".*" + ch3_keyword + ".*" + "s" + i + ".*tif")) {
			//print(filename);
			open(data_dir + "/" + filename);
			rename("ch3");
		}
	}

	if (no_channels==2) {
		run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=[-- None --]");
		run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
		saveAs("tiff", data_dir + "/" + ch1_keyword + "_" + ch2_keyword + "_comb_s" + i + ".tif");				
	} else if (no_channels==3) {
		run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=[-- None --]");
		//run("Stack to Hyperstack...", "order=xyztc channels=3 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
		saveAs("tiff", data_dir + "/" + ch1_keyword + "_" + ch2_keyword + "_" + ch3_keyword + "_comb_s" + i + ".tif");		
	}
	run("Close All");
}
