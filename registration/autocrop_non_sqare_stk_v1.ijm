//automatically crops a registered image where the edges are not straight
// (because registration was rigid body including rotation)
//This version works if the borders are pretty straight, but does not work well if the borders are quite diagonal

function find_start_stop_max(array) {
	//finds the start and stop positions of an array where the value = the max value of the array
	Array.getStatistics(array, min, max, mean, stdDev);
	min_pos = array.length;
	max_pos = 0;
	for (i=0;i<array.length;i++) {
		if (array[i]>max/2) {
			if (i<min_pos) {
				min_pos = i;
			}
			if (i>max_pos) {
				max_pos = i;
			}
		}
	} 
	output = newArray(min_pos+1,max_pos+1); //+1 to put it in image coordinates (arrays start at 0, images at 1)
	return output;
}

function main() {
	
	rename("stk");
	run("Duplicate...", "duplicate");
	rename("thresh");
	setMinAndMax(0, 0);
	run("Apply LUT", "stack");
	run("Z Project...", "projection=[Min Intensity]");
	rename("min");
	
	getDimensions(width, height, channels, slices, frames);
	
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