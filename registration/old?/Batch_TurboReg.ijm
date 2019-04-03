/*
 * This script processes a directory of .oib files, aligning
 * with TurboReg and saving as .tif files.
 *
 * Written April 29th, 2010, by Johannes Schindelin
 */
extension = ".tif";
outputFormat = "Tiff";
outputExtension = "-BRB.tif";

function batchTurboReg() {
	isBatch = is("Batch Mode");
	w = getWidth();
	h = getHeight();
	d = nSlices;
	orig = getImageID();
	getMinAndMax(min, max);
	setSlice(1);
	run("Duplicate...", "title=TurboReg-out");
	out = getImageID();
	if (!isBatch)
		setBatchMode(true);
	run("Duplicate...", "title=first-slice");
	first = getImageID();
	for (slice = 2; slice <= d; slice++) {
		selectImage(orig);
		setSlice(slice);
		run("Duplicate...", "title=current-slice");
		current = getImageID();
		run("TurboReg ", "-align -window current-slice 0 0 " + (w - 1) + " " + (h - 1)
			+ " -window first-slice 0 0 " + (w - 1) + " " + (h - 1)
			+ " -rigidBody "
			+ (w / 2) + " " + (h / 2) + " " // Source translation landmark.
			+ (w / 2) + " " + (h / 2) + " " // Target translation landmark.
			+ "0 " + (h / 2) + " " // Source first rotation landmark.
			+ "0 " + (h / 2) + " " // Target first rotation landmark.
			+ (w - 1) + " " + (h / 2) + " " // Source second rotation landmark.
			+ (w - 1) + " " + (h / 2) + " " // Target second rotation landmark.		
			+ " -showOutput");
		setMinAndMax(min, max);
		run("Select All");
		run("Copy");
		close();
		selectImage(out);
		run("Add Slice");
		run("Paste");
		selectImage(current);
		close();
	}
	selectImage(first);
	close();
	if (!isBatch)
		setBatchMode(false);
}

function bfOpenHyperstack(path) {
	isBatch = is("Batch Mode");
	if (!isBatch)
		setBatchMode(true);
	run("Bio-Formats Macro Extensions");
	Ext.setId(path);
	Ext.getCurrentFile(file);
	Ext.getSizeX(sizeX);
	Ext.getSizeY(sizeY);
	Ext.getSizeC(sizeC);
	Ext.getSizeZ(sizeZ);
	Ext.getSizeT(sizeT);
	Ext.getImageCount(n);
	for (i = 0; i < n; i++) {
		showProgress(i, n);
		Ext.openImage("plane "+i, i);
		if (i == 0)
			stack = getImageID;
		else {
			run("Copy");
			close();
			selectImage(stack);
			run("Add Slice");
			run("Paste");
		}
	}
	rename(File.getName(path));
	if (nSlices > 1) {
		Stack.setDimensions(sizeC, sizeZ, sizeT);
		if (sizeC > 1) {
			if (sizeC == 3 && sizeC == nSlices)
				mode = "Composite";
			else
				mode = "Color";
			run("Make Composite", "display=" + mode);
		}
		setOption("OpenAsHyperStack", true);
	}
	if (!isBatch)
		setBatchMode(false);
	Ext.close();
}

directory = getDirectory("Image directory (containing " + extension + " files)");
if (File.isDirectory(directory)) {
	list = getFileList(directory);
	for (i = 0; i < list.length; i++)
		if (endsWith(list[i], extension)) {
			list[i] = directory + list[i];
			outPath = substring(list[i], 0, lengthOf(list[i]) - lengthOf(extension));
			if (File.exists(outPath + outputExtension)) {
				print('registered image already exists');
			}
			else {
				//bfOpenHyperstack(list[i]);
				//open(list[i]);
				im_path = list[i];
				run("Bio-Formats Importer", "open=" + im_path + " autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_1");
				batchTurboReg();
				outPath = substring(list[i], 0, lengthOf(list[i]) - lengthOf(extension));
				saveAs(outputFormat, outPath + outputExtension);
				close();
				close();
			}
		}
}