//this script goes through a bunch of subdirectories and
//puts images together in stacks for preparation for imaging

setBatchMode(true);

master_dir = getDirectory("please choose master directory");
master_dir_list = getFileList(master_dir);
save_dir = master_dir + "stks/";
File.makeDirectory(save_dir);

for (i=0; i<lengthOf(master_dir_list); i++) {
	if (matches(master_dir_list[i],"s[0-9]{1,2}/")) {
		data_dir = master_dir + master_dir_list[i] + "Croppeddata";
		run("Image Sequence...", "open=" + data_dir + " number=99999 starting=1 increment=1 scale=100 file=[(crop_BF.*tif)] sort");
		run("Bleach Correction", "correction=[Simple Ratio] background=0");
		resetMinAndMax();
		run("8-bit");
		saveAs("tiff",save_dir + substring(master_dir_list[i],0,lengthOf(master_dir_list[i])-1));
		run("Close All");
	}
}
