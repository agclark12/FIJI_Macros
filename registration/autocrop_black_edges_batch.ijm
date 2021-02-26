//autocrops the black edges on all tif files in a directory
//using Autocrop_Black_Edges

data_dir = getDirectory("Which Directory?");
dir_list = getFileList(data_dir);
save_dir = data_dir + "cropped/";
File.makeDirectory(save_dir);

for (i=0;i<lengthOf(dir_list);i++) {
	 if (matches(dir_list[i],".*reg.*tif")) {
	 	path_old =	data_dir + dir_list[i];
	 	open(path_old);
	 	run("Autocrop Black Edges");
	 	path_new = save_dir + replace(dir_list[i],"reg","reg_crop");
	 	saveAs(path_new);
	 	run("Close All");
	 }
}