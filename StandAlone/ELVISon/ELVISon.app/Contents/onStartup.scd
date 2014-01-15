// VIS Interval Sonifier (or VIS)
//
// Created by R. Michael Winters
// Electronic Locator of Vertical Interval Successions
// Input Devices and Music Interaction Laboratory
// September 10, 2013
//
// Running SuperCollider 3.6.5 MacOSX 10.7.5
// Double click inside parenthesis to select all
// Shift-Enter to Evaluate
// Command-D for Help

///////////////////////////////
///   INITIAL SETUP
///////////////////////////////

// GUI Object Variables
var loadB, clearB, playB, recB, //dataB, mapB,//buttons
knb1, knb2, knb3, //
dataM, mapM, //pop-up menus
loadV, dataV, //views
horzChk, vertChk, diaChk, stackChk, stereoChk,//checkboxes
subTitleS, titleS, dataStr, mapStr, //statictext
knb1Str, knb2Str, knb3Str, vertMaxStr, vertMinStr, horzMaxStr, horzMinStr, //statictext
horpos, vertpos, playindx, xMinStr, xMidStr, xMaxStr, horzStr, vertStr,//statictext
dataFont, //formating
w, dataW, mappingW // windows
; //

// Functions
var loadDefault, doSorted, doHistogram, plotRefresh, guiRefresh, deriveSelectionLength;

// Recording variables
var recBuf=Buffer.alloc(s,0), recSynth, selectLen, selectTrue=false, recBufSamp;

// Error dialog
var errorD, errorT, errorS="";

// Synth Controls:
var transposition = 72, spread = 1, speed = 0.01, dur=0.25, timePos=0,
task, pitchIntTask, intIntTask, horzVertTask, whichdata;

// Handling Data
var paths=[], filenames=[], data, dataLen, sonData, dataDic=Dictionary.new;

// Diatonic Int. -> Int. sonification
var rising, descending, diatonic, octave;

// GUI Color Palette:
QtGUI.palette =QPalette.dark;

// Basic GUI Set-up: Window,
w = Window.new("elvisproject.ca",
	Rect(Window.availableBounds.width/2-300,
		Window.availableBounds.height/2-250,600,500)).front;
// ...then layout.
w.layout_(GridLayout.rows(
	[[titleS=StaticText(), rows:2, columns:6],nil,nil,nil,nil,nil],
	[nil,nil,nil,nil,nil,nil],
	[[loadB=Button()],[clearB=Button()],nil,[subTitleS=StaticText(), rows:1, columns:3]],
	[[loadV=ListView(),columns:3,rows:3], nil, nil,
		[mapM=PopUpMenu()], [dataM=PopUpMenu()], [recB=Button()]],
//	[nil,nil,nil, [mapM=PopUpMenu()], [dataM=PopUpMenu()], [recB=Button()]],
	[nil,nil,nil, [knb1Str=StaticText()],[knb2Str=StaticText()],[knb3Str=StaticText()]],
	[nil,nil,nil,[knb1=Knob()],[knb2=Knob()],[knb3=Knob()]],
	[[playB=Button()],[vertChk = CheckBox()],[horzChk = CheckBox()],
		[playindx=StaticText()],[vertpos=StaticText()],[horpos=StaticText()]],
	[[dataV=SoundFileView(), columns:6, rows:6], nil, [vertStr=StaticText(), columns:2]],
	[nil,nil,nil,nil,nil,nil],
	[vertMinStr = StaticText()],
	[[horzMaxStr = StaticText()], nil, [horzStr=StaticText(), columns:2]],
	[nil,nil,nil,nil,nil,nil],
	[horzMinStr = StaticText()],
	[[xMinStr=StaticText()],nil,[xMidStr=StaticText(),columns:2],nil,nil,[xMaxStr=StaticText()]]
));

// Must put stuff on top of other stuff..
w.layout.add(vertMaxStr=StaticText(),7,0);

// .. and change the bottom margin to zero for petitieosity.
w.layout.margins = [10, 10, 10, 0];

