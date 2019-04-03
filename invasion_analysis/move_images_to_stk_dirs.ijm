/*
 * This macro sorts images into subdirectories within 
 * a "/stks" subdirectory by finding files containing
 * a string unique to the subdirectory.
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-03-08
 */
 
img_dir = getDirectory("Choose Directory");
dir_list = getFileList(img_dir);
dir_list_stks = getFileList(img_dir + "stks/");

for (i=0; i<dir_list_stks.length; i++) {
	stk_dirname = substring(dir_list_stks[i],0,lengthOf(dir_list_stks[i])-1); //cuts off backslash
	print(stk_dirname);
	stk_dir = img_dir + "stks/" + stk_dirname + "/";
	for (j=0; j<dir_list.length; j++) {
		img_filename = dir_list[j];
		if (matches(img_filename,".*" + stk_dirname + ".*")) {
			print(img_filename);
			print(stk_dirname);
			File.rename(img_dir + img_filename,stk_dir + img_filename);
		}
	}
}