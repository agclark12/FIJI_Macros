//makes a .avi from a single slice of a multi-channel hyperstack
//The slices and stack names are dictated by a file within the directory
//called "slice_list.dat" The format of this should be:
//"filename slice_number"

run("Close All");
setBatchMode(true);
//select directory
data_dir = getDirectory("Image directory containing files");
print(data_dir)
save_dir = data_dir + "merge/"
File.makeDirectory(save_dir);
save_dir_wSB = data_dir + "merge_wSB/"
File.makeDirectory(save_dir_wSB);

//px_size = 0.07; //px_size (in microns)
sb_size = 10; //size of scale bar (in microns)
sb_height = 7; //height of scale bar (in pixels)

//open file and generate slice list
filelist = getFileList(data_dir);

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(filelist); i++) {

	//get image name and slice number
	imagename = filelist[i];
	print(imagename);
	if (matches(imagename,".*tif")) {
		open(data_dir + imagename);
		stack = getInfo("image.filename");
		basename = substring(imagename, 0, lengthOf(imagename) - 4);
	
		run("Split Channels");
		selectWindow("C1-" + stack);
		run("Enhance Contrast...", "saturated=0.01 process_all use");
		//run("8-bit");
		selectWindow("C2-" + stack);
		run("Enhance Contrast...", "saturated=0.01 process_all use");
		//run("8-bit");

		//
		run("Merge Channels...", "c2=C1-" + stack +  " c6=C2-" + stack + " keep");  //ch2=green,ch6=magenta
		//run("RGB Color", "frames");	
		rename("merge");


		
		//saveAs("tiff", save_dir + basename + "_merge.tif");
		//run("Scale Bar...", "width=" + sb_size + " height=" + sb_height + " font=18 color=White background=None location=[Lower Right] bold hide");
		//saveAs("tiff", save_dir_wSB + basename + "_merge_w" + sb_size + "umSB.tif");


		selectWindow("C1-" + stack);
		run("RGB Color");
		selectWindow("C2-" + stack);
		run("RGB Color");
		run("Concatenate...", "  title=[Concatenated Stacks] image1=[C1-" + stack + "] image2=[C2-" + stack + "] image3=merge image4=[-- None --]");
		run("Make Montage...", "columns=3 rows=1 scale=1 first=1 last=3 increment=1 border=2 font=12");
		saveAs("tiff", save_dir + basename + "_mont.tif");


		run("Close All");
	}
}