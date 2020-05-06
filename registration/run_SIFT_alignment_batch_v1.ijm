//registers tz tiff series for a whole directory and converts to 8-bit
//v3 only performs the registration

setBatchMode(true);

//gets directories for loading and saving
data_dir = getDirectory("Which Directory?");
dir_list = getFileList(data_dir);
save_dir = data_dir + "reg/";
File.makeDirectory(save_dir);
keyword = "mCherry_bpp";

for (i=0; i<lengthOf(dir_list); i++) {

	filename = dir_list[i];
	if (matches(filename, ".*" + keyword + ".*")) {

		//opens file
		print(filename);
		open(data_dir + "/" + filename);
		basename = substring(filename, 0, lengthOf(filename) - 4);
		Stack.getDimensions(width, height, channels, slices, frames);
		rename("stk");

		//correct drift
		print("correcting drift");
		run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");

		//saves image
		//selectWindow("registered time points");
		filename = dir_list[i];
		filename_new_start = substring(filename, 0, indexOf(filename,"_s"));
		filename_new_end = substring(filename, indexOf(filename,"_s"), lengthOf(filename));
		filename_new = filename_new_start + "_reg" + filename_new_end;
		saveAs("tiff",save_dir + filename_new);
		
		run("Close All");
		run("Collect Garbage");
	}
}			

		