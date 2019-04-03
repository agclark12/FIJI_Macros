dir = getInfo("image.directory");
filename = getInfo("image.filename");
ext = ".tif";
if (endsWith(filename,ext)) {
	
	run("Montage to Stack...", "images_per_row=4 images_per_column=1 border=0");
	run("Delete Slice");
	run("Delete Slice");
	saveAs("tiff",dir+replace(filename,ext,"_mont_only"+ext));
	run("Close All");
	
}