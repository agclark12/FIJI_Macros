//makes bpp for several stage positions (where the hyperstacks for each position are already made)

setBatchMode(true);

data_dir = getDirectory("Choose Data Directory");
dir_list = getFileList(data_dir);
keyword = "mCherry";

save_dir = data_dir;
//save_dir = data_dir + "bpp/";
//File.makeDirectory(save_dir);

for (j=0; j<dir_list.length; j++) {
	filename = dir_list[j];
	if (matches(filename,".*"+keyword+".*tif")) {
		print(filename);
		open(data_dir + filename);
		resetMinAndMax();
		run("Z Project...", "projection=[Max Intensity] all");
		filename_new_start = substring(filename, 0, indexOf(filename,"_s"));
		filename_new_end = substring(filename, indexOf(filename,"_s"), lengthOf(filename));
		filename_new = filename_new_start + "_bpp" + filename_new_end;
		print(filename_new);
		saveAs("tiff", save_dir + filename_new);
		run("Close All");
		run("Collect Garbage");
	}
}