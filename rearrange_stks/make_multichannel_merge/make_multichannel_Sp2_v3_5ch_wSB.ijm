//makes multichannel bpp's and avi's
//5 channels
//this version selectively works on certain images and merges certain channels

function open_enhance(path,img_name,factor){

	open(path);
	rename(img_name);
	run("Grays");
	run("Enhance Contrast...", "saturated="+factor+" process_all use");
	run("8-bit");

}

function combine_images(data_dir,save_dir,keyword,keyword_C1,keyword_C2,keyword_C3,keyword_C4,keyword_C5,px_size,sb_size) {

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

		if (matches(basename,".*"+keyword+".*")) {
					
			print(basename);
		
			//opens images for each channel
			open_enhance(data_dir+basename_list[i]+keyword_C1+extension,"C1",0.01);
			open_enhance(data_dir+basename_list[i]+keyword_C2+extension,"C2",0.01);
			getDimensions(width, height, channels, slices, frames);
			open_enhance(data_dir+basename_list[i]+keyword_C3+extension,"C3",0.01);
			open_enhance(data_dir+basename_list[i]+keyword_C4+extension,"C4",0.01);
			open_enhance(data_dir+basename_list[i]+keyword_C5+extension,"C5",0.01);
		
			
			//makes hyperstack
			print("Making combined hyperstack");
			run("Concatenate...", "  title=concat keep image1=C2 image2=C3 image3=C4 image4=C5 image5=[-- None --]");
			run("Stack to Hyperstack...", "order=xyzct channels=4 slices=" + slices + " frames=1 display=Grayscale");
			saveAs("tiff", data_dir + basename + "_comb.tif");
			
			//merges channels
			//c1 (red);
			//c2 (green);
			//c3 (blue);
			//c4 (gray);
			//c5 (cyan);
			//c6 (magenta);
			//c7 (yellow);
			run("Merge Channels...", "c2=C3 c3=C2 c6=C5 create keep");
			rename("merge");
			run("RGB Color", "slices");

			//combines stacks
			print("Combining Stacks");
			run("Combine...", "stack1=C2 stack2=C3");
			run("Combine...", "stack1=[Combined Stacks] stack2=C4");
			run("Combine...", "stack1=[Combined Stacks] stack2=C5");
			//selectWindow("Combined Stacks");
			//run("RGB Color", "slices");
			//run("Combine...", "stack1=[Combined Stacks] stack2=merge");
			//run("Combine...", "stack1=[Combined Stacks] stack2=C4");
	
			//adds scale bar
			run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
			w = getWidth();
			h = getHeight();
			makeRectangle(w-200, h-40, 10, 10);
			run("Scale Bar...", "width=" + sb_size + " height=12 font=28 color=White background=None location=[At Selection] bold hide label");
	
			run("Reverse"); //because these stacks go the opposite way

		
			//makes avi of stack
			run("AVI... ", "compression=JPEG frame=8 save=[" + save_dir + basename + "_mont_w" + sb_size +"umSB_C2C3C5.avi" + "]");
		
			//makes bpp
			print("Making BPP");
			run("Z Project...", "projection=[Max Intensity]");
			saveAs("tiff", save_dir + basename + "_bpp_w" + sb_size +"umSB_merge_C2C3C5.tif");
	
			//closes
			run("Close All");
		
		}		
	}
}

function main(){

	keyword = "";
	keyword_C1 = "_w11-Trans -bypath-";
	keyword_C2 = "_w22    spinning  DAPI";
	keyword_C3 = "_w32    spinning  GFP";
	keyword_C4 = "_w42    spinning  mCherry";
	keyword_C5 = "_w52    spinning  Cy5";
	extension = ".TIF";

	px_size = 6.5/60;
	//px_size = 0.2750;
	sb_size = 20;
	

	data_dir = getDirectory("Choose Data Directory");
	//save_dir = getDirectory("Choose Save Directory");
	save_dir = data_dir + "avi/";
	File.makeDirectory(save_dir);

	combine_images(data_dir,save_dir,keyword,keyword_C1,keyword_C2,keyword_C3,keyword_C4,keyword_C5,px_size,sb_size);
	
}

setBatchMode(true);
main();

