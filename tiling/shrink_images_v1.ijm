//this macro goes through a directory and downsizes
//a series of images and saves the resulting images
//in a new directory

print("Running!");

function getSum(array) {
	sum = 0;
	for (x=0;x<lengthOf(array);x++) { 
		sum = sum + array[x];
	}
	return sum
}


function optimize_intensities() {
		
	Stack.getDimensions(width, height, channels, slices, frames);
	no_pixels = width * height;
	px_fract = no_pixels * 0.0004;
	print(px_fract);
	
	min_list = newArray(channels+1);
	max_list = newArray(channels+1);
		
	for (i=1;i<channels+1;i++) {
		
		Stack.setChannel(i);
		//find slice with maximum mean intensity
		max_int_slice = 1;
		mean_max = 0;
			
		for (j=1;j<slices+1;j++) {
			Stack.setSlice(j);
			getStatistics(area, mean, min, max, std, histogram);
			if (mean > mean_max) {
				mean_max = mean;
				max_int_slice = j;
			}
		}
			
		Stack.setSlice(max_int_slice);
		getStatistics(area, mean, min, max, std, histogram);
		resetMinAndMax();
	}
}

setBatchMode(true);

ch_keyword = "561";
img_extension = "TIF";

//data_dir = "/Volumes/equipe_vignjevic/a_clark/RawData/2014-09-29";
//data_dir = "/Volumes/equipe_vignjevic/a_clark/RawData/2014-10-01/DIC_test_2";
//save_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-01";

//data_dir = getDirectory("Image directory containing raw images");
//save_dir = getDirectory("Image directory to save new images");

data_dir = "/Volumes/equipe_vignjevic/a_clark/RawData/2014-10-12"
save_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-12"


//loops through data directory
dir_list = getFileList(data_dir);

for (i=0; i<dir_list.length; i++) {
	if (matches(dir_list[i],".*" + ch_keyword + ".*" + img_extension)) {
		out_path = save_dir + "/" + dir_list[i];
		if (File.exists(out_path)) {
			print("File already transfered: " + dir_list[i]);
		} else {
			print("Transferring file: " + dir_list[i]);
			open(data_dir + "/" + dir_list[i]);
			//optimize_intensities();
			//resetMinAndMax();
			run("Size...", "width=512 height=512 depth=" + nSlices + " constrain average interpolation=Bilinear");
			//run("8-bit");
			//resetMinAndMax();
			saveAs("tiff",out_path);
			close();
		}
	}
}

setBatchMode(false);