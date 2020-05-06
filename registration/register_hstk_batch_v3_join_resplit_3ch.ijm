//registers tz tiff series for a whole directory
//v3 only performs the registration
//this version first joins two separate channels, does the registration and then re-splits channels
//so that the registration is exactly the same for the two channels
//this version works for three channels

setBatchMode(false); //don't turn this on, weird things happen with drift correction in batch mode...

//gets directories for loading and saving
data_dir = getDirectory("Which Directory?");
dir_list = getFileList(data_dir);
save_dir = data_dir + "reg/";
File.makeDirectory(save_dir);

ch1_keyword = "Trans"; //ch1 is the one used for registration
ch2_keyword = "GFP_bpp";
ch3_keyword = "mCherry_bpp";
start_position = 1;
end_position = 24;

for (i=start_position; i<end_position+1; i++) {
	print("registering position: s"+i);
	for (j=0; j<dir_list.length; j++) {

		filename = dir_list[j];
		//opens ch1
		if (matches(filename, ch1_keyword + "_s" + i + "\.tif")) {
			open(data_dir + "/" + filename);
			rename("ch1");
			Stack.getDimensions(w, h, ch, no_slices, no_frames);
		}
		//opens ch2
		if (matches(filename, ch2_keyword + "_s" + i + "\.tif")) {
			open(data_dir + "/" + filename);
			rename("ch2");
		}
		//opens ch3
		if (matches(filename, ch3_keyword + "_s" + i + "\.tif")) {
			open(data_dir + "/" + filename);
			rename("ch3");
		}
	}
	
	//combines ch1 and ch2
	run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=[-- None --]");
	run("Stack to Hyperstack...", "order=xyztc channels=3 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	rename("comb");

	//correct drift (registration)
	print("correcting drift");
	run("Correct 3D drift", "channel=1");

	//split the channels up again
	selectWindow("registered time points");
	/*	Stack.getDimensions(w, h, ch, no_slices, no_frames);
	if (ch<2) { //sometimes it makes it into a single stack for some reason
		setBatchMode("Exit and Display");
		stop
		run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
	}
	*/
	rename("reg");
	run("Split Channels");

	//saves the images
	selectWindow("C1-reg");
	saveAs("tiff",save_dir + ch1_keyword + "_reg_s" + i + ".tif");
	selectWindow("C2-reg");
	saveAs("tiff",save_dir + ch2_keyword + "_reg_s" + i + ".tif");
	selectWindow("C3-reg");
	saveAs("tiff",save_dir + ch3_keyword + "_reg_s" + i + ".tif");
	run("Close All");
	run("Collect Garbage");

}			

		