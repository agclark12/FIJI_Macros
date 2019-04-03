/*
 * This macro goes through a directory of images
 * and makes a single stack from the images and a montage.
 * The size of the stack/montage are adjusted to accommodate
 * the maximum image size in the directory.
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-03-08
 */

function is_image(img_name) {
	if (endsWith(img_name,".tif")) {
		return(true);
	} else if (endsWith(img_name,".jpg")) {
		return(true);
	} else if (endsWith(img_name,".gif")) {
		return(true);
	} else if (endsWith(img_name,".png")) {
		return(true);
	} else if (endsWith(img_name,".bmp")) {
		return(true);
	} else {
		return(false);
	}
}

setBatchMode(true);

//gets directory and file list
dir = getDirectory("Choose Directory");
dir_list = getFileList(dir);

//goes through images and get max size
max_x = 0;
max_y = 0;
for (i=0; i<lengthOf(dir_list); i++) {
	
	if (is_image(dir_list[i])) {
		
		open(dir + dir_list[i]);
		x = getWidth();
		y = getHeight();
		close();
		if (x > max_x) {
			max_x = x;
		}
		if (y > max_y) {
			max_y = y;
		}
	}	
}

print(max_x);
print(max_y);

//builds stack
newImage("stk", "RGB black", max_x, max_y, 1);
for (i=0; i<lengthOf(dir_list); i++) {
	
	if (is_image(dir_list[i])) {
		
		open(dir + dir_list[i]);
		rename("tmp");
		run("Copy");
		selectWindow("stk");
		setSlice(nSlices);
		run("Paste");
		run("Add Slice");
		selectWindow("tmp");
		close();

	}
}

//delete the last slice (there should be one too many at this point)
selectWindow("stk");
setSlice(nSlices);
run("Delete Slice");

//save stack
out_path = substring(dir,0,lengthOf(dir)-1) + ".tif"
saveAs("tiff",out_path);

//make montage and save
run("Make Montage...", "columns=" + nSlices + " rows=1 scale=1 first=1 last=" + nSlices + " increment=1 border=1 font=12 use");
saveAs("tiff",replace(out_path,".tif","_mont.tif"));

run("Close All");
