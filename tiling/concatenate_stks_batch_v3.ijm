//this macro goes through a directory and concatenates
//hyperstacks with the same name
//v3 accounts for differences in z-slices by adding additional slices to the end of shorter stacks

function pad_hstk(hstk,target_slices) {

	selectWindow(hstk);
	Stack.getDimensions(width, height, channels, slices, frames);
	
	for (k=0;k<target_slices-slices;k++) {
		selectWindow(hstk);
		Stack.getDimensions(width_tmp, height_tmp, channels_tmp, slices_tmp, frames_tmp);
		Stack.setSlice(slices_tmp);
		run("Add Slice", "add=slice");
	}
}


dir1 = getDirectory("directory series 1");
dir2 = getDirectory("directory series 2");
save_dir = getDirectory("save directory");

//setBatchMode(true);

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
			Stack.getDimensions(w1, h1, ch1, s1, fr1);
			open(path2);
			rename("stk2");
			Stack.getDimensions(w2, h2, ch2, s2, fr2);

			if (s1!=s2){
				if (s1<s2) {
					pad_hstk("stk1",s2);
					no_slices = s2;
				} else if (s2<s1) {
					pad_hstk("stk2",s1);
					no_slices = s1;
				}
			}
			
			//Stack.setFrame(1);
			//run("Delete Slice", "delete=frame");

			run("Concatenate...", " title=concat image1=stk1 image2=stk2 image3=[-- None --]");
			//run("Stack to Hyperstack...", "order=xyzct channels=" + ch1 + " slices=" + no_slices + " frames=" + (fr1+fr2) + "  display=Grayscale");
			saveAs("Tiff", save_dir + filename);
			run("Close All");
		}
	}
}
	
setBatchMode(false);