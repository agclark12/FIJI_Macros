//For a series of segmented images, this script overlays the original
//image with a contour of the segmentation

setBatchMode(true);

function get_contour() {

	rename("seg");

	selectWindow("seg");
	run("Convert to Mask", "method=Default background=Light calculate");
	run("Grays");
	run("Duplicate...", "duplicate");
	rename("seg2");
	run("Dilate", "stack");
	run("Invert", "stack");
	selectWindow("seg");
	run("Erode", "stack");
	run("Invert", "stack");
	imageCalculator("Subtract create stack", "seg2","seg");
	selectWindow("Result of seg2");
	rename("contour");

	selectWindow("seg");
	close();
	selectWindow("seg2");
	close();

	selectWindow("contour");
	
}

function overlay_contour(img_path,seg_path) {

	open(img_path);
	rename("img");
	run("Hyperstack to Stack");
	
	open(seg_path);
	rename("seg");
	//get_contour();
	rename("contour");
	Stack.getDimensions(width, height, channels, slices, frames);
	run("Hyperstack to Stack");

	run("Merge Channels...", "c4=img c6=contour");
	run("RGB Color", "channels frames slices");

	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+channels+" frames="+slices+" display=Color");
	
	rename("overlay");

}

function main() {

	img_suffix = ".tif"
	//seg_suffix = "_seg_.\.tif"
	//overlay_suffix = "_seg_comb.tif"
	seg_suffix = "_seg_clean_v2.tif"
	overlay_suffix = "_comb.tif"
	
	img_dir = getDirectory("please select your image directory");
	seg_dir = img_dir;
	save_dir = seg_dir + "overlay/"
	File.makeDirectory(save_dir);
	
	img_dir_list = getFileList(img_dir);
	seg_dir_list = getFileList(seg_dir);
	
	for (i=0;i<lengthOf(img_dir_list);i++) {
		img_name = img_dir_list[i];
		if (matches(img_name,".*"+img_suffix)) {
			basename = substring(img_name,0,indexOf(img_name,img_suffix));
			print(basename);
			img_path = img_dir+img_name;
			for (j=0;j<lengthOf(seg_dir_list);j++) {
				seg_name = seg_dir_list[j];
				print(seg_name);
				if (matches(seg_name,basename+seg_suffix)) {
					seg_path = seg_dir+seg_name;

					overlay_contour(img_path,seg_path);
					rename("overlay");
					saveAs(save_dir+substring(seg_name,0,indexOf(seg_name,img_suffix))+overlay_suffix);
					run("Close All");
				}
			}
		}
	}
}

run("Close All");
main();
