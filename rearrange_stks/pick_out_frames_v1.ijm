//**Note: make sure all images are closed before running this script.**
setBatchMode(true);
//select directory
directory = getDirectory("Image directory containing files");
print(directory)

//open file and generate slice list
infile = File.openAsString(directory + "frame_list.txt");
frame_list = split(infile,"\n");
//date = slicelist[0];
//print(date);

open(directory + "BF_mcherry_comb_s1.tif");
Stack.getDimensions(width, height, channels, slices, frames);

//loop through slice list, isolate slices and save
for (i = 1; i<frames+1; i++) {

	//Stack.setFrame(i);
	
	//figure out if the frame is in the list or not
	toggle = 0;
	for (j=0; j<lengthOf(frame_list);j++) {
		if (matches(frame_list[j],i)) {
			toggle = 1;
		}
	}

	if (toggle) {
		//Stack.setSlice(5);
		run("Duplicate...", "title=stk duplicate slices=4 frames=" + i);
	} else {
		//Stack.setSlice(3);
		run("Duplicate...", "title=stk duplicate slices=1 frames=" + i);
	}

	saveAs("tiff",directory + "/frames_c/frame_" + i);
	close();
	
}
