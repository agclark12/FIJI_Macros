//px_size = 0.5676335358; //in microns - this should already be set, otherwise, uncomment the 'setScale command below'
//px_size = 0.645
//px_size = 0.6450 * 1280 / 1860; // (to account for image rescaling)
px_size = 0.275  //(to account for image rescaling)
time_int = 3; //in minutes
start_time = 5; //in minutes
sb_size = 50; //in microns
w = getWidth();
h = getHeight();

//adds time stamp
setForegroundColor(255, 255, 255);
//run("Time Stamper", "starting=0 interval=" + time_int + " x=-35 y="+(h-5)+" font=100 '00 decimal=0 anti-aliased or=sec");
run("Time Stamper", "starting="+start_time+" interval=" + time_int + " x=20 y=250 font=150 '00 decimal=0 anti-aliased or=sec");
//saveAs("tiff", dir + basename +  "_comb.tif");


//adds scale bar
//run("Set Scale...", "distance=1 known=" + px_size +  "  unit=um");
//makeRectangle(w-80, h-50, 10, 10);
//run("Scale Bar...", "width=" + sb_size + " height=18 font=14 color=White background=None location=[At Selection] bold hide label");
