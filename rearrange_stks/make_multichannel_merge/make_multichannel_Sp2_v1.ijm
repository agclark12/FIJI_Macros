//makes multichannel bpp's and avi's
//4 channels

function open_enhance(path,img_name,factor){

	open(path);
	rename(img_name);
	run("Grays");
	run("Enhance Contrast...", "saturated="+factor+" process_all use");
	run("8-bit");

}

function combine_images(data_dir,save_dir,keyword_C1,keyword_C2,keyword_C3,keyword_C4) {

	dir_list = getFileList(data_dir);
	basename_list = newArray();
	
	//goes through directory and gets all the basenames
	for (i=0; i<lengthOf(dir_list); i++) {
		if (matches(dir_list[i],".*"+keyword_C1+extension)) {
			print(dir_list[i]);
			basename = substring(dir_list[i],0,indexOf(dir_list[i],keyword_C1));
			print(basename);
			basename_list = Array.concat(basename_list,newArray(basename));
		}
	}
	
	//goes through directory and does stuff with the images
	for (i=0; i<lengthOf(basename_list); i++) {

		basename = basename_list[i];
		print(basename);
	
		//opens images for each channel
		open_enhance(data_dir+basename_list[i]+keyword_C1+extension,"C1",0.01);
		getDimensions(width, height, channels, slices, frames);
		open_enhance(data_dir+basename_list[i]+keyword_C2+extension,"C2",0.01);
		open_enhance(data_dir+basename_list[i]+keyword_C3+extension,"C3",0.01);
		open_enhance(data_dir+basename_list[i]+keyword_C4+extension,"C4",0.01);
	
		/*
		//makes hyperstack
		print("Making combined hyperstack");
		run("Concatenate...", "  title=concat keep image1=C1 image2=C2 image3=C3 image4=C4 image5=[-- None --]");
		run("Stack to Hyperstack...", "order=xyzct channels=4 slices=" + slices + " frames=1 display=Grayscale");
		saveAs("tiff", data_dir + basename + "_" + i + "_comb.tif");
		*/
	
		//merges channels
		//C1 (red);
		//C2 (green);
		//C3 (blue);
		//C4 (gray);
		//C5 (cyan);
		//C6 (magenta);
		//C7 (yellow);
		run("Merge Channels...", "c3=C2 c2=C3 create keep");
		rename("merge");
		run("RGB Color", "slices");
	
		//combines stacks
		print("Combining Stacks");
		run("Combine...", "stack1=C1 stack2=C2");
		run("Combine...", "stack1=[Combined Stacks] stack2=C3");
		selectWindow("Combined Stacks");
		run("RGB Color", "slices");
		run("Combine...", "stack1=[Combined Stacks] stack2=merge");
		//run("Combine...", "stack1=[Combined Stacks] stack2=C4");
	
		//makes avi of stack
		run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_mont.avi" + "]");
	
		//makes bpp
		print("Making BPP");
		run("Z Project...", "projection=[Max Intensity]");
		saveAs("tiff", save_dir + basename + "_bpp.tif");

		//closes
		run("Close All");		
	}
}

function main(){
	
	keyword_C1 = "_w11-Trans -bypath-";
	keyword_C2 = "_w22    spinning  DAPI";
	keyword_C3 = "_w32    spinning  GFP";
	keyword_C4 = "_w42    spinning  mCherry";
	extension = ".TIF";

	data_dir = getDirectory("Choose Data Directory");
	save_dir = getDirectory("Choose Save Directory");
	File.makeDirectory(save_dir);

	combine_images(data_dir,save_dir,keyword_C1,keyword_C2,keyword_C3,keyword_C4);
	
}

setBatchMode(true);
main();

