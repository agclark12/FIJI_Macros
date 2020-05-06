//makes bpp for several stage positions
//in a directory of images (good for very big stacks where the hyperstack would be huge)

setBatchMode(true);

data_dir = getDirectory("Choose Data Directory");
dir_list = getFileList(data_dir);
keyword = "mCherry";

save_dir = data_dir + "bpp/";
File.makeDirectory(save_dir);

for (j=0; j<dir_list.length; j++) {
	filename = dir_list[j];
	if (matches(filename,".*tif")) {
		print(filename);
		open(data_dir + filename);
		run("Z Project...", "projection=[Max Intensity] all");
		saveAs("tiff", save_dir + replace(filename,".tif","_bpp.tif"));
		run("Close All");
	}
}