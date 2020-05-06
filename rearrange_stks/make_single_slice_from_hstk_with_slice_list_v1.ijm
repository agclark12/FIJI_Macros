//makes a single slice timelapse image from a hyperstack
//this is done in batch according to a slice_list for each image in the directory

setBatchMode(true);

data_dir = getDirectory("Choose Data Directory");
save_dir = data_dir + "single_slice/";
File.makeDirectory(save_dir);

dir_list = getFileList(data_dir);

for (i=0; i<dir_list.length; i++) {
	
	filename = dir_list[i];
	base_name = substring(filename, 0, lengthOf(filename) - 4);

	//see if there is a corresponding slice_list
	slice_list_path = data_dir + base_name + "_slice_list.dat";
	if (File.exists(slice_list_path)) {

		//opens the image
		print(filename);
		open(data_dir + "/" + filename);
		rename("stk");
		Stack.getDimensions(width, height, channels, slices, frames);

		//opens the slice list
		infile = File.openAsString(slice_list_path);
		frame_slice_list = split(infile,"\n");
		
		//makes a new stack for copying the images into
		first_elements = split(frame_slice_list[0]);
		array_length = frame_slice_list.length + first_elements[0] - 1;
		print(array_length);
		newImage("single", "8-bit black", width, height, array_length);

		//loops through the frame_slice_list and copies the images to the new image
		for (j=0;j<frame_slice_list.length;j++) {
			elements = split(frame_slice_list[j]);
			selectWindow("stk");
			Stack.setFrame(elements[0]);
			Stack.setSlice(elements[1]);
			run("Select All");
			run("Copy");

			//paste image in new stack
			selectWindow("single");
			setSlice(elements[0]);
			run("Paste");
			run("Select None");
		}

		saveAs("tiff", save_dir + base_name +  "_single_slice.tif");
		run("Close All");
	}
	
}
