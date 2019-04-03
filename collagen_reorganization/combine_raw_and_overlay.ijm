//makes a combined image of a raw image slice and
//an overlay image from CurveAlign analysis.

setBatchMode(true);

dir = getDirectory("Which directory?");
dir_list = getFileList(dir);
save_dir = dir + "raw_overlay_stks/";
File.makeDirectory(save_dir);

for (i=0; i<lengthOf(dir_list); i++) {
	filename = dir_list[i];
	if (matches(filename,".*tif")) {
		
		open(dir + filename);
		rename("raw");
		
		basename = substring(filename,0,lengthOf(filename)-4);
		open(dir + "/CA_Out/" + basename + "_overlay.tiff");
		rename("overlay");

		h = getHeight();
		w = getWidth();

		selectWindow("raw");
		run("Size...", "width=" + w + " height=" + h + " constrain average interpolation=Bilinear");

		run("Images to Stack", "name=stk title=[] use");
		
		saveAs("tiff",save_dir + basename + "_raw_overlay_stk.tif");
		run("Close All");
		
	}
}

