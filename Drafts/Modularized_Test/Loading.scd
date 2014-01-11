
// Loading Files
~paths=[]; ~filenames=[];
~loadB.action_({Dialog.getPaths({|path|
	// For each selected path...
	path.size.do({|i| var test;
		// If the path ends with .csv, then take it, otherwise send error message.
		test = PathName.new(path[i]);
		if(test.extension == "csv",
			//... declate it as a path and add it to the list of ~paths
			{~paths=~paths++test},{~errorD.front});
		//... declate it as a path and add it to the list of ~paths
	});
	// Add the ~filenames to the list of ~filenames...
	~filenames=~paths.collect({|i| i.fileName});
	// ... and set those names as the list.
	~loadV.items_(~filenames.reverse);
	},
	{"cancelled".postln})
});

// // What happens when the user selects different ~data?
~loadV.selectionAction_({var loadthis;
 	//Get full path name.
 	loadthis=~paths.reverse[~loadV.value].fullPath;
 	// Read and interpret the elements as floats.
 	~data=CSVFileReader.readInterpret(loadthis).postln;
 	// Set the ~data to two channels (vertical, horizontal).  You must interleave.
 	~dataV.setData((~data.flop[0].normalize(-1,1)++~data.flop[1].normalize(-1,1)).perfectShuffle ,channels:2);
 	// Set the strings for more visual feedback.
 	~vertpos.string_("Vert:"+~data.flop[0][~dataV.timeCursorPosition].asString);
 	~horpos.string_("Horz:"+~data.flop[1][~dataV.timeCursorPosition].asString);
 	~playindx.string_("Index:"+~dataV.timeCursorPosition.asString);
	~xMinStr.string_(~dataV.viewStartFrame.round.asString);
	~xMaxStr.string_((~dataV.viewStartFrame+~dataV.viewFrames).round.asString);
	~xMidStr.string_((~dataV.viewStartFrame+(~dataV.viewFrames/2)).round(0.5).asString);
	~vertStr.string_("Vertical");
	~horzStr.string_("Horizontal");
	~vertMaxStr.string_(~data.flop[0].maxItem.asString);
	~vertMinStr.string_(~data.flop[0].minItem.asString);
	~horzMaxStr.string_(~data.flop[1].maxItem.asString);
	~horzMinStr.string_(~data.flop[1].minItem.asString);

});