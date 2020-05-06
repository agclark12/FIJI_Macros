//automatically crops a registered image where the edges are not straight
// (because registration was rigid body including rotation)
//This version works if the borders are pretty straight, but does not work well if the borders are quite diagonal

function find_first_target(array,target) {
	//finds the start and stop positions of an array where the value = the max value of the array
	idx = 0;
	while (idx==0) {
		for (i=0;i<array.length;i++) {
			if (array[i]==target) {
				idx = i;
			}
		}
	}
	return idx;
}

function main() {
	
	rename("stk");
	run("Duplicate...", "duplicate");
	rename("thresh");
	setMinAndMax(0, 0);
	run("Apply LUT", "stack");
	run("Z Project...", "projection=[Min Intensity]");
	run("Auto Crop");
	rename("min");
	
	getDimensions(width, height, channels, slices, frames);

	//find the downward linescan where the first white pixel shows up last
	upper_list = newArray(width);
	for (i=0;i<width;i++) {
		makeLine(i,0,i,height,1);
		i_list = getProfile();
		idx = find_first_target(i_list,255);
		upper_list[i] = idx;
	}



	stop
	
	
	//get the minimum white only vertical coordinates
	mid_width = round(width/2);
	makeLine(mid_width, 0, mid_width, height, width*2);
	i_vertical = getProfile();
	crop_pos_vertical = find_start_stop_max(i_vertical);
	Array.print(crop_pos_vertical);

	//get the minimum white only horizontal coordinates
	mid_height = round(height/2);
	makeLine(0, mid_height, width, mid_height, height*2);
	i_horiz = getProfile();
	crop_pos_horiz = find_start_stop_max(i_horiz);
	Array.print(crop_pos_horiz);

	//crop the image
	selectWindow("stk");
	makeRectangle(crop_pos_horiz[0], crop_pos_vertical[0], crop_pos_horiz[1], crop_pos_vertical[1]);
	run("Duplicate...", "duplicate");
	rename("cropped");
	

	
}

main()