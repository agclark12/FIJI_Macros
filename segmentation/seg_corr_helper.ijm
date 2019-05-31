//just a little helper macro for correcting 3D nuclear segmentation on-the-fly

title = getInfo("window.title");
//title = getInfo("image.filename");
rename("stk");
run("Connected Components Labeling", "connectivity=6 type=[8 bits]");
//run("glasbey");
rename("new_stk");
selectWindow("stk");
close();
selectWindow("new_stk");
rename(title);