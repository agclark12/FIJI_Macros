/*
 * This script processes a directory of files, reducing the hyperstack
 * to one slice and saving as 8-bit .tif files.
 *
 * Written November 9th, 2010, by Andrew Clark
 */



extension = ".tif";
outputFormat = "Tiff";
outputExtension = ".tif";

directory = getDirectory("Image directory (containing " + extension + " files)");
sliceNumber = getNumber("Slice Number: ", sliceNumber);

setBatchMode(true);

if (File.isDirectory(directory)) {
	list = getFileList(directory);
	for (i = 0; i < list.length; i++)
		if (endsWith(list[i], extension)) {
			//bfOpenHyperstack(list[i]);
			//run("Bio-Formats Importer", "open=" + directory + list[i] + " open=" + directory + list[i] + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
			open(list[i]);
			Stack.setSlice(sliceNumber);
			run("Reduce Dimensionality...", "frames");
			resetMinAndMax();
			run("Enhance Contrast...", "saturated=0.1 process_all");
			run("8-bit");
			outPath = directory + list[i];
			outPath = substring(outPath, 0, lengthOf(outPath) - lengthOf(extension));
			saveAs(outputFormat, outPath + "_z" + sliceNumber + outputExtension);
			close();
		}
}