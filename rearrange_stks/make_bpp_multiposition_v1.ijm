//makes bpp for several stage positions
//in a directory of images (good for very big stacks where the hyperstack would be huge)

setBatchMode(true);

data_dir = getDirectory("Choose Data Directory");
save_dir = getDirectory("Choose Save Directory");
dir_list = getFileList(data_dir);
keyword = "DOUBLE-GFP";
no_positions = 9;
no_frames = 66;

for (k=1; k<no_positions+1; k++) {

	toggle = true;
	
	for (i=1; i<no_frames+1; i++) {
	
		for (j=0; j<dir_list.length; j++) {
	
			filename = dir_list[j];
			//print(filename);
			
			if (matches(filename, ".*" + keyword + ".*" + "s" + k + "_t" + i + ".TIF")) {
				print(filename);
				open(data_dir + "/" + filename);
				rename("current");
				Stack.getDimensions(width, height, channels, slices, frames);
				
				if (toggle) {
					newImage("bpp", "RGB black", width, height, no_frames);
					toggle = false;
				}
	
				selectWindow("current");
				run("Z Project...", "projection=[Max Intensity]");
				run("Select All");
				run("Copy");
				close();
		
				//paste image in new stack
				selectWindow("bpp");
				setSlice(i);
				run("Paste");
	
				//close current frame
				selectWindow("current");
				close();
			}	
		}
	}

	saveAs("tiff", save_dir + keyword + "_bpp_s" + k + ".tif");
	run("Close All");
	
}

setBatchMode("exit and display");
