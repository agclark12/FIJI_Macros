//px_size = 0.5676335358; //in microns - this should already be set, otherwise, uncomment the 'setScale command below'
//px_size = 0.645
//px_size = 0.9082031 * 448 / 1800; // (to account for image rescaling)
px_size = 0.9082031
time_int = 30; //in minutes
sb_size = 50; //in microns

//adds time stamp
setForegroundColor(255, 255, 255);
run("Time Stamper", "starting=0 interval=" + time_int + " x=-100 y=40 font=50 '00 decimal=0 anti-aliased or=sec");
//saveAs("tiff", dir + basename +  "_comb.tif");

/*
//adds scale bar
run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
w = getWidth();
h = getHeight();
makeRectangle(w-250, h-40, 10, 10);
run("Scale Bar...", "width=" + sb_size + " height=18 font=14 color=White background=None location=[At Selection] bold hide label");
*/