// Align things
w.layout.setAlignment(knb1Str, \bottom);
w.layout.setAlignment(knb2Str, \bottom);
w.layout.setAlignment(knb3Str, \bottom);
w.layout.setAlignment(vertMaxStr, \left);
w.layout.setAlignment(vertMinStr, \bottomLeft);
w.layout.setAlignment(horzMaxStr, \topLeft);
w.layout.setAlignment(horzMinStr, \left);
w.layout.setAlignment(xMaxStr,\topRight);
w.layout.setAlignment(xMidStr,\top);
w.layout.setAlignment(xMinStr,\topLeft);
w.layout.setAlignment(vertChk,\left);
w.layout.setAlignment(horzChk,\left);
w.layout.setAlignment(vertStr,\top);
w.layout.setAlignment(horzStr,\top);
subTitleS.align=\center;
titleS.align=\center;
knb1Str.align = \center;
knb2Str.align = \center;
knb3Str.align = \center;

// Format Title
titleS.string_("ELVIS Interval Sonifier"); titleS.font =  Font("Book Antiqua", 28);
subTitleS.string_("Sound & Data Controls"); subTitleS.font =  Font("Helvetica", 16);

// Set strings
knb1Str.string_("Spread");
knb2Str.string_("Pitch");
knb3Str.string_("Speed");
vertpos.string_("Vert: 0");
horpos.string_("Horz: 0");
playindx.string_("Interval: 0");
vertChk.string_("Vertical");
horzChk.string_("Horizontal");
vertStr.string_("Vert. Intervals");
horzStr.string_("Horz. Intervals");

// Set items and states (menus and buttons)
loadB.states_([["Load"]]);
clearB.states_([["Clear"]]);
playB.states_([["Play"],["Pause"]]);
recB.states_([["Record"],["Stop"]]);
mapM.items_(["Int. -> Pitch","Int. -> Int."]);
dataM.items_(["Over Time","Histogram","Sorted"]);

// What font to use in the data plot (dataV)?
dataFont = Font("Helvetica",10);
vertMaxStr.font_(dataFont);
vertMinStr.font_(dataFont);
horzMaxStr.font_(dataFont);
horzMinStr.font_(dataFont);
xMinStr.font_(dataFont);
xMidStr.font_(dataFont);
xMaxStr.font_(dataFont);
vertStr.font_(dataFont);
horzStr.font_(dataFont);

// Knobs:
knb1.value_(0.5);
knb2.value_(0.5);
knb3.value_(0.5);

//Checkboxes:
vertChk.value_(true);
horzChk.value_(false);

// Only one item in ListView can be selected
loadV.selectionMode=\single;

///////////////////////////////
///   LOADING DATA
//////////////////////////////

// What happens when you press the Load Button?
loadB.action_({Dialog.getPaths({|path|
	// For each selected path...
	path.do({|i| var test;
		test = PathName.new(i);
		if(test.extension == "csv",
			//... declare it as a path and add it to the list of paths
			{paths=paths++test},
			{errorT.string_("File Must be a .csv!"); errorD.front});
	});
	filenames=paths.collect({|i| i.fileName});
	loadV.items_(filenames.reverse);
	},{"cancelled".postln})
});

// ... after loading new data or selecting different data in the list:
loadV.selectionAction_({
	dataM.valueAction=dataM.value;
	mapM.valueAction=mapM.value;
});
// When you select new data, make sure you pause the player.
loadV.mouseDownAction_({playB.valueAction_(0)});

// What happens when you load data?
loadDefault={
	data=CSVFileReader.readInterpret(paths.reverse[loadV.value].fullPath);
	data=data.flop; //data format is 2 rows => [[0,2,4,5...],[0,2,3,4...]]
	// Add this data to the dictionary.
	dataDic.put(filenames.reverse[loadV.value].asSymbol,data);
};

// What happens to the plot when you load data?
plotRefresh={
	dataV.setData((data[0].normalize(-1,1)
		++data[1].normalize(-1,1)).perfectShuffle ,channels:2);
	// Set all of the necessary strings:
	dataLen=data[0].size;
 	vertpos.string_("Vert:"+data[0][dataV.timeCursorPosition].asString);
 	horpos.string_("Horz:"+data[1][dataV.timeCursorPosition].asString);
	playindx.string_("Interval:"+(dataV.timeCursorPosition+1).asString);
	xMinStr.string_((dataV.viewStartFrame.round+1).asString);
	xMaxStr.string_((dataV.viewStartFrame+dataV.viewFrames).round.asString);
	xMidStr.string_(
		(dataV.viewStartFrame+((dataV.viewFrames+1)/2)).round(0.5).asString);
	vertMaxStr.string_(data[0].maxItem.asString);
	vertMinStr.string_(data[0].minItem.asString);
	horzMaxStr.string_(data[1].maxItem.asString);
	horzMinStr.string_(data[1].minItem.asString);
};

