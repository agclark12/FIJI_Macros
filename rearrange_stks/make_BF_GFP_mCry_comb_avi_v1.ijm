//Makes a combined image stack from a tiled multichannel image (BF,GFP,mCherry)
//and saves intermediate steps

setBatchMode(true);

//gets some basic info
dir = getInfo("image.directory");
rename("stk");

//splits into individual channels
run("Split Channels");
selectWindow("C1-stk");
run("Grays");
selectWindow("C2-stk");
run("Grays");
selectWindow("C3-stk");
run("Grays");

//merges channels and saves
run("Merge Channels...", "c1=C3-stk c2=C2-stk c4=C1-stk keep");
run("RGB Color", "frames");
saveAs("tiff", dir + "stk_merge.tif");

//combines images and saves as tif and avi
run("Combine...", "stack1=C1-stk stack2=C2-stk");
run("Combine...", "stack1=[Combined Stacks] stack2=C3-stk");
run("RGB Color");
run("Combine...", "stack1=[Combined Stacks] stack2=stk_merge.tif");
saveAs("tiff", dir + "tile_comb.tif");
run("AVI... ", "compression=JPEG frame=12 save=[" + dir + "tile_comb.avi]");
close();

setBatchMode(false);
