//this macro goes through a directory and puts together
//hyperstacks (z/t) for a given channel and different stage
//positions and puts these together in a tile

setBatchMode(true);

ch_keyword = "org_mTmG_L-WRN_vs_ENR_1_s8_t";
//no_timepoints = 118;
//img_extension = "STK";

//data_dir = "/Users/aclark/Documents/Work/VignjevicLab/Data/raw_microscope_data/2014-10-09/shrunken";
data_dir = getDirectory("Which Dir?");

//loops through data directory
dir_list = getFileList(data_dir);

num_list = newArray();
for (i=0; i<dir_list.length; i++) {
	filename = dir_list[i];
	if (matches(filename,".*" + ch_keyword + ".*")) {
		//gets time
		start = lastIndexOf(filename,"_t");
		end = lastIndexOf(filename,".");
		num = parseInt(substring(filename,start+2,end));
		//print(num);
		num_list = Array.concat(num_list,num);
	}
}


num_list = Array.sort(num_list);

Array.getStatistics(num_list, min, max, mean, stdDev);
print(min);
print(max);



//finds missing number
for (i=min; i<max+1; i++) {
	print(i);
	print(num_list[i-1]);
	if (i==num_list[i-1]) {
		print('ok');
	} else {
		print('missing frame ' + i);
		stop
	}
	//toggle = 'on';
	//for (j=0; j<lengthOf(num_list); j++) {
		//print(j);
		//print(num_list[j]);
	//	if (i==num_list[j]) {
	//		toggle = 'off' ;
	//	}
	//}
	//if (toggle=='on') {
	//	print("t",i," MISSING!");
	//}
}



print("Done!");

setBatchMode(false);