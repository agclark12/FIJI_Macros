/*
 * This script processes a directory of files, reducing the hyperstack
 * to one slice and saving as 8-bit .tif files.
 *
 * Written November 9th, 2010, by Andrew Clark
 */



keyword = "small";

directory = getDirectory("Select image directory");
frameNumber = getNumber("Frame Number: ", frameNumber);

setBatchMode(true);

if (File.isDirectory(directory)) {
	list = getFileList(directory);
	for (i = 0; i < list.length; i++)
		if (matches(list[i],".*" + keyword + ".*")) {
			//bfOpenHyperstack(list[i]);
			//run("Bio-Formats Importer", "open=" + directory + list[i] + " open=" + directory + list[i] + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
			open(list[i]);
			//Stack.setFrame(frameNumber);
			//run("Reduce Dimensionality...", "channels slices");
			setSlice(frameNumber);
			run("Duplicate...", "use");
			//resetMinAndMax();
			//run("8-bit");
			outPath = directory + list[i];
			outPath = substring(outPath, 0, lengthOf(outPath) - 4);
			saveAs("Tiff", outPath + "_t" + frameNumber + ".tif");
			close();
			close();
		}
}