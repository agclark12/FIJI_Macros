//combines channels for several stage positions
//in a directory of images

setBatchMode(true);

ch1_keyword = "488";
ch2_keyword = "561";

//data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-02";
data_dir= "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-14/z_7/s6";
dir_list = getFileList(data_dir);

for (j=0; j<dir_list.length; j++) {

	print(j);
	filename = dir_list[j];
	print(filename);
	if (matches(filename, ".*" + ch1_keyword + ".*")) {
		print(filename);
		open(data_dir + "/" + filename);
		rename("ch1");
		Stack.getDimensions(w, h, no_channels, no_slices, no_frames)
	}
	if (matches(filename, ".*" + ch2_keyword + ".*")) {
		print(filename);
		open(data_dir + "/" + filename);
		rename("ch2");
	}
}

print('1!');
run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=[-- None --]");
print('2!');
run("Stack to Hyperstack...", "order=xyztc channels=2 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
print('3!');
saveAs("tiff", data_dir + "/" + ch1_keyword + "_" + ch2_keyword + "_comb.tif");
print("Saved!");
close();
