//this macro goes through a directory and concatenates
//hyperstacks with the same name

dir1 = "//Users/clark/Documents/Work/Data/_microscope_data/2016-09-05/stks/1/";
dir2 = "/Users/clark/Documents/Work/Data/_microscope_data/2016-09-05/stks/2/";
save_dir = "/Users/clark/Documents/Work/Data/_microscope_data/2016-09-05/stks/comb/";

setBatchMode(true);

//loops through data directory
dir_list1 = getFileList(dir1);
dir_list2 = getFileList(dir2);

for (i=0; i<lengthOf(dir_list1); i++) {

	filename = dir_list1[i];
	print(filename);
	path1 = dir1 + filename;
	print(filename);

	for (j=0; j<lengthOf(dir_list2); j++) {
		if (matches(filename,dir_list2[j])) {

			path2 = dir2 + filename;
			open(path1);
			rename("stk1");
			open(path2);
			rename("stk2");
			//Stack.setFrame(1);
			//run("Delete Slice", "delete=frame");

			run("Concatenate...", " title=concat image1=stk1 image2=stk2 image3=[-- None --]");
			//run("Stack to Hyperstack...", "order=xyzct channels=2 slices=1 frames=" + nSlices/2 + "  display=Grayscale");
			saveAs("Tiff", save_dir + filename);
			run("Close All");
		}
	}
}
	
setBatchMode(false);