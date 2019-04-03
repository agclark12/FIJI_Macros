//combines channels for several stage positions
//in a directory of images

setBatchMode(true);

data_dir = getDirectory("Choose Directory");
save_dir = data_dir + "/stks/";
File.makeDirectory(save_dir);
no_channels = getNumber("Choose the number of channels (2 or 3)",2);

if (no_channels==2) {
	//makes a dialog to set image parameters (2 channels)
	Dialog.create("Set Combined Image Stack Parameters");
	Dialog.addString("Channel 1 Keyword:","BF");
	Dialog.addString("Channel 2 Keyword:","mcherry");
	Dialog.show();
	ch1_keyword = Dialog.getString();
	ch2_keyword = Dialog.getString();
	ch3_keyword = "xxxxxxx";
	
} else if (no_channels==3) {
	//makes a dialog to set image parameters (3 channels)
	Dialog.create("Set Combined Image Stack Parameters");
	Dialog.addString("Channel 1 Keyword:","BF");
	Dialog.addString("Channel 2 Keyword:","GFP");
	Dialog.addString("Channel 3 Keyword:","mcherry");
	Dialog.show();
	ch1_keyword = Dialog.getString();
	ch2_keyword = Dialog.getString();
	ch3_keyword = Dialog.getString();
	
} else {
	exit("Please select 2 or 3 channels");
}

dir_list = getFileList(data_dir);

for (i=0; i<dir_list.length; i++) {

	filename = dir_list[i];

	if (matches(filename, ".*" + ".nd")) {
		basename = substring(filename,0,lengthOf(filename)-3);
	}
	print(basename);
	for (j=0; j<dir_list.length; j++) { 

		filename2 = dir_list[j];

		if (matches(filename2, basename + ".*" + ch1_keyword + ".*")) {
			open(data_dir + "/" + filename2);
			rename("ch1");
			Stack.getDimensions(w, h, ch, no_slices, no_frames)
		}

		if (matches(filename2, basename + ".*" + ch2_keyword + ".*")) {
			open(data_dir + "/" + filename2);
			rename("ch2");
		}		

		if (matches(filename2, basename + ".*" + ch3_keyword + ".*")) {
			open(data_dir + "/" + filename2);
			rename("ch3");
		}			
	}

	if (no_channels==2) {
		run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=[-- None --]");
		run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
		saveAs("tiff", save_dir + "/" + basename + "_" + ch1_keyword + "_" + ch2_keyword + "_comb.tif");				
	} else if (no_channels==3) {
		run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=[-- None --]");
		run("Stack to Hyperstack...", "order=xyztc channels=3 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
		saveAs("tiff", save_dir + "/" + basename + "_" + ch1_keyword + "_" + ch2_keyword + "_" + ch3_keyword + "_comb.tif");		
	}
	run("Close All");
}
