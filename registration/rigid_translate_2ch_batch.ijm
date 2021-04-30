setBatchMode(true);

keyword = "A431";
directory = getDirectory("Please select image directory");
dir_list = getFileList(directory);
//save_dir = getDirectory("Select Save directory");
save_dir = directory;

//translation parameters for TransformJ Translate (transforms channel 2)
trans_x = -5
trans_y = 1
	
for (i = 0; i < dir_list.length; i++) {
	if (matches(dir_list[i], ".*"+keyword+".*")) {

		imagename = dir_list[i];
		open(directory + imagename);
		rename("stk");
		basename = substring(imagename, 0, lengthOf(imagename) - 4);

		getDimensions(width, height, channels, slices, frames);
		for (j=1;j<channels+1;j++) {
			selectWindow("stk");
			print(j);
			run("Duplicate...", "duplicate channels="+j);
			rename("stk-"+j);
		}

		selectWindow("stk-2");
		run("TransformJ Translate", "x-distance="+trans_x+" y-distance="+trans_y+" z-distance=0.0 voxel interpolation=Linear background=0.0");
		run("Concatenate...", "keep open image1=stk-1 image2=[stk-2 translated] image3=[-- None --]");
		run("Stack to Hyperstack...", "order=xytzc channels="+channels+" slices=1 frames="+frames+" display=Grayscale");
		
		outPath = directory + basename + "_color_corr.tif";
		saveAs(outPath);
		
		run("Close All");
	}
}

