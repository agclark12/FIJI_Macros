/*
 * This macro replaces the spaces in all of the filenames
 * in a given directory with underscores
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-01-08
 */
 
dir = getDirectory("Choose Directory");
dir_list = getFileList(dir);
for (i=0; i<dir_list.length; i++) {
	filename_old = dir_list[i];
	filename_new = replace(filename_old," ","_");
	File.rename(dir + filename_old, dir + filename_new);
}