//adjusts the positions of slices for a tz hyperstack according to a slice list
//v2 automatically finds the slices

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

setBatchMode(true);

//set buffer range of images above/below for final image
buffer = 6;

//gets file and info
open();
data_dir = getInfo("image.directory");
img_name = getInfo("image.filename");
base_name = substring(img_name, 0, lengthOf(img_name) - 4);

//get the first key frame
Stack.setFrame(1);
slice0 = find_brightest_slice_hstk();
print(slice0);

getDimensions(width, height, channels, slices, frames)
rename("orig");

//converts to 8-bit
print("converting to 8-bit");
Stack.getDimensions(width, height, channels, slices, frames);
for (j=1; j<channels+1; j++) {
	Stack.setChannel(j);
	idx = find_brightest_slice_hstk();
	Stack.setSlice(idx);
	resetMinAndMax();
}
run("8-bit");

//make new stack with 3x the slices (work-around to make sure it's the same type)
run("Duplicate...", "duplicate");
rename("tmp1");
run("Select All");
run("Clear", "stack");

for (i = 2; i < 4; i++) {
	selectWindow("tmp1");
	run("Duplicate...", "duplicate");
	rename("tmp"+i);
}
run("Concatenate...", "  title=stk image1=tmp1 image2=tmp2 image3=tmp3 image4=[-- None --]");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slices*3+" frames="+frames+" display=Grayscale");

//loop through slice list, isolate slices and save
for (i=0; i<(frames+1); i++) {

	//get image name and slice number
	selectWindow("orig");
	frame = i;
	Stack.setFrame(frame);
	key_slice = find_brightest_slice_hstk();
	print(key_slice);
	
	slice_diff = slice0 - key_slice;
	//print(slice_diff);

	for (j = 1; j < slices+1; j++) {

		//print("frame: "+ frame +"- copying slice "+ j +" to slice "+ j+slices+slice_diff);
		
		//copy image from original image
		selectWindow("orig");
		Stack.setFrame(frame);
		Stack.setSlice(j);
		run("Select All");
		run("Copy");

		//paste image in new stack
		selectWindow("stk");
		Stack.setFrame(frame);
		Stack.setSlice(j+slices+slice_diff);
		run("Paste");
	}
}
run("Select None");

//before saving, reduce image back to original number of stacks
//(comment out if full stack is wanted)
//run("Duplicate...", "duplicate slices="+(slices+1)+"-"+(slices*2+1));

//(or modify the duplication range manually)
//run("Duplicate...", "duplicate slices=38-74");

//(or set the stack range using the buffer)
run("Duplicate...", "duplicate slices="+(slices+1-buffer)+"-"+(slices*2+buffer));

//save new stack and close everything
saveAs("tiff", data_dir + base_name +  "_shifted_v2.tif");
run("Close All");
	