//////////////////////////////
///   DATA PROCESSING
//////////////////////////////

// Do a "sorted" (lowest -> highest) histogram
doSorted={
	var histVert, histHorz, histX=[], histY=[];// data;
	// Do the histogram and put it in the dictionary:
	histVert = data[0].histo(data[0].maxItem-data[0].minItem+1);
	histHorz = data[1].histo(data[1].maxItem-data[1].minItem+1);
	data[0].minItem.for(
		data[0].maxItem,
			{|int, indx| histX=histX++Array.fill(histVert[indx],{int});});
	data[1].minItem.for(
		data[1].maxItem,
			{|int, indx| histY=histY++Array.fill(histHorz[indx],{int});});
			//Now set the data for the View
	data=([histX, histY]);  // To make data global.
	dataDic.put(filenames.reverse[loadV.value]++"_sorted".asSymbol,data);
};

// Do a normal histogram (most occurences -> least occurrences)
doHistogram={
	var histVert, histHorz, histX=[], histY=[];
	histVert = data[0].histo(data[0].maxItem-data[0].minItem+1);
	histHorz = data[1].histo(data[1].maxItem-data[1].minItem+1);
	a=(data[0].minItem..data[0].maxItem);
	a.size.do({
		histX=histX++Array.fill(histVert.maxItem, a[histVert.maxIndex]);
		histVert.put(histVert.maxIndex,-1);
	});
	a=(data[1].minItem..data[1].maxItem);
	a.size.do({
		histY=histY++Array.fill(histHorz.maxItem, a[histHorz.maxIndex]);
		histHorz.put(histHorz.maxIndex,-1);
	});
	data=([histX, histY]);  // To make data global.
	dataDic.put(filenames.reverse[loadV.value]++"_histo".asSymbol,data);
};

//dataM.mouseDownAction_({playB.valueAction_(0);});
//dataM.mouseUpAction_({loadV.selectionAction});
//dataM.mouseUpAction_({playB.valueAction_(0);});
// What happens when each of the data menu items are selected?
dataM.action_({
	task.reset;
	if(dataM.item=="Over Time",{
		if(dataDic.keys.includes(filenames.reverse[loadV.value].asSymbol),{
			data = dataDic.at(filenames.reverse[loadV.value].asSymbol);
			},{
			loadDefault.value;
		});
	});
	if(dataM.item=="Sorted",{
		if(dataDic.keys.includes(
			filenames.reverse[loadV.value]++"_sorted".asSymbol),{
			data = dataDic.at(filenames.reverse[loadV.value]++"_sorted".asSymbol);
			},{// If the default has been loaded, but not the sorted histo itself,
			if(dataDic.keys.includes(filenames.reverse[loadV.value].asSymbol),{
				data = dataDic.at(filenames.reverse[loadV.value].asSymbol)
				},{
				loadDefault.value;
			});
			doSorted.value;
		});
	});
	if(dataM.item=="Histogram",{
		if(dataDic.keys.includes(
			filenames.reverse[loadV.value]++"_histo".asSymbol),{
			data = dataDic.at(filenames.reverse[loadV.value]++"_histo".asSymbol);
			},{// If the default has been loaded, but not the histogram itself,
			if(dataDic.keys.includes(filenames.reverse[loadV.value].asSymbol),{
				data = dataDic.at(filenames.reverse[loadV.value].asSymbol)
				},{
				loadDefault.value;
			});
			doHistogram.value;
		});
	});
	plotRefresh.value;
});

//Platform.resourceDir.isString
paths = PathName.new(Platform.resourceDir++"/Default_Data").files;
filenames=paths.collect({|i| i.fileName});
loadV.items_(filenames.reverse);
mapM.action(0);
dataM.action(0);

////////////////////////////////////////
///   GUI INTERACTION
////////////////////////////////////////

// Got to make a warning dialog from scratch.
errorD=Window.new("ERROR",Rect(Window.availableBounds.width/2-150,
	Window.availableBounds.height/2-45,300,90)); // centered
errorD.layout_(GridLayout.rows([[errorT=StaticText()]]));
errorD.layout.setAlignment(errorT, \center);
errorT.string_("File Must be a .csv!");
errorT.font = Font("Monaco", 15);

