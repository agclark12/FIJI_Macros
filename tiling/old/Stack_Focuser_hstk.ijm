setBatchMode(true);
data_dir = "/Users/clark/Documents/Work/Data/_microscope_data/2015-01-23/stks/";
save_dir = data_dir + "focused/"
filename = "BF_s4_8bit.tif"
open(data_dir + filename);

Stack.getDimensions(width, height, channels, slices, frames);

for (i=1; i<frames+1; i++) {

	run("Duplicate...", "duplicate frames=" + i);
	run("Stack Focuser ", "enter=3");
	saveAs("tiff",save_dir + "frame_" + i);
	close();
	close();
	
}
close();
setBatchMode(false);
run("Image Sequence...", "open=" + save_dir + " sort");
