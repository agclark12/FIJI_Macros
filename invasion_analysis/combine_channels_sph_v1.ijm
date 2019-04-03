//combines channels for several multi-channel images in a directory

setBatchMode(true);

ch1_keyword = "BF";
ch2_keyword = "405";
ch3_keyword = "491";
ch4_keyword = "561";

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);

for (i=0; i<lengthOf(dir_list); i++) {

	filename = dir_list[i];
	print(filename);
	if (matches(filename, ".*.nd")) {	

		basename = substring(filename,0,lengthOf(filename)-3);
		print(basename);

		for (j=0; j<lengthOf(dir_list); j++) {

			filename2 = dir_list[j];
			
			if (matches(filename2, basename + "_.*" + ch1_keyword + ".*.TIF")) {
				print(filename2);
				open(data_dir + "/" + filename2);
				rename("ch1");
				no_slices = nSlices;
			}
			if (matches(filename2, basename + "_.*" + ch2_keyword + ".*.TIF")) {
				//print(filename);
				open(data_dir + "/" + filename2);
				rename("ch2");
			}
			if (matches(filename2, basename + "_.*" + ch3_keyword + ".*.TIF")) {
				//print(filename);
				open(data_dir + "/" + filename2);
				rename("ch3");
			}
			if (matches(filename2, basename + "_.*" + ch4_keyword + ".*.TIF")) {
				//print(filename);
				open(data_dir + "/" + filename2);
				rename("ch4");
			}
		}	

	run("Concatenate...", "  title=[Concatenated Stacks] image1=ch1 image2=ch2 image3=ch3 image4=ch4 image5=[-- None --]");
	run("Stack to Hyperstack...", "order=xyztc channels=4 slices=" + no_slices + " frames=1 display=Grayscale");
	saveAs("tiff", data_dir + "/" + basename + "_comb.tif");		
	run("Close All");
	}
}
