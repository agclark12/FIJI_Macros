//makes a .avi montage from a single slice of a
//2 ch hyperstack

stack = getInfo("image.filename");
data_dir = getInfo("image.directory");
basename = substring(stack, 0, lengthOf(stack) - 4);

slice = getNumber("Choose slice",1);
Stack.setSlice(slice);
run("Reduce Dimensionality...", "channels frames");
run("Split Channels");
selectWindow("C1-" + stack);
run("Enhance Contrast...", "saturated=0.01 process_all use");
run("8-bit");
selectWindow("C2-" + stack);
run("Enhance Contrast...", "saturated=0.01 process_all use");
run("8-bit");
run("Combine...", "stack1=C1-" + stack + " stack2=C2-" + stack);
run("AVI... ", "compression=JPEG frame=12 save=[" + data_dir + basename + "_z" + slice + "_mont.avi" + "]");
run("Close All");