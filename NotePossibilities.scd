// How to do it using node messaging (much better for granular)
s.boot;

Routine({1.postln; 1.wait; 2.postln;}).play;

y=[0,2,4,5,7,9,11]

x=3.neg;
y[(1.mod(7)-1)]

(x.abs.wrap(1,7))*x.sign

*(x.div(8).floor*12)

-9.div(8).floor

8.wrap(1,7)+12*-1

25.div(12).floor

1.2.floor

y[7-1]

4.fold(1,7)
s.boot

// Synth from VIS
SynthDef(\newSynth, {
	arg midi=0, spread=1, speed=0.1, transposition=72, iteration=0;
	var sound, env, synth, pitch, pha;
	pitch = ((midi*spread)+transposition).midicps;
	pha = ((pitch*speed*iteration).wrap(0,1)*2*pi); // "Always in Phase"
	sound=SinOsc.ar(pitch, pha,0.01)*AmpComp.kr(pitch,40.midicps);
	env=EnvGen.kr(Env.sine(dur:0.05), doneAction:2);
	synth=sound*env;
	OffsetOut.ar([0,1],synth);
}).send(s);


//Calculation of phase for "always in phase"
g


// Node Messaging for Granular Synthesis
(
SynthDef("grain", {arg freq=1200;
	    Out.ar(0, Line.kr(0.1, 0, 0.005, doneAction:2)!2 * FSinOsc.ar(freq.rand))
}).send(s);
)
// Compare this:
(
Routine({
    100000.do({
		s.sendMsg("/s_new", "grain", -1, 0, 0, \freq, 850);
        0.001.wait;
    })
}).play;
)
// .. to this:
(
Routine({
    100000.do({
		Synth("grain", [\freq, 850]);
        0.001.wait;
    })
}).play;
)



// What is the fundamental synth?
SynthDef(\newSynth, {
	arg basefreq1=200, basefreq2=600, pos=0.5, gain=0.005, transposition=60, dur=0.05;
	var lowerInt, upperInt, env, sound, stereo;
	env=EnvGen.kr(Env.sine(dur,1), doneAction:2);
	lowerInt=SinOsc.ar(basefreq1, 0, env)*AmpComp.kr(basefreq1,40.midicps);
	upperInt=SinOsc.ar(basefreq2, 0, env)*AmpComp.kr(basefreq2,40.midicps);
	stereo=Pan2.ar(lowerInt+upperInt, pos, gain);
	OffsetOut.ar(0,stereo);
}).send(s);


Synth(\newSynth)
x=Array.fill(100, {12.rand;});

h=[[0,0],[-1,0],[-1,1],[-2,1],[-2,2],[-3,2],[-3,3],[-4,3],[-4,4],[-5,4],[-5,5],[-6,5],[-6,6]]

(
// The Sonification task;
t=Task({
		x.size.do({arg i;
		Synth.new(\newSynth,
			[\basefreq1,(h[x[i]][0]*4+60).midicps,
				\basefreq2, (h[x[i]][1]*4+60).midicps
		]);
				(0.1).wait;
});
	}).play;
)


//([[0,0],[0,2],[-1,2],[-1,4],[-3,4],[-3,5],[-5,5],[-5,7]]); // Octave 1

// Chromatic
[ 0, 0,0] // P0: C,  C
[ 1,-1,0] // m2: B,  C
[ 2,-1,1] // M2: B,  C#
[ 3,-2,1] // m3: Bf, Df
[ 4,-2,2] // M3: Bf, D
[ 5,-3,2] // P4: A,  D
[ 6,-3,3] // TT: A,  Ef
[ 7,-4,3] // P5: Af, Ef
[ 8,-4,4] // m6: G#, E
[ 9,-5,4] // M6: G,  E
[10,-5,5] // m7: G,  F
[11,-6,5] // M7: Gf, F
[12,-6,6] // P8: Gf, Gf

// Harmonic
[ 0, 0, 0] // P0: C, C
[ 1,-1, 0] // m2: B, C
[ 2, 0, 2] // M2: C, D
[ 3,-1, 2] // m3: B, D
[ 4, 0, 4] // M3: C, E
[ 5,-1, 4] // P4: B, E
[ 6,-1, 5] // TT: B, F
[ 7,-3, 4] // P5: A, E
[ 7,-3, 5] // m6: A, F
[ 8,-5, 4] // M6: G, E
[ 9,-5, 5] // m7: G, F
[10,-7, 4] // M7: F, E
[11,-7, 5] // P8, F, F  (Subdominant)

