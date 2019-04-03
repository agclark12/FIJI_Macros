dir = getInfo("image.directory");
filename = getInfo("image.filename");
sb_size = 20;

Dialog.create("Set Channel Colors");
Dialog.addNumber("Blue Channel:",1);
Dialog.addNumber("Green Channel:",2);
Dialog.addNumber("Magenta Channel:",4);
Dialog.show();
blue = Dialog.getNumber();
green = Dialog.getNumber();
magenta = Dialog.getNumber();

ch_blue = "C"+blue+"-input";
ch_green = "C"+green+"-input";
ch_magenta = "C"+magenta+"-input";

run("Duplicate...", "duplicate");
rename("input");
run("Split Channels");

//selectWindow("C4-input");
//close();

//merges channels
//C1 (red);
//C2 (green);
//C3 (blue);
//C4 (gray);
//C5 (cyan);
//C6 (magenta);
//C7 (yellow);

run("Merge Channels...", "c2="+ch_green+" c3="+ch_blue+" c6="+ch_magenta+" create keep");
rename("merge");
run("RGB Color", "slices");

//combines stacks
run("Combine...", "stack1="+ch_blue+" stack2="+ch_green);
run("Combine...", "stack1=[Combined Stacks] stack2="+ch_magenta);
selectWindow("Combined Stacks");
run("RGB Color", "slices");
run("Combine...", "stack1=[Combined Stacks] stack2=merge");

//adds scale bar
//run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
w = getWidth();
h = getHeight();
makeRectangle(w-80, h-30, 10, 10);
run("Scale Bar...", "width=" + sb_size + " height=6 font=28 color=White background=None location=[At Selection] bold hide label");

//run("Reverse"); //because these stacks go the opposite way
ext = substring(filename,indexOf(filename,"."),lengthOf(filename));
rename(replace(filename,ext,"_ch"+toString(blue)+toString(green)+toString(magenta)+"merge_w"+sb_size+"umSB.tif"));
run("Select None");