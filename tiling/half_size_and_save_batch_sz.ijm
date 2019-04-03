setBatchMode(true);

data_dir = getDirectory("Which Directory?");
file_list = getFileList(data_dir);
keyword = "comb";

for (i=0; i<lengthOf(file_list); i++) {

	filename = file_list[i];
	if (matches(filename,".*" + keyword + ".*")) {
		
		open(data_dir + filename);
		no_frames = Stack.getDimensions(width, height, channels, slices, frames);
		width_new = floor(width/2);
		height_new = floor(height/2);
		run("Size...", "width=" + width_new + " height=" + height_new + " depth=" + slices + " time=" + frames + " constrain average interpolation=Bilinear");
		run("Stack to Hyperstack...", "order=xyczt(default) channels=" + channels + " slices=" + slices + " frames=" + frames + "  display=Grayscale");
		saveAs("tiff",data_dir + "/" + replace(filename,".tif","_small.tif"));
		close();
		
	}

}