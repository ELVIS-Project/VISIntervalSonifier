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

s.boot;

(
// GUI Object Variables
var loadB, clearB, titleS, loadV, chk1, chk2, chk3, chk1str ="", chk2str ="",
chk3str="", knb1, knb2, knb3, knb1str="", knb2str="", knb3str ="", datastr="",
horpos, vertpos, playindx, playB, sizestr, dataV;

// Making your own error dialog
var errorD, errorT, errorS="";

// Synth Controls:
var transposition, spread, speed, len, task, task2, timepos, whichdata;

//Backend Variables
var paths=[], filenames=[], data;

// Color Palette:
//QtGUI.palette= QPalette.auto(Color.cyan(1.4), Color.cyan(1.8));
	QtGUI.palette =QPalette.dark;

// Basic GUI Set-up
w = Window.new("VIS Interval Sonifier", Rect(Window.availableBounds.width/2-300,Window.availableBounds.height/2-250,600,500)).front;
w.layout_(GridLayout.rows(
	[nil,nil,nil,[titleS=StaticText(), rows:2, columns:3]],
	[[loadB=Button()],[clearB=Button()],nil,nil,nil,nil],
	[[loadV=ListView(),columns:3,rows:4],nil,nil,[chk1str=StaticText()],[chk2str=StaticText()],[chk3str=StaticText()]],
	[nil,nil,nil,[chk1=CheckBox()],[chk2=CheckBox()],[chk3=CheckBox()]],
	[nil,nil,nil,[knb1str=StaticText()],[knb2str=StaticText()],[knb3str=StaticText()]],
	[nil,nil,nil,[knb1=Knob()],[knb2=Knob()],[knb3=Knob()]],
	[[playB=Button()],[sizestr=StaticText()],nil,[playindx=StaticText()],[vertpos=StaticText()],horpos=StaticText()],
	[[dataV=SoundFileView(),columns:6]]
));

// On close do what?
w.onClose_({task.stop;task2.stop;});

// Got to make a warning dialog from scratch.
errorD=Window.new("ERROR",Rect(Window.availableBounds.width/2-150, Window.availableBounds.height/2-45,300,90));
errorD.layout_(GridLayout.rows([[errorT=StaticText()]]));
errorD.layout.setAlignment(errorT, \center);
errorT.string_("File Must be a .csv!");
errorT.font = Font("Monaco", 15);


// Center things
w.layout.setAlignment(titleS, \center);
w.layout.setAlignment(chk1, \center);
w.layout.setAlignment(chk2, \center);
w.layout.setAlignment(chk3, \center);
w.layout.setAlignment(chk1str, \bottom);
w.layout.setAlignment(chk2str, \bottom);
w.layout.setAlignment(chk3str, \bottom);
w.layout.setAlignment(knb1str, \bottom);
w.layout.setAlignment(knb2str, \bottom);
w.layout.setAlignment(knb3str, \bottom);


// Set Text Strings
titleS.string_("VIS Interval Sonifer");
knb1str.string_("Spread");
knb2str.string_("Pitch");
knb3str.string_("Speed");
chk1str.string_("Vertical");
chk2str.string_("Horizontal");
chk3str.string_("Normalize");
loadB.states_([["Load"]]);
clearB.states_([["Clear"]]);
playB.states_([["Play"],["Pause"]]);
vertpos.string_("Vert: 0");
horpos.string_("Horz: 0");
playindx.string_("Index: 0");
sizestr.string_("Size");

// Format the Title
titleS.font =  Font("Monaco", 25);

// Loading Files
loadB.action_({Dialog.getPaths({|path|
	// For each selected path...
	path.size.do({|i| var test;
		// If the path ends with .csv, then take it, otherwise send error message.
		test = PathName.new(path[i]);
		if(test.extension == "csv",
			//... declate it as a path and add it to the list of paths
			{paths=paths++test},{errorD.front});
		//... declate it as a path and add it to the list of paths
	});
	// Add the filenames to the list of filenames...
	filenames=paths.collect({|i| i.fileName});
	// ... and set those names as the list.
	loadV.items_(filenames.reverse);
/*	loadV.items[loadV.value].postln;
	loadV.valueAction_(loadV.value.postln);
	filenames.reverse[loadV.value].postln;*/
	},
	{"cancelled".postln})
});

// What does the clear button do?
clearB.action_({loadV.clear; filenames=[]; paths=[]});

// // What happens when the user selects different data?
 loadV.selectionAction_({var loadthis;
 	//Get full path name.
 	loadthis=paths.reverse[loadV.value].fullPath;
 	// Read and interpret the elements as floats.
 	data=CSVFileReader.readInterpret(loadthis).postln;
 	// Set the data to two channels (vertical, horizontal).  You must interleave.
 	dataV.setData((data.flop[0].normalize(-1,1)++data.flop[1].normalize(-1,1)).perfectShuffle ,channels:2);
 	// Set the strings for more visual feedback.
 	vertpos.string_("Vert:"+data.flop[0][dataV.timeCursorPosition].asString);
 	horpos.string_("Horz:"+data.flop[1][dataV.timeCursorPosition].asString);
 	playindx.string_("Index:"+dataV.timeCursorPosition.asString);
 	sizestr.string_("Size: "+data.flop[0].size.asString);
 });


// What is the fundamental synth?
SynthDef(\newSynth, {
	arg basefreq=200, pos=0.5, gain=0.5, dur=0.05;
	var sound, env, synth, stereo;
	sound=gain*SinOsc.ar(basefreq, 0, 1)*AmpComp.kr(basefreq,40.midicps);
	env=EnvGen.kr(Env.sine(dur,1), timeScale:1, doneAction:2);
	synth=sound*env;
	stereo=Pan2.ar(synth, pos, gain);
	OffsetOut.ar(0,stereo);
}).send(s);

// Define the look of the SoundFileView
dataV.timeCursorOn = true;
dataV.timeCursorColor = Color.red;
dataV.gridOn = true;
dataV.gridResolution = 0.05;
dataV.action_({	var indx = dataV.timeCursorPosition;
	vertpos.string_("Vert:"+data.flop[0][indx].asString);
	horpos.string_("Horz:"+data.flop[1][indx].asString);
	playindx.string_("Index:"+indx.asString);
	dataV.timeCursorPosition=dataV.selection(0)[0];
	timepos=indx;});

// Set synth controls:
transposition=72;
spread=1;
speed=0.01;
timepos=0;

// The Sonification task;
task=Task({
			inf.do({arg i;
				//[data[timepos][0], i].postln;
		        Synth.new(\newSynth, [\basefreq,((data[(timepos)][whichdata]*spread)+transposition).midicps]);
		        timepos = timepos+1;
		        //timepos.postln;
				(speed).wait;
})
	});

// I couldn't get this to schedule right, so I'm doing it here.
task2 = Task({
	inf.do({arg j;
			{dataV.timeCursorPosition = timepos;
			vertpos.string_("Vert:"+data.flop[0][dataV.timeCursorPosition].asString);
			horpos.string_("Horz:"+data.flop[1][dataV.timeCursorPosition].asString);
		    playindx.string_("Index:"+dataV.timeCursorPosition;);}.defer(0);
		(1/25).wait;
	});
});

// The play button
playB.action_({arg butt;
	// If there is no data, it becomes a tester.
	if(paths.isEmpty,{
	Synth.new(\newSynth, [\basefreq, 60.midicps, \pos, 1.0.rand2, \dur, 1, \gain, 0.3])},
		{// Assuming it is not empty, then create a task:
			timepos = dataV.selection(0)[0];
			//len = if(dataV.selection(0)[1]==0,{data.flop[0].size-timepos},{dataV.selection(0)[1]});
			if(butt.value==1,{task.play; task2.play;},{task.stop; task2.stop;});
	})
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
knb3.action_({var val=(10.pow((knb3.value*2+1))).round;
	knb3str.string_("Speed: "+val.asString+"\n(Notes/Sec)");
	speed=1/val});

// Set check boxes:
chk1.value_(true); // default;
chk2.value_(false); // default;
chk1.action_({if(chk1.value,{chk2.value_(0);whichdata=0},{chk1.value_(1)})});
chk2.action_({if(chk2.value,{chk1.value_(0);whichdata=1},{chk2.value_(1)})});

// Which of the two columns is being evaluated by default?
whichdata=0;

)




//Trash:
