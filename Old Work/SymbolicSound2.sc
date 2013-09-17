// Sonification for Symbolic Music Analysis
// R. Michael Winters
// Start Date: 27 March 2012

// Data is generated using Music21 (http://mit.edu/music21/)
// Exported as CSV file
// Sonified in SuperCollider 3.5

// Press Cmd-D for help


// Boot the server
s.boot;

// Load the data

(
~dir=Document.current.dir;
~file=CSVFileReader.readInterpret(~dir ++ "/MIDI_MM.csv")[0];
~data=~file.do({|i| ~file[i]=~file[i].asFloat});
~data=~data+(0); //Transpose if desired
~datan=~data.normalize;

// For more than one dimension:
// ~data=~file.do({|row, i| row.do({|element,j| ~file[i][j]  = ~file[i][j].asFloat }) }); // parse each element
)


// Define a synth
(
SynthDef(\newSynth, {
	arg basefreq=200, pos=0.5, gain=0.05, dur=0.05;
	var sound, env, synth, stereo;
	sound=gain*SinOsc.ar(basefreq, 0, 1)*AmpComp.kr(basefreq);
	env=EnvGen.kr(Env.sine(dur,1), timeScale:1, doneAction:2);
	synth=sound*env;
	stereo=Pan2.ar(synth, pos, gain);
	OffsetOut.ar(0,stereo);
}).send(s);
)

// Test the synth
Synth.new(\newSynth, [\basefreq, 60.midicps, \pos, 1.0.rand2, \dur, 0.01])



// Play and record onto desktop
(

// User parameters
~noteDur=0.0001;
~length=~noteDur*~data.size;
~transpose=60;
~dLength=~data.size;


// Recording (not working properly yet
SynthDef("help-Diskout", {arg bufnum;
	DiskOut.ar(bufnum, In.ar(0,2));
}).send(s);
b = Buffer.alloc(s, 65536, 2);
b.write("~/Desktop/FlatBeethovenStringQuartets.aiff".standardizePath, "aiff", "int16", 0, 0, true);
d = Synth.tail(nil, "help-Diskout", ["bufnum", b]);

// A Task to play the data
~t=Task({
	~dLength.do({arg i;
		~data[i].postln;
		Synth.new(\newSynth,
			[\pos,		~datan[i].linlin(0,1,-1,1),
			 \basefreq,	(~data[i]+~transpose).midicps,
			 ]);
		(~noteDur).wait
	});
	("Data Length = " ++ ~data.size ++ " samples").postln;
	("Duration = " ++ ~length ++ " seconds").postln;
	(0.2).wait;       // wait 2 seconds for the soundfile to finish playing.  This should be enough time.
		d.free;
		b.close; 		// to finish recording, you need to close your buffer and soundfile.
		b.free; 		// free the buffer
		Done.postln;
}).play;
 )

// bravo!


~data.do
50.do





