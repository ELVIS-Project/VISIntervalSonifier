// VIS Interval Sonifier (or VIS)
//
//
// Created by R. Michael Winters
// Input Devices and Music Interaction Laboratory
// September 10, 2013
//
// Running SuperCollider 3.6.5 MacOSX 10.7.5
// Double click inside parenthesis to select all
// Shift-Enter to Evaluate
// Command-D for Help


// GUI Object Variables
var loadB, clearB, playB, recB, dataB, mapB,//buttons
knb1, knb2, knb3, //knobs
titleS, loadV, dataV, //views
horzChk, vertChk, diaChk, stackChk, stereoChk,//checkboxes
knb1str, knb2str, knb3str, vertMaxStr, vertMinStr, horzMaxStr, horzMinStr, //statictext
horpos, vertpos, playindx, xMinStr, xMidStr, xMaxStr, horzStr, vertStr,//statictext
dataFont, //formating
w, dataW, mappingW // windows
; //

// Recording variables
var recBuf=Buffer.alloc(s,0), recSynth, selectLen, selectTrue=false, recBufSamp;

// Making your own error dialog
var errorD, errorT, errorS="";

// Data Processing Window
var dataTitStr, defaultChk, histoChk;

// Synth Controls:

// Set synth controls:
var transposition = 72, spread = 1, speed = 0.01, timepos=0,
task, task2, task3, whichdata;

//Backend Variables
var paths=[], filenames=[], data, dataLen, dataDic=Dictionary.new;

// Color Palette:
QtGUI.palette =QPalette.dark;
//QtGUI.palette = QPalette.auto(Color.new255(237,28,36,125),Color.new255(98,137,52,125));

// Basic GUI Set-up: Window,
w = Window.new("2Lup Music Sonifier",
	Rect(Window.availableBounds.width/2-300,
		Window.availableBounds.height/2-250,600,500)).front;
