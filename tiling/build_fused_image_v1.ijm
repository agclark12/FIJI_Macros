//Makes a combined image stack from a tiled multichannel image (BF,GFP,mcherry)
//and saves intermediate steps

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

//combines images and saves as tif and avi
run("Combine...", "stack1=BF stack2=GFP");
run("Combine...", "stack1=[Combined Stacks] stack2=mcherry");
run("RGB Color");
run("Combine...", "stack1=[Combined Stacks] stack2=merge");
saveAs("tiff", dir + basename +  "_comb.tif");
run("AVI... ", "compression=JPEG frame=12 save=[" + dir +  basename + "_comb.avi]");
close();

setBatchMode(false);
