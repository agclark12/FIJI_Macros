dir = getInfo("image.directory");
filename = getInfo("image.filename");
no_frames = Stack.getDimensions(width, height, channels, slices, frames);
width_new = floor(width/2);
height_new = floor(height/2);
run("Size...", "width=" + width_new + " height=" + height_new + " time=" + frames + " constrain average interpolation=Bilinear");
run("Stack to Hyperstack...", "order=xyczt(default) channels=" + channels + " slices=1 frames=" + frames + "  display=Grayscale");
saveAs("tiff",dir + "/" + replace(filename,".tif","_small.tif"));
close();