// This macro makes a line profile for each slice in a given stack
//id = getImageID();
run("Clear Results");
getLine(x1, y1, x2, y2, lineWidth);
// run through all slices of the current stack
for (slice = 0; slice < nSlices; slice++) {
	//selectImage(id);
	// the slices start at 1, not 0
	setSlice(slice + 1);
	makeLine(x1, y1, x2, y2);
	//setLineWidth(lineWidth);
	values = getProfile();
	// add the values to the results table
	for (column = 0; column < values.length; column++) {
		setResult(column, slice, values[column]);
	}
}

save_dir = getInfo("image.directory");
filename = getInfo("image.filename");
save_path = save_dir + substring(filename,0,lengthOf(filename)-4) + ".txt"

updateResults;
saveAs("results",save_path);
selectWindow("Results");
run("Close")
