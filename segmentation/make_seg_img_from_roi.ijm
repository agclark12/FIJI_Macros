prefix = "Trans_reg_crop_";
new_prefix = "seg_";

dir = getInfo("image.directory");
filename = getInfo("image.filename");
roiManager("Add");
getDimensions(width, height, channels, slices, frames);
newImage("Untitled", "8-bit black", width, height, 1);
roiManager("Select", roiManager("count")-1);
setForegroundColor(255, 255, 255);
run("Draw", "slice");
run("Select None");
if (startsWith(filename, prefix)) {
	run("Save", "save="+dir+replace(filename, prefix, new_prefix));
	run("Close All");
} else {
	exit("Your filename does not have the specified prefix. Exiting to prevent overwriting original file.");
}
