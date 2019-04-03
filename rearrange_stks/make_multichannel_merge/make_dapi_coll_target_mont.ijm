//a script
function make_merge_proj () {
	
	dir = getInfo("image.directory");
	filename = getInfo("image.filename");
	save_dir = dir + "/avi/";
	File.makeDirectory(save_dir);
	
	rename("stk");
	run("Split Channels");
	selectWindow("C1-stk");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	selectWindow("C2-stk");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	selectWindow("C3-stk");
	run("Grays");
	run("Enhance Contrast...", "saturated=0.02 process_all use");
	//selectWindow("C4-stk");
	//run("Enhance Contrast...", "saturated=0.02 process_all use");

	run("Merge Channels...", "c2=C3-stk c3=C1-stk c6=C2-stk create keep ignore");
	saveAs("tiff",dir + "/" + replace(filename,".lsm","_merge.tif"));
	rename("Composite");
	run("Duplicate...", "duplicate");
	rename("Composite2");

	run("Combine...", "stack1=C1-stk stack2=C3-stk");
	run("Combine...", "stack1=[Combined Stacks] stack2=C2-stk");
	run("RGB Color", "slices");
	selectWindow("Composite");
	run("RGB Color", "slices");
	run("Combine...", "stack1=[Combined Stacks] stack2=Composite");
	run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir +  "/" + replace(filename,".lsm","_merge.avi") + "]");
	run("Z Project...", "projection=[Max Intensity]");
	saveAs("tiff",save_dir + "/" + replace(filename,".lsm","_bpp.tif"));

	selectWindow("Composite2");
	run("3D Project...", "projection=[Brightest Point] axis=Y-Axis slice=1 initial=0 total=360 rotation=10 lower=1 upper=255 opacity=0 surface=100 interior=50");
	saveAs("tiff",dir + "/" + replace(filename,".lsm","_3D.tif"));
	Stack.setChannel(1);
	run("Enhance Contrast...", "saturated=0");	
	Stack.setChannel(2);
	run("Enhance Contrast...", "saturated=2");
	run("RGB Color", "frames");
	run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir +  "/" + replace(filename,".lsm","_3D.avi") + "]");

	
	run("Close All");
}

setBatchMode(true);

data_dir = getDirectory("Choose Directory");
dir_list = getFileList(data_dir);

for (i=0; i<lengthOf(dir_list); i++) {
	entry = dir_list[i];
	if (matches(entry,".*lsm")) {
		open(data_dir + entry);
		make_merge_proj();
	}
}
