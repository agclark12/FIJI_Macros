macro 'Mask to Selection' {
  requires("1.33o");
  //debug=false;//true;//

  if (isOpen("ROI Manager")) {
    selectWindow("ROI Manager");
    run("Close");
  }
  setBatchMode(!debug);
  maskImageID=getImageID();

  run("Select None");
  tempname=getTitle()+"-mask2roiTemp";
  unThresholded=(indexOf(getInfo(), "No Threshold")>=0); //upper and lower might be set even without thresholding
  getThreshold(lower, upper);
  run("Duplicate...", "title="+tempname);
  workImageID=getImageID();
  if(!unThresholded) {			//thresholded image to mask
    setThreshold(lower, upper);
    run("Threshold", "thresholded remaining black");
  }

  found=createSelection(workImageID,debug);
  selectImage(maskImageID);
  if (found) run("Restore Selection"); 	//apply selection to original image

  setBatchMode(false);
  if (isOpen("ROI Manager")) {
    selectWindow("ROI Manager");
    run("Close");
  }
  showStatus("Mask to Selection - Done");

} //end of macro 'Mask to Selection'