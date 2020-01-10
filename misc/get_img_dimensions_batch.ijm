//This macro goes through a directory of tiff stacks and prints the image sizes.

setBatchMode(true);

master_dir = getDirectory("Select Master Directory");
dir_list = getFileList(master_dir);
file_ext = ".tif";

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	filename = dir_list[i];
	infile = master_dir + filename;
	//print(infile);
	
	if (matches(filename,".*" + file_ext)) {

		print(infile);
		open(infile);

		//gets and records width and height (used later for piv)
		getDimensions(width, height, channels, slices, frames);
		setResult("sub_dir", nResults, replace(filename,".tif",""));
		setResult("width_px", nResults-1, width);
		setResult("height_px", nResults-1, height);
		updateResults();

		run("Close All");
	}
}