//Makes an 8-bit image for a directory of images

keyword = "comb";
ch1_key = "Trans";
ch2_key = "GFP";
ch3_key = "mCherry";

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	print(imagename);
	
	if (matches(imagename,".*" + keyword + ".*")) {

		imagepath = data_dir + imagename;
		print(imagepath);
		open(imagepath);

		Stack.getDimensions(width, height, channels, slices, frames);
		for (j=1;j<channels+1;j++) {
			resetMinAndMax();
		}
		run("8-bit");

		rename("stk");
		run("Split Channels");

		selectWindow("C1-stk");
		suffix = substring(imagename, indexOf(imagename, keyword) + lengthOf(keyword));
		new_path = data_dir + ch1_key + suffix;
		print(new_path);
		saveAs("Tiff",new_path);

		selectWindow("C2-stk");
		suffix = substring(imagename, indexOf(imagename, keyword) + lengthOf(keyword));
		new_path = data_dir + ch2_key + suffix;
		print(new_path);
		saveAs("Tiff",new_path);

		selectWindow("C3-stk");
		suffix = substring(imagename, indexOf(imagename, keyword) + lengthOf(keyword));
		new_path = data_dir + ch3_key + suffix;
		print(new_path);
		saveAs("Tiff",new_path);
		
		run("Close All");
	
	}
}