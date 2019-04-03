setBatchMode(true);

dir = getDirectory("Select directory containing .lif file");
dir_list = getFileList(dir);

infile = File.openAsString(dir + "series_list.dat");
series_list = split(infile,"\n");

for (j=0;j<series_list.length;j++) {
	series_no = series_list[j];
	for (i=0;i<lengthOf(dir_list);i++) {
		filename = dir_list[i];
		if (matches(filename,".*"+"lif")) {
			run("Bio-Formats Importer", "open=[" + dir + filename + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_" + series_no);
			saveAs(".tiff",dir+replace(filename,".lif","_series"+series_no+".tif"));
			run("Close All");
		}
	}
	
}

