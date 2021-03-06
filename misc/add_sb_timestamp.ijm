//px_size = 0.5676335358; //in microns - this should already be set, otherwise, uncomment the 'setScale command below'
//px_size = 0.645
//px_size = 0.6450 * 1280 / 1860; // (to account for image rescaling)
//px_size = 0.645  //(to account for image rescaling)
//px_size = 0.275 // spinning2 40x binning1
time_int = 15; //in minutes
start_time = 0; //in minutes
sb_size = 100; //in microns
w = getWidth();
h = getHeight();

//adds time stamp
setForegroundColor(255, 255, 255);
//run("Time Stamper", "starting=0 interval=" + time_int + " x=-35 y="+(h-5)+" font=100 '00 decimal=0 anti-aliased or=sec");
run("Time Stamper", "starting="+start_time+" interval=" + time_int + " x=-60 y=120 font=100 '00 decimal=0 anti-aliased or=sec");
//saveAs("tiff", dir + basename +  "_comb.tif");


//adds scale bar
//run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
makeRectangle(w-188, h-100, 10, 10);
run("Scale Bar...", "width=" + sb_size + " height=16 font=14 color=White background=None location=[At Selection] bold hide label");
