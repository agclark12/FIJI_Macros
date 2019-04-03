//makes .avi movies from a directory full of tiff stacks

run("Close All");
setBatchMode(true);
//select directory
master_dir = getDirectory("Select Master Directory");
save_dir = getDirectory("Select Save Directory");
data_dir_name = "Images"
dir_list = getFileList(master_dir);

//set some parameters
//px_size = 0.1083333
//sb_size = 10; //in microns
time_int = 15; //in minutes
file_ext = ".jpg"

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(dir_list); i++) {

	data_dir = master_dir + dir_list[i] + data_dir_name + "/" ;
	print(data_dir);
	if (File.isDirectory(data_dir)) {

		//opens image
		run("Image Sequence...", "open=" + data_dir + " file=[(.*" + file_ext + ")]" + " sort");
			
		//adds time stamp
		setForegroundColor(0, 0, 0);
		run("Time Stamper", "starting=0 interval=" + time_int + " x=-80 y=80 font=70 '00 decimal=0 anti-aliased or=sec");

		//adds scale bar
		//run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
		//w = getWidth();
		//h = getHeight();
		//makeRectangle(w-120, h-40, 10, 10);
		//run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");

		//saves image
		run("AVI... ", "compression=JPEG frame=12 save=[" + save_dir + substring(dir_list[i],0,lengthOf(dir_list[i])-1) + ".avi" + "]");		
		run("Close All");
	}
}