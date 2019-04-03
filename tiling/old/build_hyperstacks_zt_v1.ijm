//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

//setBatchMode(true);

no_frames = 162;
no_slices = 17;

ch_keyword = "561";

//data_dir = "/Volumes/equipe_vignjevic/a_clark/RawData/2014-09-29";
data_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-09/shrunken";
save_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-09";


//loops through data directory
dir_list = getFileList(data_dir);

run("Image Sequence...", "open=" + data_dir + " number=" + no_frames + " starting=1 increment=1 scale=100 file=["+ ch_keyword + "_t] sort");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + no_slices + " frames=" + no_frames + " display=Grayscale");
//rename(i);
//run("8-bit");
//resetMinAndMax();
outPath = save_dir + "/" + ch_keyword + ".tif";
print(outPath);
saveAs("tiff", outPath);
close();


setBatchMode(false);