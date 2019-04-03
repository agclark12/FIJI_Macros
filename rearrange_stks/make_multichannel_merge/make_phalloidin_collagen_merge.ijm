//a script
function make_merge_proj () {
	
	dir = getInfo("image.directory");
	filename = getInfo("image.filename");
	save_dir = dir + "/avi/";
	File.makeDirectory(save_dir);
	
	rename("stk");
	run("Split Channels");
	run("Merge Channels...", "c2=C4-stk c6=C3-stk create ignore");
	selectWindow("Composite");
	run("Duplicate...", "duplicate");
	
	selectWindow("Composite");
	saveAs("tiff",dir + "/" + replace(filename,".lsm","_merge.tif"));
	Stack.setChannel(1);
	run("Enhance Contrast...", "saturated=0");	
	Stack.setChannel(2);
	run("Enhance Contrast...", "saturated=0");
	run("RGB Color", "frames slices");
	run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir +  "/" + replace(filename,".lsm","_merge.avi") + "]");
	
	selectWindow("Composite-1");
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
