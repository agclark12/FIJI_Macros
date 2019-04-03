/*
 * Makes brightest point projections and merge/montage for
 * stacks with ch1:DAPI, ch2:BF, ch3:collagen, ch4:actin
 * 
 * @author   Andrew G. Clark
 * @version  1.0
 * @since    2015-12-16
 */

//setBatchMode(true);

px_size = 0.07; //px_size (in microns)
sb_size = 10; //size of scale bar (in microns)
sb_height = 7; //height of scale bar (in pixels)

open(); //opens file using a dialog to select file

//gets some basic file info
stack = getInfo("image.filename");
data_dir = getInfo("image.directory");
basename = substring(stack, 0, lengthOf(stack) - 4);

//sets pixel size
run("Set Scale...", "distance=1 known=" + px_size + " unit=unit");

run("Deinterleave", "how=2");

//run("Merge Channels...", "c2=[" + stack + " #1] c6=[" + stack + " #2] keep"); //ch2=green,ch6=magenta
run("Merge Channels...", "c5=[" + stack + " #1] c6=[" + stack + " #2] keep"); //ch5=cyan,ch6=magenta
selectWindow(stack + " #1");
run("RGB Color");
selectWindow(stack + " #2");
run("RGB Color");
run("Concatenate...", "  title=[Concatenated Stacks] image1=[" + stack + " #1] image2=[" + stack + " #2] image3=RGB image4=[-- None --]");
run("Make Montage...", "columns=3 rows=1 scale=1 first=1 last=3 increment=1 border=2 font=12");

//optional scale bar (comment out if you don't want a scale bar)
//run("Scale Bar...", "width=" + sb_size + " height=" + sb_height + " font=18 color=White background=None location=[Lower Right] bold hide");

saveAs("tiff", data_dir + basename + "_mont.tif");
run("Close All");