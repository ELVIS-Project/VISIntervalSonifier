// Set synth controls:
~transposition=72;
~spread=1;
~speed=0.01;
~timepos=0;

// The Sonification ~task;
~task=Task({
			inf.do({arg i;
				//[~data[~timepos][0], i].postln;
		        Synth.new(\newSynth, [\basefreq,((~data[(~timepos)][~whichdata]*~spread)+~transposition).midicps]);
		        ~timepos = ~timepos+1;
		        //~timepos.postln;
				(~speed).wait;
})
	});

// GUI Updating must be on a different clock than the synth
~task2 = Task({
	inf.do({arg j;
			{~dataV.timeCursorPosition = ~timepos;
			~vertpos.string_("Vert:"+~data.flop[0][~dataV.timeCursorPosition].asString);
			~horpos.string_("Horz:"+~data.flop[1][~dataV.timeCursorPosition].asString);
		    ~playindx.string_("Index:"+~dataV.timeCursorPosition;);}.defer(0);
		(1/25).wait;
	});
});

~task3=Task({
	inf.do({arg i;
		i.postln;
		//[~data[~timepos][0], i].postln;
		Synth(\newSynth, [\basefreq, ((~data[(~timepos)][1]*~spread)+~transposition).midicps,\pos, -1]);
		Synth(\newSynth, [\basefreq, (((~data[(~timepos)][0]+~data[(~timepos)][1])*~spread)+~transposition).midicps,\pos,1]);
		(~data[(~timepos)][0]).postln;
		~timepos = ~timepos+1;
		(~speed).wait;
})
	});
