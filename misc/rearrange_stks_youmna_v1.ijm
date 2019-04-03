//This macro takes cell and bead image stacks
//and splits them up and saves them in subdirectories.

setBatchMode(true);

//gets base directory and creates new subdirectories
dir = getDirectory("Hello Queen Youmna, which directory would you like to choose?");
File.makeDirectory(dir + "analysis");
File.makeDirectory(dir + "analysis/cells");

//saves each slice for bead stack as png in analysis subdirectory
open(dir + "beadsCrop.tif");
run("Enhance Contrast", "saturated=0.35");
run("8-bit");
for (i=1; i<nSlices+1; i++) {
	setSlice(i);
	run("Duplicate...", "title=slice");
	if (i<10) {
		saveAs("png",dir + "analysis/frame0" + i);
	} else {
		saveAs("png",dir + "analysis/frame" + i);
	}
	close();
}
close();

//saves control as png for beads
open(dir + "beadsCtrl.tif");
run("Enhance Contrast", "saturated=0.35");
run("8-bit");
saveAs("png",dir + "analysis/frame12");
close();

//saves each slice for cell stack as png in analysis subdirectory
open(dir + "cellCrop.tif");
run("8-bit");
for (i=1; i<nSlices+1; i++) {
	setSlice(i);
	run("Duplicate...", "title=slice");
	if (i<10) {
		saveAs("png",dir + "analysis/cells/frame0" + i);
	} else {
		saveAs("png",dir + "analysis/cells/frame" + i);
	}
	close();
}
close();

//saves control as png for cells
open(dir + "cellCtrl.tif");
saveAs("png",dir + "analysis/cells/frame12");
run("8-bit");
close();