//autocrops a multidimentional hyperstack in order to cut off black edges (from registration)
//this version just does an xy crop and assumes that all channels and z-slices are xy registered equally

setBatchMode(true);

test_path = "/Users/clark/Documents/Work/Programming/current_analysis_projects/Rali_cell_tracking/crop_test/test_hstk.tif"
open(test_path);

Stack.getDimensions(w, h, channels, slices, frames);

x1 = newArray(frames);
x2 = newArray(frames);
y1 = newArray(frames);
y2 = newArray(frames);

for (i=1; i<frames+1; i++){
	
	run("Duplicate...", "duplicate channels=1 slices=" + round(slices/2) +" frames=" + i);
	getStatistics(area, mean, min, max, std, histogram);
	if (max > 0) {
		run("Select Bounding Box (guess background color)");
		Roi.getBounds(x, y, width, height);
		x1[i-1] = x;
		x2[i-1] = x + width;
		y1[i-1] = y;
		y2[i-1] = y + height;		
	} else {
		x1[i-1] = 0;
		x2[i-1] = w;
		y1[i-1] = 0;
		y2[i-1] = h;
	}
	close();
}

Array.getStatistics(x1, min, max, mean, stdDev);
bbx1 = max;

print("here");
for (i=0;i<x2.length;i++) {
	print(x2[i]);
}

Array.getStatistics(x2, min, max, mean, stdDev);
bbx2 = min;
Array.getStatistics(y1, min, max, mean, stdDev);
bby1 = max;
Array.getStatistics(y2, min, max, mean, stdDev);
bby2 = min;

print(bbx1,bbx2,bby1,bby2);

run("Specify...", "width=" + bbx2-bbx1 + " height=" + bby2-bby1 + " x=" + bbx1 + " y=" + bby1);
setBatchMode("exit and display");
