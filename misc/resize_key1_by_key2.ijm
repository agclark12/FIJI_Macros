//resizes the canvas of one set of images (key1) given the sizes of another set of images (key2)

run("Close All");
setBatchMode(true);

key1 = "seg";
key2 = "Trans";
start_pos = 1;
end_pos = 10;
data_dir = getDirectory("Choose a data directory");
dir_list = getFileList(data_dir);

for (i=start_pos;i<end_pos+1;i++) {
	print("position",i);
	for (j=0;j<lengthOf(dir_list);j++) {
		if (matches(dir_list[j],".*"+key1+"_s"+i+"_.*")) {
			path1 = data_dir + dir_list[j];
			print(path1);
			open(path1);
			rename("img1");
		}
		if (matches(dir_list[j],".*"+key2+"_s"+i+"_.*")) {
			path2 = data_dir + dir_list[j];
			print(path2);
			open(path2);
			rename("img2");
		}
	}

	selectWindow("img2");
	getDimensions(width, height, channels, slices, frames);
	selectWindow("img1");
	run("Canvas Size...", "width="+width+" height="+height+" position=Top-Left zero");
	saveAs(path1);
	run("Close All");	

}
