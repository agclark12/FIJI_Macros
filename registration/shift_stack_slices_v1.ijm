//adjusts the positions of slices for a tz hyperstack according to a slice list

setBatchMode(true);

//set buffer range of images above/below for final image
//buffer = 13;

//gets file and info
open();
data_dir = getInfo("image.directory");
img_name = getInfo("image.filename");
base_name = substring(img_name, 0, lengthOf(img_name) - 4);

//open file and generate slice list
infile = File.openAsString(data_dir + base_name + "_slice_list.dat");
slice_list = split(infile,"\n");

//get the first key frame
line0 = split(slice_list[0]," ");
slice0 = parseInt(line0[1]);

getDimensions(width, height, channels, slices, frames);
rename("orig");

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
run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices*3+" frames="+frames+" display=Grayscale");

//loop through slice list, isolate slices and save
for (i = 0; i < lengthOf(slice_list); i++) {

	//get image name and slice number
	line = split(slice_list[i]," ");
	frame = line[0];
	key_slice = parseInt(line[1]);

	slice_diff = slice0 - key_slice;
	//print(slice_diff);

	for (j = 1; j < slices+1; j++) {

		//print("frame: "+ frame +"- copying slice "+ j +" to slice "+ j+slices+slice_diff);
		
		//copy image from original image
		for (k=1; k<channels+1; k++) {

			selectWindow("orig");
			Stack.setFrame(frame);
			Stack.setSlice(j);
			Stack.setChannel(k);
			run("Select All");
			run("Copy");
	
			//paste image in new stack
			selectWindow("stk");
			Stack.setFrame(frame);
			Stack.setSlice(j+slices+slice_diff);
			Stack.setChannel(k);
			run("Paste");
		}
	}
}
run("Select None");

//before saving, reduce image back to original number of stacks
//(comment out if full stack is wanted)
//run("Duplicate...", "duplicate slices="+(slices+1)+"-"+(slices*2+1));

//(or modify the duplication range manually)
//run("Duplicate...", "duplicate slices=38-74");

//(or set the stack range using the buffer)
//run("Duplicate...", "duplicate slices="+(slices+1-buffer)+"-"+(slices*2+buffer));

//save new stack and close everything
saveAs("tiff", data_dir + base_name +  "_shifted.tif");
run("Close All");
	