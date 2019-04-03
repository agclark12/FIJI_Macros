/*
 * Goes through a directory of single images and puts images
 * together in a hyperstack (czt) for each position (s).
 * The hyperstacks are saved in a sub-folder called "stacks"
 * within the image directory.
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-01-08
 */

setBatchMode(true);

function find_max(array) {
	//finds maximum value in an array and returns
	
	max = 0;
	for (i=0; i<array.length; i++) {
		if (array[i] > max) {
			max = array[i];
		}
	}
	return max
}

function get_no_tzc(dir_list,keyword) {
	//gets the number of time frames (t), z-slices (z) and channels (c)

	//defines keywords for time, z and channels
	keyword_t = "_t";
	keyword_z = "_z";
	keyword_c = "_ch";

	//makes blank arrays for time, z and channels
	t_list = newArray(0);
	z_list = newArray(0);
	c_list = newArray(0);

	for (i=0; i<dir_list.length; i++) {
		filename = dir_list[i];
		if (matches(filename,".*" + keyword + ".*")) {

			//parses out t number and adds to list
			t_keyword_pos = lastIndexOf(filename,keyword_t) + lengthOf(keyword_t);
			t_no = parseInt(substring(filename,t_keyword_pos,t_keyword_pos+2));
			t_list = Array.concat(t_list,t_no);

			//parses out z number and adds to list
			z_keyword_pos = lastIndexOf(filename,keyword_z) + lengthOf(keyword_z);
			z_no = parseInt(substring(filename,z_keyword_pos,z_keyword_pos+2));
			z_list = Array.concat(z_list,z_no);

			//parses out c number and adds to list
			c_keyword_pos = lastIndexOf(filename,keyword_c) + lengthOf(keyword_c);
			c_no = parseInt(substring(filename,c_keyword_pos,c_keyword_pos+2));
			c_list = Array.concat(c_list,c_no);
		}
	}
	//returns highest t,z and c values found in list (+1 because of zero indexing)
	no_t = find_max(t_list) + 1;
	no_z = find_max(z_list) + 1;
	no_c = find_max(c_list) + 1;
	return newArray(no_t, no_z, no_c);
}

function get_no_positions(dir_list,keyword_s) {
	//finds the total number of positions for images in a directory list
	
	pos_list = newArray(0);
	
	for (i=0; i<dir_list.length; i++) {
		filename = dir_list[i];
		if (matches(filename,".*" + keyword_s + ".*")) {
			
			//parses out position number and adds to list
			keyword_pos = lastIndexOf(filename,keyword_s) + lengthOf(keyword_s);
			pos_no = parseInt(substring(filename,keyword_pos,keyword_pos+1));
			pos_list = Array.concat(pos_list,pos_no);
		}
	}
	no_positions = find_max(pos_list);
	return no_positions
}

//gets image directory and declares the keyword denoting position
data_dir = getDirectory("Choose Directory");
keyword_s = "Position";

//makes directory for saving stacks
save_dir = data_dir + "stks/";
File.makeDirectory(save_dir);

//gets list of files in the directory
dir_list = getFileList(data_dir);

//gets number of positions
no_positions = get_no_positions(dir_list,keyword_s);

for (i=1; i<no_positions+1; i++) {
	pos_keyword = keyword_s + i;
	
	//gets number of time fames (t), z-slices (z) and channels (c)
	tzc_array = get_no_tzc(dir_list,pos_keyword);
	no_t = tzc_array[0];
	no_z = tzc_array[1];
	no_c = tzc_array[2];

	//opens image sequence for this position and makes hyperstack
	run("Image Sequence...", "open=" + data_dir + " number=" + dir_list.length + " starting=1 increment=1 scale=100 file=[(.*" + pos_keyword + ".*)] sort");
 	run("Stack to Hyperstack...", "order=xyczt(default) channels=" + no_c + " slices=" + no_z + " frames=" + no_t + " display=Grayscale");
	
	//saves and closes image
	outPath = save_dir + pos_keyword + "_stk.tif";
	saveAs("tiff", outPath);
	close();

}
	
setBatchMode(false);