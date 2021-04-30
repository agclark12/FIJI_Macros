run("Enhance Contrast...", "saturated=0.3");
run("Apply LUT", "stack");
waitForUser("Select in-focus Slice");
dir = getInfo("image.directory");
im_name = getInfo("image.filename");
run("Reduce Dimensionality...", "frames");
saveAs("Tiff", dir+im_name);
close();