//makes multichannel bpp's and avi's

function find_brightest_slice_hstk() {
	brightest_idx = 1;
	brightest_val = 0;
	getDimensions(w,h,ch,z,t);
	for (j=1;j<z+1;j++) {
		Stack.setSlice(j);
		getStatistics(area, mean, min, max, std, histogram);
		if (mean>brightest_val) {
			brightest_val = mean;
			brightest_idx = j;
		}
	}
	return brightest_idx;
}


setBatchMode(1);

keyword = ".lsm";

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);

save_dir = data_dir + "avi/";
File.makeDirectory(save_dir);

//loops through number of positions/examples
for (i=0; i<lengthOf(dir_list); i++) {

	if (matches(dir_list[i],".*" + keyword + ".*")) {
		
		print("Opening Image");
		basename = substring(dir_list[i],0,indexOf(dir_list[i],keyword));
		file_path = data_dir + dir_list[i];
		open(file_path);
		rename("stk");

		//adjust levels and convert to 8-bit
		getDimensions(width, height, channels, slices, frames);
		for (k=1;k<channels+1;k++) {
			Stack.setChannel(k);
			idx = find_brightest_slice_hstk();
			Stack.setSlice(idx);
			resetMinAndMax();
		}
		run("8-bit");
		run("Grays");

		for (k=1;k<channels+1;k++) {
			Stack.setChannel(k);
			idx = find_brightest_slice_hstk();
			Stack.setSlice(idx);
			run("Enhance Contrast", "saturated=0.1");
		}

		//saveAs("tiff", data_dir + basename + "_comb.tif");
		//rename("stk");

		//splits channels
		run("Split Channels");

		//merges channels
		//C1 (red);
		//C2 (green);
		//C3 (blue);
		//C4 (gray);
		//C5 (cyan);
		//C6 (magenta);
		//C7 (yellow);
		//run("Merge Channels...", "c2=C1-stk c3=C2-stk c6=C4-stk create keep ignore");
		//run("Merge Channels...", "c2=C3-stk c3=C2-stk c6=C4-stk create keep ignore");
		//rename("merge");
		//run("RGB Color", "slices");

	
		//makes avi of 3D projection of merge
		/* 
		print("Making 3D merge projection");
		selectWindow("merge");
		run("3D Project...", "projection=[Brightest Point] axis=Y-Axis slice=1 initial=0 total=360 rotation=10 lower=1 upper=255 opacity=0 surface=100 interior=50");
		run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_" + i + "_3D.avi" + "]");
		*/
	
		//combines stacks
		print("Combining Stacks");
		run("Combine...", "stack1=C4-stk stack2=C3-stk");
		print('ok');
		run("Combine...", "stack1=[Combined Stacks] stack2=C2-stk");
		run("Combine...", "stack1=[Combined Stacks] stack2=C1-stk");
		//run("Combine...", "stack1=[Combined Stacks] stack2=C5-stk");
		//run("RGB Color", "slices");
		//run("Combine...", "stack1=[Combined Stacks] stack2=merge");
	
		//makes avi of stack
		run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_mont.avi" + "]");
	
		//makes bpp
		print("Making BPP");
		run("Z Project...", "projection=[Max Intensity]");
		saveAs("tiff", save_dir + basename + "_bpp.tif");
	
		//closes
		run("Close All");
	}
	
}
