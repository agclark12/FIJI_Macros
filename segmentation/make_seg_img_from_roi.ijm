dir = getInfo("image.directory");
filename = getInfo("image.filename");
roiManager("Add");
getDimensions(width, height, channels, slices, frames);
newImage("Untitled", "8-bit black", width, height, 1);
roiManager("Select", roiManager("count")-1);
setForegroundColor(255, 255, 255);
run("Draw", "slice");
run("Select None");
run("Save", "save="+dir+replace(filename,"Trans_reg_crop","seg"));
run("Close All");