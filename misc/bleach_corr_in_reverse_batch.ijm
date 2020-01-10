//This macro goes through a directory of tiff stacks and prints the image sizes.

setBatchMode(true);

master_dir = getDirectory("Select Master Directory");
dir_list = getFileList(master_dir);
file_ext = ".tif";

save_dir = master_dir + "bleach_corr/";
File.makeDirectory(save_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	filename = dir_list[i];
	infile = master_dir + filename;
	//print(infile);
	
	if (matches(filename,".*" + file_ext)) {

		open(infile);
		run("Reverse");
		run("Bleach Correction", "correction=[Simple Ratio] background=0");
		run("Reverse");
		saveAs("tiff", save_dir + replace(filename,file_ext,"_bl_corr"+file_ext));

		run("Close All");
	}
}