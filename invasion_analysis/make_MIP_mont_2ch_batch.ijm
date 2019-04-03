//This macro goes through a directory and makes max
//intensity projections for images in batch. The images
//should all contain a unique keyword. The images are also
//converted to 8-bit and saved.

setBatchMode(false);

function get_brightest_slice_hstk() {
	Stack.getDimensions(width, height, channels, slices, frames);
	max_int = 0;
	max_slice = 1;
	for (j=1; j<slices+1; j++) {
		Stack.setSlice(j);
		getStatistics(area, mean, min, max, std, histogram);
		if (max > max_int) {
			max_int = max;
			max_slice = j;
		}
	}
	return(max_slice);
}

dir = getDirectory("Which Directory?");
dir_list = getFileList(dir);
keyword = getString("Please Enter the Keyword","comb.tif");

for (i=0; i<lengthOf(dir_list); i++) {
	if (matches(dir_list[i],".*" + keyword + ".*")) {
		path = dir + dir_list[i];
		open(path);
		Stack.setChannel(1);
		Stack.setSlice(get_brightest_slice_hstk());
		resetMinAndMax();
		Stack.setChannel(2);
		Stack.setSlice(get_brightest_slice_hstk());
		resetMinAndMax();
		run("Z Project...", "projection=[Max Intensity]");
		run("8-bit");

		//makes merge img
		rename("stack");
		stack = "stack";
		run("Deinterleave", "how=2");
		selectWindow("stack #1");
		rename("channel1");
		selectWindow("stack #2");
		rename("channel2");	
		//run("Merge Channels...", "c2=[" + stack + " #1] c6=[" + stack + " #2] keep"); //ch2=green,ch6=magenta
		//run("Merge Channels...", "c3=[" + stack + " #1] c6=[" + stack + " #2] keep"); //ch3=blue,ch6=magenta
		run("Merge Channels...", "c2=channel2 c3=channel1 keep"); //ch2=green,ch3=blue
		saveAs(replace(path,".tif","_MIP.tif"));
		rename("RGB");
		//run("Merge Channels...", "c5=[" + stack + " #1] c6=[" + stack + " #2] keep"); //ch5=cyan,ch6=magenta
		selectWindow("channel1");
		run("RGB Color");
		selectWindow("channel2");
		run("RGB Color");
		run("Concatenate...", "  title=[Concatenated Stacks] image1=channel1 image2=channel2 image3=RGB image4=[-- None --]");
		run("Make Montage...", "columns=3 rows=1 scale=1 first=1 last=3 increment=1 border=2 font=12");
		saveAs(replace(path,".tif","_MIP_mont.tif"));
		run("Close All");
	}
}

setBatchMode(false);