// What happens when you close the GUI window?
w.onClose_({
	task.stop;
	guiRefresh.stop;
	Interpreter.clear; //potentially unnecessary
});

// What does the clear button do?
clearB.action_({loadV.clear; filenames=[]; paths=[];
	vertMaxStr.string_(""); vertMinStr.string_(""); horzMaxStr.string_("");
	horzMinStr.string_(""); xMinStr.string_(""); xMaxStr.string_("");
	xMidStr.string_("");  dataV.data=[0];});

// Define the look and behavior of the SoundFileView
dataV.timeCursorOn = true;
dataV.timeCursorColor = Color.red;
dataV.gridOn = true;
dataV.gridResolution = 0.1;

//What happens when the user zooms in on the data view?
dataV.mouseMoveAction_({
	xMinStr.string_(dataV.viewStartFrame.round.asString);
	xMaxStr.string_((dataV.viewStartFrame+dataV.viewFrames).round.asString);
	xMidStr.string_(
		(dataV.viewStartFrame+((dataV.viewFrames+1)/2)).round(0.5).asString);
});

// What do the knobs do?
knb1.action_({var val=(knb1.value*2).round(0.1);
	knb1Str.string_("Spread: "+val.asString+"\n(Octaves)");
	spread=val;});
knb2.action_({var val=((knb2.value*48)+48).round;
	knb2Str.string_("Pitch: "+val.asString+"\n(MIDI)");
transposition=val;});
knb3.action_({var val=(10.pow((knb3.value*4))).round;
	knb3Str.string_("Speed: "+val.asString+"\n(Int./Sec)");
	speed=1/val;
	dur=1/(2*val.clip2(10));
	dataV.mouseUpAction;}); //Must evaluate if

// Check-box actions:
vertChk.action_({if(vertChk.value,{horzChk.value_(0);whichdata=0},{vertChk.value_(1)})});
horzChk.action_({if(horzChk.value,{vertChk.value_(0);whichdata=1},{horzChk.value_(1)})});

// Which of the two columns is being evaluated by default?
whichdata=0;

dataV.action_({	var indx = dataV.timeCursorPosition;
	vertpos.string_("Vert:"+data[0][indx].asString);
	horpos.string_("Horz:"+data[1][indx].asString);
	playindx.string_("Interval:"+(indx+1).asString);
	dataV.timeCursorPosition=dataV.selection(0)[0];
	timePos=indx;
	deriveSelectionLength.value;
});

deriveSelectionLength={
	timePos = dataV.timeCursorPosition;  // timePos is current cursor position;
	if(dataV.selection(0)[1]==0,{ // if there is no selection then
		selectLen=dataLen-dataV.timeCursorPosition;
		},{
			selectLen=dataV.selection(0)[1]+1;
			timePos=dataV.selection(0)[0];
	});
};

////////////////////////////////////////
///    RECORDING AND PLAYING
////////////////////////////////////////

// Recording requires the user to make a non-zero length selection of the data
dataV.mouseUpAction_({
	selectLen = dataV.selection(0)[1]; // The length of the selection
	recBufSamp = (selectLen*speed*44100);
	if(recBufSamp>0,{selectTrue=true;},{selectTrue=false;});
	playB.doAction;
});

dataV.mouseDownAction_({
	task.reset; guiRefresh.stop;
});

// Recording Synth:
SynthDef("RecordBuf", {arg bufnum;
    RecordBuf.ar(In.ar(0,2), bufnum, doneAction:2);
}).send(s);

// The Recording Button
recB.action_({ arg recording;
	if(recB.value==0,{ // If presently recording
		fork{ //Write, free the buf, pause, set back to "record"
			recSynth.free;
			recBuf.write(Platform.userHomeDir++"/Desktop/outtest.wav".standardizePath);
			recBuf.free;
			{playB.valueAction_(0);  // pause the play
			playB.enabled_(true);
			recB.value_(0)}.defer; // return to record
		} // end fork
		},{ //Otherwise...
		if(selectTrue,{
				recBuf = Buffer.alloc(s, recBufSamp, 2); // make the rec. buffer.
				recSynth =
					Synth.tail(nil,"RecordBuf",["bufnum",recBuf]);
				playB.valueAction_(1);//start playing, start recording, wait;
				playB.enabled_(false);
				fork{
					(selectLen*speed).wait;
					{if(recB.value==1,{ //If the recording isn't stopped...
						recSynth.free; // Stop, write, free buf, pause,
						recBuf.write("~/Desktop/outtest.wav".standardizePath);
						recBuf.free;
						playB.valueAction_(0);
						playB.enabled_(true);
						recB.value_(0)
						}); //If it has stopped recording.
					}.defer; // If should be defered to app clock.
				} // end fork
			},{
					errorT.string_("Make a selection SVP");
					errorD.front;  // "if there's not a selection"
					recB.value_(0);
			});
	});
});

