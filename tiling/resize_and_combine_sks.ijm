/*
 * This macro goes through a directory of images
 * and combines the stacks horizontally to create one big stack
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-10-02
 */

setBatchMode(true);

//gets directory and file list
dir = getDirectory("Choose Directory");
dir_list = getFileList(dir);
no_images = lengthOf(dir_list);

//goes through images and get max height/width
max_x = 0;
max_y = 0;
for (i=0; i<no_images; i++) {

	open(dir + dir_list[i]);
	print(dir_list[i]);
	rename(i);
	x = getWidth();
	y = getHeight();
	if (x > max_x) {
		max_x = x;
	}
	if (y > max_y) {
		max_y = y;
	}	
}
print("go");

print(max_x);
print(max_y);

//adjust canvas sizes for each image
for (i=0; i<no_images; i++) {

	selectWindow(i);
	run("Canvas Size...", "width=" + max_x + " height=" + max_y + " position=Center zero");
}

//combines stacks
run("Combine...", "stack1=0 stack2=1");
for (i=2; i<no_images; i++) {
	run("Combine...", "stack1=[Combined Stacks] stack2=" + i);
}

//run("Stack to Images...");

saveAs("tiff",dir + "combined_stks.tif");
print("go");
run("Close All");
