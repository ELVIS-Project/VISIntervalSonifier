// Using SC 3.5.3

// Load data into SC
d = Document.standardizePath("~/Dropbox/ELVIS/Sonification/");
~file=CSVFileReader.readInterpret(d ++ "/MIDI_MM.csv")
~file=~file[0] // Why I have to do this, I don't know...
~data=~file.do({|i| ~file[i]=~file[i].asFloat});

// Data parameters
~noteDur=0.001;
~length=~noteDur*~data.size;
~transpose=18;
~dLength=~data.size;
~datan=~data.normalize;

~data[0]

// Boot the server and make a synth
s.boot
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
Synth.new(\newSynth, [\basefreq, 60.midicps, \pos, 1.0.rand2, \dur, 1, \gain, 1])

// Play it
(
~t=Task({
	~dLength.do({arg i;
		~data[i].postln;
		Synth.new(\newSynth,
			[\pos,		~datan[i].linlin(0,1,-1,1),
			 \basefreq,	(~data[i]+~transpose).midicps,
			 ]);
		(~noteDur).wait;
	});
//	("Data Length = " ++ ~data.size ++ " samples").postln;
//	("Duration = " ++ ~length ++ " seconds").postln;
//	(0.2).wait;       // wait 2 seconds for the soundfile to finish playing.  This should be enough time.
//		d.free;
//		b.close; 		// to finish recording, you need to close your buffer and soundfile.
//		b.free; 		// free the buffer
//		Done.postln;
}).play;
)
