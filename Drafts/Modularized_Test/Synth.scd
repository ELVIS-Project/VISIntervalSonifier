// A file describing the fundamental synth used for sonification

SynthDef(\newSynth, {
	arg basefreq=200, pos=0.5, gain=0.5, dur=0.05;
	var sound, env, synth, stereo;
	sound=gain*SinOsc.ar(basefreq, 0, 1)*AmpComp.kr(basefreq,40.midicps);
	env=EnvGen.kr(Env.sine(dur,1), timeScale:1, doneAction:2);
	synth=sound*env;
	stereo=Pan2.ar(synth, pos, gain);
	OffsetOut.ar(0,stereo);
}).send(s);