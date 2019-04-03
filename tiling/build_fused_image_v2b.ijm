//Makes a combined image stack from a tiled multichannel image (BF,GFP,mcherry)
//and saves intermediate steps

//v2 puts a scale bar and timestamp on the image (be sure to check these)
//v2b stacks the channels vertically instead of horizontally

px_size = 0.645*4; //in microns (mult. by 4 because the images are reduced by 2 in size and binning=2)
time_int = 15; //in minutes
sb_size = 200; //in microns

setBatchMode(true);

//gets some basic info
filename = getInfo("image.filename");
basename = substring(filename,0,lengthOf(filename)-4);
dir = getInfo("image.directory");
rename("tile");

//splits and saves individual channels
run("Split Channels");
selectWindow("C1-tile");
run("Grays");
saveAs("tiff", dir + basename + "_BF.tif");
rename("BF");
selectWindow("C2-tile");
run("Grays");
saveAs("tiff", dir + basename + "_GFP.tif");
rename("GFP");
selectWindow("C3-tile");
run("Grays");
saveAs("tiff", dir + basename +  "_mcherry.tif");
rename("mcherry");

//merges channels and saves
run("Merge Channels...", "c1=mcherry c2=GFP c4=BF keep");
run("RGB Color", "frames");
saveAs("tiff", dir + basename +  "_merge.tif");
rename("merge");

//combines images and saves as tif
run("Combine...", "stack1=BF stack2=GFP combine");
run("Combine...", "stack1=[Combined Stacks] stack2=mcherry combine");
run("RGB Color");
run("Combine...", "stack1=[Combined Stacks] stack2=merge combine");
saveAs("tiff", dir + basename +  "_comb.tif");

//adds scale bar
run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
w = getWidth();
h = getHeight();
makeRectangle(w-100, h-40, 10, 10);
run("Scale Bar...", "width=" + sb_size + " height=8 font=28 color=White background=None location=[At Selection] bold hide label");

//adds time stamp
setForegroundColor(255, 255, 255);
run("Time Stamper", "starting=0 interval=15 x=-80 y=80 font=60 '00 decimal=0 anti-aliased or=sec");
saveAs("tiff", dir + basename +  "_comb.tif");


//save as tiff and avi
saveAs("tiff", dir + basename +  "_comb_w" + sb_size + "um_SB.tif");
run("AVI... ", "compression=JPEG frame=12 save=[" + dir +  basename +  "_comb_w" + sb_size + "um_SB.avi]");
close();

setBatchMode(false);
