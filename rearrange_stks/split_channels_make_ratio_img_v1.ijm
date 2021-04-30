//This script goes through 2 channel hyperstacks in a directory
//and makes single channel images and a ratio image (ch1/ch2)

setBatchMode(true);
run("Close All");
//select directory
data_dir = getDirectory("Image directory containing files");
dir_list = getFileList(data_dir);
ch1_key = "YFP";
ch2_key = "CFP";
suffix = ".tif";

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	imagename = dir_list[i];
	if (matches(imagename,".*"+suffix)) {

		print(imagename);
		basename = substring(imagename, 0, indexOf(imagename,suffix));
		print(basename);
		
		open(data_dir + imagename);
		rename("hstk");

		run("Split Channels");

		selectWindow("C1-hstk");
		saveAs(data_dir+basename+"_"+ch1_key+suffix);

		selectWindow("C2-hstk");
		saveAs(data_dir+basename+"_"+ch2_key+suffix);

		imageCalculator("Divide create 32-bit stack", "C1-hstk","C2-hstk");
		saveAs(data_dir+basename+"_ratio"+suffix);
		
		run("Enhance Contrast", "saturated=0.35");
		run("8-bit");
		run("Rainbow RGB");
		saveAs(data_dir+basename+"_ratio_8bit"+suffix);
		
		run("Close All");
	}
}

run("Close All");