//This macro is designed to run the Extended Depth of Field plugin (Expert Mode)
//Since there is no way to access the plugin directly from the macro, the 
//macro makes use of IJ Robot. The EDoF plugin can be left with default parameters,
//but turn on Denoising (in Post-Processing) for better results. The macro
//will ask for user input in the beginning to check where the "Run" button of the 
//EDoF plugin is located. The stack you want to process should be open.

//makes a dialog to get position of "Run" button of plugin
Dialog.create("Choose coordinates of Run botton of EDoF plugin");
Dialog.addNumber("x", 0);
Dialog.addNumber("y", 0);
Dialog.show();
x_pos = Dialog.getNumber();
y_pos = Dialog.getNumber();

//setBatchMode(true);

//gets some info about the image
orig = getImageID();
dir = getInfo("image.directory");
filename = getInfo("image.filename");
no_frames = Stack.getDimensions(width, height, channels, slices, frames);

//make a new stack for the output
run("Duplicate...", "duplicate frames=1");
out = getImageID();
resetMinAndMax();
run("8-bit");

//loops through stack and runs the EDoF plugin
for (i=1; i<frames+1; i++) {

	selectImage(orig);
	run("Duplicate...", "duplicate frames=" + i);
	current = getImageID();
	print("Running Extended Depth of Field for Frame " + i);
	run("IJ Robot", "order=Left_Click x_point=" + x_pos + " y_point=" + y_pos + " delay=300 keypress=[]");
	
	//doesn't do anything until the the new output image is produced
	//waitForUser;
	wait(15000);
	toggle = true;
	while (toggle) {
		title = getTitle();
		if (matches(title,"Output")) {
			print("Extended Depth of Field finished for Frame " + i);
			toggle=false;
		} else {
			print("EDoF not finished, waiting another 5 seconds");
			wait(5000); //wait another 10 seconds before trying again
		}
	}

	//adds new slice to the output stack
	resetMinAndMax();
	run("8-bit");
	run("Select All");
	run("Copy");
	close();
	selectImage(out);
	run("Add Slice");
	run("Paste");

	//closes the current timepoint
	selectImage(current);
	close();

}

//goes back and deletes the first frame (which was from the original stack
selectImage(out);
setSlice(1);
run("Delete Slice");

//saves image
saveAs("tiff",dir + "/" + replace(filename,".tif","_EDoF.tif"));
run("Close All");