// ...then layout.
w.layout_(GridLayout.rows(
	[nil,nil,nil,[titleS=StaticText(), rows:2, columns:3]],
	[[loadB=Button()],[clearB=Button()],nil,nil,nil,nil],
	[[loadV=ListView(),columns:3,rows:3], nil, nil,
		[mapB=Button()], [dataB=Button()], [recB=Button()]],
	[nil,nil,nil,
		[knb1str=StaticText()],[knb2str=StaticText()],[knb3str=StaticText()]],
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
w.layout.add(vertMaxStr=StaticText(),6,0);

// .. and change the bottom margin to zero for petiosity.
w.layout.margins = [10, 10, 10, 0];

// What happens when you close the GUI window?
w.onClose_({
	task.stop;
	task2.stop;
	dataW.close;
	Interpreter.clear; //potentially unnecessary
});

// Got to make a warning dialog from scratch.
errorD=Window.new("ERROR",Rect(Window.availableBounds.width/2-150,
	Window.availableBounds.height/2-45,300,90)); // centered
errorD.layout_(GridLayout.rows([[errorT=StaticText()]]));
errorD.layout.setAlignment(errorT, \center);
errorT.string_("File Must be a .csv!");
errorT.font = Font("Monaco", 15);

// Align things
//w.layout.setAlignment(titleS, \bottom);
w.layout.setAlignment(knb1str, \bottom);
w.layout.setAlignment(knb2str, \bottom);
w.layout.setAlignment(knb3str, \bottom);
w.layout.setAlignment(vertMaxStr, \left);
w.layout.setAlignment(vertMinStr, \bottomLeft);
w.layout.setAlignment(horzMaxStr, \topLeft);
w.layout.setAlignment(horzMinStr, \left);
w.layout.setAlignment(xMaxStr,\topRight);
w.layout.setAlignment(xMidStr,\top);
w.layout.setAlignment(xMinStr,\topLeft);
w.layout.setAlignment(vertChk,\left);
w.layout.setAlignment(horzChk,\left);
w.layout.setAlignment(mapB,\bottom);
w.layout.setAlignment(dataB,\bottom);
w.layout.setAlignment(recB,\bottom);
w.layout.setAlignment(vertStr,\top);
w.layout.setAlignment(horzStr,\top);

// Format Title
titleS.string_("2Lup Music Sonifier"); titleS.font =  Font("Monaco", 22); titleS.align=\center;

// Set strings
knb1str.string_("Spread");
knb2str.string_("Pitch");
knb3str.string_("Speed");
loadB.states_([["Load"]]);
clearB.states_([["Clear"]]);
playB.states_([["Play"],["Pause"]]);
vertpos.string_("Vert: 0");
horpos.string_("Horz: 0");
playindx.string_("Index: 0");
vertChk.string_("Vertical");
horzChk.string_("Horizontal");
recB.states_([["Record"],["Stop"]]);
mapB.states_([["Sound"]]);
dataB.states_([["Data"]]);

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

// The Data Window:
dataW=Window.new("Data Processing",Rect(dataB.absoluteBounds.rightBottom.x,
	Window.availableBounds.height-
	dataB.absoluteBounds.rightBottom.y,300,90),resizable: false, border: false);
dataW.layout_(GridLayout.rows(
	[[dataTitStr=StaticText(), columns:3]],
	[[defaultChk=CheckBox()],[histoChk=CheckBox()],nil]
));
dataW.front;
dataW.visible_(false);

// Data window strings and alignment.
dataW.layout.setAlignment(dataTitStr, \center);
dataTitStr.string_("Data Processing");
defaultChk.string_("Default");
histoChk.string_("Sorted");
defaultChk.value_(1);

dataB.action_({
	//dataW.front;
	if(dataW.visible,
		{dataW.visible_(false)},
		{dataW.visible_(true)});
});

// What to do when the user presses the histogram CheckBox
histoChk.action_({ var histVert, histHorz, histX=[], histY=[];
	defaultChk.value=0; // Can't have both.
	// If it is already in the dictionary, then that is the data
	if(dataDic.keys.includes(filenames.reverse[loadV.value]++"_histo".asSymbol),
		{data = dataDic.at(filenames.reverse[loadV.value]++"_histo".asSymbol);},
		// If the default has been loaded, but not the histogram itself,
		{if(dataDic.keys.includes(filenames.reverse[loadV.value].asSymbol),
			{data = dataDic.at(filenames.reverse[loadV.value].asSymbol)},
			{data = CSVFileReader.readInterpret(
				paths.reverse[loadV.value].fullPath);
				dataDic.put(filenames.reverse[loadV.value].asSymbol,data);});
		// Do the histogram and put it in the dictionary:
			histVert = data.flop[0].histo(data.flop[0].maxItem
				-data.flop[0].minItem);
			histHorz = data.flop[1].histo(data.flop[1].maxItem
				-data.flop[1].minItem);
			data.flop[0].minItem.for(
				data.flop[0].maxItem,
				{|int, indx| histX=histX++Array.fill(histVert[indx],{int});});
			data.flop[1].minItem.for(
					data.flop[1].maxItem,
					{|int, indx| histY=histY++Array.fill(histHorz[indx],{int});});
				//Now set the data for the View
			data=([histX, histY]).flop;  // To make data global.
			dataDic.put(filenames.reverse[loadV.value]++"_histo".asSymbol,data);
	});
	dataLen=data.size;
	dataV.setData((data.flop[0].normalize(-1,1)
		++data.flop[1].normalize(-1,1)).perfectShuffle ,channels:2);
	vertpos.string_("Vert:"+data.flop[0][dataV.timeCursorPosition].asString);
	horpos.string_("Horz:"+data.flop[1][dataV.timeCursorPosition].asString);
	vertMaxStr.string_(data.flop[0].maxItem.asString);
	vertMinStr.string_(data.flop[0].minItem.asString);
	horzMaxStr.string_(data.flop[1].maxItem.asString);
	horzMinStr.string_(data.flop[1].minItem.asString);
});

defaultChk.action_({
	histoChk.value=0;
	if(dataDic.keys.includes(filenames.reverse[loadV.value].asSymbol),
		//If it is:
		{data = dataDic.at(filenames.reverse[loadV.value].asSymbol);},
		{//If it isn't:
			// Read and interpret the elements as floats.
			data=CSVFileReader.readInterpret(
				paths.reverse[loadV.value].fullPath);
			// Add this data to the dictionary.
			dataDic.put(filenames.reverse[loadV.value].asSymbol,data);
	});
	// In either case, set the data to two channels, and interleave.
 	dataV.setData((data.flop[0].normalize(-1,1)
		++data.flop[1].normalize(-1,1)).perfectShuffle ,channels:2);
 	// Set the strings for more visual feedback.
	dataLen=data.size;
 	vertpos.string_("Vert:"+data.flop[0][dataV.timeCursorPosition].asString);
 	horpos.string_("Horz:"+data.flop[1][dataV.timeCursorPosition].asString);
 	playindx.string_("Index:"+dataV.timeCursorPosition.asString);
	xMinStr.string_(dataV.viewStartFrame.round.asString);
	xMaxStr.string_((dataV.viewStartFrame+dataV.viewFrames).round.asString);
	xMidStr.string_((dataV.viewStartFrame+(dataV.viewFrames/2)).round(0.5).asString);
	vertStr.string_("Vertical");
	horzStr.string_("Horizontal");
	vertMaxStr.string_(data.flop[0].maxItem.asString);
	vertMinStr.string_(data.flop[0].minItem.asString);
	horzMaxStr.string_(data.flop[1].maxItem.asString);
	horzMinStr.string_(data.flop[1].minItem.asString);
});

///////////////////////////////
///   LOADING DATA
//////////////////////////////

// Loading Files
loadB.action_({Dialog.getPaths({|path|
	// For each selected path...
	path.do({|i| var test;
		test = PathName.new(i);
		//test.postln;
		if(test.extension == "csv",
			//... declare it as a path and add it to the list of paths
			{paths=paths++test},
			{errorT.string_("File Must be a .csv!"); errorD.front});
	});
	filenames=paths.collect({|i| i.fileName});
	loadV.items_(filenames.reverse);
	},{"cancelled".postln})
});

// What happens when the user selects different data?
loadV.selectionAction_({|i| var loadthis;
	if(defaultChk.value,
		{defaultChk.value_(0);
			defaultChk.valueAction=1;},
		{histoChk.value_(0);
			histoChk.valueAction=1;});

});

////////////////////////////////////////
///    Buttons, and other GUI materials
////////////////////////////////////////

// What does the clear button do?
clearB.action_({loadV.clear; filenames=[]; paths=[];
	vertMaxStr.string_(""); vertMinStr.string_(""); horzMaxStr.string_("");
	horzMinStr.string_(""); xMinStr.string_(""); xMaxStr.string_("");
	xMidStr.string_(""); vertStr.string_(""); horzStr.string_(""); dataV.data=[0];});

// Define the look and behavior of the SoundFileView
dataV.timeCursorOn = true;
dataV.timeCursorColor = Color.red;
dataV.gridOn = true;
dataV.gridResolution = 0.1;
dataV.action_({	var indx = dataV.timeCursorPosition;
	vertpos.string_("Vert:"+data.flop[0][indx].asString);
	horpos.string_("Horz:"+data.flop[1][indx].asString);
	playindx.string_("Index:"+indx.asString);
	dataV.timeCursorPosition=dataV.selection(0)[0];
	timepos=indx;
});

dataV.mouseMoveAction_({
		xMinStr.string_(dataV.viewStartFrame.round.asString);
		xMaxStr.string_((dataV.viewStartFrame+dataV.viewFrames).round.asString);
xMidStr.string_((dataV.viewStartFrame+(dataV.viewFrames/2)).round(0.5).asString);
});
// For recording purposes
dataV.mouseUpAction_({
	selectLen = dataV.selection(0)[1]; // The length of the selection
	recBufSamp = (selectLen*speed*44100);
	if(recBufSamp>0,{selectTrue=true;},{selectTrue=false;});
});

// The play button
playB.action_({arg butt;
	// If there is no data, it becomes a tester.
	dataW.visible_(false);
	if(paths.isEmpty,{
	Synth.new(\newSynth,
			[\basefreq, 60.midicps, \pos, 1.0.rand2, \dur, 1, \gain, 0.3]);
		},
		{// Assuming it is not empty, then create a task:
			timepos = dataV.selection(0)[0];
			if(butt.value==1,
				{task.play; task2.play;},
				{task.stop; task2.stop;}
			);
	});
});


// The Recording Button
recB.action_({ arg recording;
	if(recB.value==0, // If presently recording
		{
			fork{ //Write, free the buf, pause, set back to "record"
				recSynth.free;
				recBuf.write("~/Desktop/outtest.wav".standardizePath);
				recBuf.free;
				{playB.valueAction_(0);  // pause the play
					playB.enabled_(true);
							recB.value_(0)}.defer; // return to record
			} // end fork
		},{ //Otherwise...
		if(selectTrue, // ... if there is a selection,
			{recBuf = Buffer.alloc(s, recBufSamp, 2); // make the rec. buffer.
			playB.valueAction_(1);//start playing, start recording, wait;
					playB.enabled_(false);
					fork{recSynth =
						Synth.tail(nil,"RecordBuf",["bufnum",recBuf]);
						(selectLen*speed).wait;
						{if(recB.value==1,{ //If the recording isn't stopped...
							recSynth.free; // Stop, write, free buf, pause,
						recBuf.write("~/Desktop/outtest.wav".standardizePath);
							recBuf.free;
							playB.valueAction_(0);
							playB.enabled_(true);
							recB.value_(0)}, //change the record button state
							{nil}) //If it has stopped recording.
						}.defer; // If should be defered to app clock.
					} // end fork
				}, // end "if there is a selection"
		{errorT.string_("Make a selection SVP");
					errorD.front;  // "if there's not a selection"
			recB.value_(0);});
	}); //End "if recording"
});

// Center the knobs strings
knb1str.align = \center;
knb2str.align = \center;
knb3str.align = \center;

// Knobs:
knb1.value_(0.5);
knb2.value_(0.5);
knb3.value_(0.5);

// What do the knobs do?
knb1.action_({var val=(knb1.value*2).round(0.1);
	knb1str.string_("Spread: "+val.asString+"\n(Octaves)");
	spread=val;});
knb2.action_({var val=((knb2.value*48)+48).round;
	knb2str.string_("Pitch: "+val.asString+"\n(MIDI)");
transposition=val;});
knb3.action_({var val=(10.pow((knb3.value*4))).round;
	knb3str.string_("Speed: "+val.asString+"\n(Notes/Sec)");
	speed=1/val;
	dataV.mouseUpAction;}); //Must evaluate if

// Set check boxes:
vertChk.value_(true); // default;
horzChk.value_(false); // default;
vertChk.action_({if(vertChk.value,{horzChk.value_(0);whichdata=0},{vertChk.value_(1)})});
horzChk.action_({if(horzChk.value,{vertChk.value_(0);whichdata=1},{horzChk.value_(1)})});

// Which of the two columns is being evaluated by default?
whichdata=0;

//// SONIFICATION:

// Recording Synth:
SynthDef("RecordBuf", {arg bufnum;
    RecordBuf.ar(In.ar(0,2), bufnum, doneAction:2);
}).send(s);


// What is the fundamental synth?
SynthDef(\newSynth, {
	arg midi=0, spread=1, speed=0.1, transposition=72, iteration=0;
	var sound, env, synth, pitch, phase;
	pitch = ((midi*spread)+transposition).midicps;
	phase = (pitch*speed*iteration).wrap(0,1)*2*pi; // "Always in Phase"
	sound=SinOsc.ar(pitch,phase,0.1)*AmpComp.kr(pitch,40.midicps);
	env=EnvGen.kr(Env.sine(dur:0.05), doneAction:2);
	synth=sound*env;
	OffsetOut.ar([0,1],synth);
}).send(s);

// What is the fundamental synth?
SynthDef(\diatonicSynth, {
	arg midi=0, spread=1, speed=0.1, transposition=72, iteration=0;
	var sound, env, synth, pitch, phase;
	pitch = ((midi*spread)+transposition).midicps;
	phase = (pitch*speed*iteration).wrap(0,1)*2*pi; // "Always in Phase"
	sound=SinOsc.ar(pitch,phase,0.1)*AmpComp.kr(pitch,40.midicps);
	env=EnvGen.kr(Env.sine(dur:0.05), doneAction:2);
	synth=sound*env;
	OffsetOut.ar([0,1],synth);
}).send(s);


// The Sonification task;
task=Task({ var numSamp;
	inf.do({arg i;
		s.sendMsg("/s_new","newSynth",-1,0,0,
			\midi,(data[timepos][whichdata]),
			\speed, speed,
			\spread, spread,
			\transposition, transposition,
			\iteration, timepos);
		if(timepos==(dataLen-1),
			{Routine({task.stop; 0.1.wait;
				task2.stop; {playB.value_(0)}.defer;}).play;},
			{timepos = timepos+1;});
		timepos=timepos+1;
		(speed).wait;
	});
});

// GUI Updating must be on a different clock than the synth
task2 = Task({
	inf.do({arg j;
		{
			dataV.timeCursorPosition = timepos-1;
			vertpos.string_("Vert:"
				+data.flop[0][dataV.timeCursorPosition].asString);
			horpos.string_("Horz:"
				+data.flop[1][dataV.timeCursorPosition].asString);
		    playindx.string_("Index:"+dataV.timeCursorPosition;);
		}.defer(0);
		(1/25).wait;
	});
});

task3=Task({
	inf.do({arg i;
		i.postln;
		//[data[timepos][0], i].postln;
		Synth(\newSynth, [\basefreq, ((data[(timepos)][1]*spread)+transposition).midicps,\pos, -1]);
		Synth(\newSynth, [\basefreq, (((data[(timepos)][0]+data[(timepos)][1])*spread)+transposition).midicps,\pos,1]);
		(data[(timepos)][0]).postln;
		timepos = timepos+1;
		(speed).wait;
})
	});

// Initialization:
paths = PathName.new("/Users/mikewinters/Desktop/2Lup.app/Contents/Default_Data").files;
filenames=paths.collect({|i| i.fileName});
loadV.items_(filenames.reverse);

w.userCanClose_(false);
// Close the Post Window
Document.listener.close;