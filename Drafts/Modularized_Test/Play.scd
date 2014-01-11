// A File describing the behavior of the play button

// The play button
~playB.action_({arg butt;
	// If there is no ~data, it becomes a tester.
	if(~paths.isEmpty,{
	Synth.new(\newSynth, [\basefreq, 60.midicps, \pos, 1.0.rand2, \dur, 1, \gain, 0.3])},
		{// Assuming it is not empty, then create a ~task:
			~timepos = ~dataV.selection(0)[0];
			if(~stackChk.value,
				{if(butt.value==1,{~task3.play; ~task2.play;},{~task3.stop; ~task2.stop;})},
				{if(butt.value==1,{~task.play; ~task2.play;},{~task.stop; ~task2.stop;})});
			if(~stackChk.value,
				{1.postln;},
				{2.postln;});
	})
	});