// The play button
playB.action_({arg butt;
	deriveSelectionLength.value;
	if(butt.value==1,{
		task.play; guiRefresh.play;
		},{
			task.stop; guiRefresh.stop;
			task.reset;
			if(selectLen==1 && dataV.selection(0)[1]==0,{ // if we are at the end...
				dataV.timeCursorPosition=0;selectLen=dataLen;
			});
	});
});

////////////////////////////////////////
///    MAPPING
////////////////////////////////////////

// Set-up for Int. -> Int. mapping
descending=[0,0,-1,-1,-3,-3,-5,-5,-7,-7,-8,-8,-10,-10];
rising=[0,2,2,4,4,5,5,7,7,9,9,11,11,12];
descending=descending++(descending-12)++(descending-24)++(descending-36);
rising=rising++(rising+12)++(rising+24)++(rising+36);
diatonic=[descending,rising].flop;
//diatonic[input-1]

mapM.action_({
	playB.valueAction_(0);
	if(mapM.item=="Int. -> Pitch",{
		sonData=data.flop;
		task=pitchIntTask;
	});
	if(mapM.item=="Int. -> Int.",{
		sonData=data.abs.flop;
		knb1.valueAction=0.5;
		task=intIntTask;
	});
});


////////////////////////////////////////
///    SOUND GENERATION
////////////////////////////////////////

// What is the fundamental synth?
SynthDef(\newSynth, {
	arg midi=0, spread=1, speed=0.1, transposition=72, iteration=0, dur=0.25;
	var sound, env, synth, pitch, phase;
	pitch = ((midi*spread)+transposition).midicps;
	//sound=SinOsc.ar(pitch,mul:0.1)*AmpComp.kr(pitch,40.midicps);
	phase = (pitch*speed*iteration).wrap(0,1)*2*pi; // "Always in Phase"
	sound=SinOsc.ar(pitch,phase,0.05)*AmpComp.kr(pitch,40.midicps);
	env=EnvGen.kr(Env.sine(dur: dur), doneAction:2);
	synth=sound*env;
	OffsetOut.ar([0,1],synth);
}).send(s);

// The Int.-> Pitch sonification task;
pitchIntTask=Task({
	selectLen.do({arg i;
		s.sendMsg("/s_new","newSynth",-1,0,0,
			\midi,(sonData[timePos][whichdata]),
			\dur, dur,
			\speed, speed,
			\spread, spread,
			\transposition, transposition,
			\iteration, timePos);
		timePos=timePos+1;
		(speed).wait;
	});
});

// The Int.-> Pitch sonification task;
// Bottom, then Top
intIntTask=Task({
	selectLen.do({arg i; var pos, elem;
		timePos=timePos+1; // Don't think this belongs here in the task...
		pos=data[whichdata][timePos-1].isPositive;
		elem=(sonData[timePos-1][whichdata])-1;
		// Lower Interval
		s.sendMsg("/s_new","newSynth",-1,0,0,
			\midi,diatonic[elem][pos.not.asInteger],
			\speed, speed,
			\spread, spread,
			\transposition, transposition,
			\iteration, timePos);
		(speed*0.25).wait;
		// Upper Interval
		s.sendMsg("/s_new","newSynth",-1,0,0,
			\midi,diatonic[elem][pos.asInteger],
			\speed, speed,
			\spread, spread,
			\transposition, transposition,
			\iteration, timePos);
		(speed*0.75).wait;
	});
});


// GUI Updating must be on a different clock than the synth
guiRefresh = Task({
	inf.do({arg j;
			{dataV.timeCursorPosition = timePos-1;
			vertpos.string_("Vert:"
				+data[0][dataV.timeCursorPosition].asString);
			horpos.string_("Horz:"
				+data[1][dataV.timeCursorPosition].asString);
			playindx.string_("Interval:"+(dataV.timeCursorPosition+1).asString);}.defer(0);
		(1/25).wait;
	});
});

// Start your engines!
s.boot;