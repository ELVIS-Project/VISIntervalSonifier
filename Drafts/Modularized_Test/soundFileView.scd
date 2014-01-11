// Define the look and behavior of the SoundFileView
~dataV.timeCursorOn = true;
~dataV.timeCursorColor = Color.red;
~dataV.gridOn = true;
~dataV.gridResolution = 0.1;
~dataV.action_({	var indx = ~dataV.timeCursorPosition;
	~vertpos.string_("Vert:"+~data.flop[0][indx].asString);
	~horpos.string_("Horz:"+~data.flop[1][indx].asString);
	~playindx.string_("Index:"+indx.asString);
	~dataV.timeCursorPosition=~dataV.selection(0)[0];
	~timepos=indx;
});
~dataV.mouseMoveAction_({
		~xMinStr.string_(~dataV.viewStartFrame.round.asString);
		~xMaxStr.string_((~dataV.viewStartFrame+~dataV.viewFrames).round.asString);
~xMidStr.string_((~dataV.viewStartFrame+(~dataV.viewFrames/2)).round(0.5).asString);
});
