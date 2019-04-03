setBatchMode(true);

extension = ".tif";
outputFormat = "Tiff";
outputExtension = ".tif";

directory = getDirectory("Image directory (containing " + extension + " files)");
save_dir = getDirectory("Select Save directory");
sliceNumber = getNumber("Slice Number: ", sliceNumber);

if (File.isDirectory(directory)) {
	list = getFileList(directory);
	for (i = 0; i < list.length; i++) {
		if (endsWith(list[i], extension)) {
			open(directory + list[i]);
			run("Duplicate...", " ");
			
			outPath = directory + list[i];
			outPath = substring(outPath, 0, lengthOf(outPath) - lengthOf(extension));
			saveAs(outputFormat, outPath + "_z" + sliceNumber + outputExtension);
			run("Close All");
		}
	}
}
