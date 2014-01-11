// Color Palette:
QtGUI.palette =QPalette.dark;

// Basic GUI Set-up
~w = Window.new("VIS Interval Sonifier",
	Rect(Window.availableBounds.width/2-300,
		Window.availableBounds.height/2-250,600,500)).front;
~w.layout_(GridLayout.rows(
	[nil,nil,nil,[~titleS=StaticText(), rows:2, columns:3]],
	[[~loadB=Button()],[~clearB=Button()],nil,nil,nil,nil],
	[[~loadV=ListView(),columns:3,rows:3], nil, nil, [~stackChk=CheckBox()], [~stereoChk=CheckBox()], [~diaChk=CheckBox()]],
	[nil,nil,nil,[~knb1str=StaticText()],[~knb2str=StaticText()],
		[~knb3str=StaticText()]],
	[nil,nil,nil,[~knb1=Knob()],[~knb2=Knob()],[~knb3=Knob()]],
	[[~playB=Button()],[~vertChk = CheckBox()],[~horzChk = CheckBox()],
		[~playindx=StaticText()],[~vertpos=StaticText()],[~horpos=StaticText()]],
	[[~dataV=SoundFileView(), columns:6, rows:6], nil, [~vertStr=StaticText(), columns:2]],
	[nil,nil,nil,nil,nil,nil],
	[~vertMinStr = StaticText()],
	[[~horzMaxStr = StaticText()], nil, [~horzStr=StaticText(), columns:2]],
	[nil,nil,nil,nil,nil,nil],
	[~horzMinStr = StaticText()],
	[[~xMinStr=StaticText()],nil,[~xMidStr=StaticText(),columns:2],nil,nil,[~xMaxStr=StaticText()]]
));

// Must put stuff on top of other stuff..
~w.layout.add(~vertMaxStr=StaticText(),6,0);

// .. and change the bottom margin to zero for petiosity.
~w.layout.margins = [10, 10, 10, 0];


// Align things things
~w.layout.setAlignment(~titleS, \center);
~w.layout.setAlignment(~knb1str, \bottom);
~w.layout.setAlignment(~knb2str, \bottom);
~w.layout.setAlignment(~knb3str, \bottom);
~w.layout.setAlignment(~vertMaxStr, \left);
~w.layout.setAlignment(~vertMinStr, \bottomLeft);
~w.layout.setAlignment(~horzMaxStr, \topLeft);
~w.layout.setAlignment(~horzMinStr, \left);
~w.layout.setAlignment(~xMaxStr,\topRight);
~w.layout.setAlignment(~xMidStr,\top);
~w.layout.setAlignment(~xMinStr,\topLeft);
~w.layout.setAlignment(~vertChk,\left);
~w.layout.setAlignment(~horzChk,\left);
~w.layout.setAlignment(~stackChk,\bottom);
~w.layout.setAlignment(~stereoChk,\bottom);
~w.layout.setAlignment(~diaChk,\bottom);
~w.layout.setAlignment(~vertStr,\top);
~w.layout.setAlignment(~horzStr,\top);

// Format Title
~titleS.string_("VIS Interval Sonifer"); ~titleS.font =  Font("Monaco", 25);

// Set strings
~knb1str.string_("Spread");
~knb2str.string_("Pitch");
~knb3str.string_("Speed");
~loadB.states_([["Load"]]);
~clearB.states_([["Clear"]]);
~playB.states_([["Play"],["Pause"]]);
~vertpos.string_("Vert: 0");
~horpos.string_("Horz: 0");
~playindx.string_("Index: 0");
~vertChk.string_("Vertical");
~horzChk.string_("Horizontal");
~diaChk.string_("Diatonic");
~stackChk.string_("Stack");
~stereoChk.string_("Stereo");

// What font to use in the ~data plot (~dataV)?
~dataFont = Font("Helvetica",10);
~vertMaxStr.font_(~dataFont);
~vertMinStr.font_(~dataFont);
~horzMaxStr.font_(~dataFont);
~horzMinStr.font_(~dataFont);
~xMinStr.font_(~dataFont);
~xMidStr.font_(~dataFont);
~xMaxStr.font_(~dataFont);
~vertStr.font_(~dataFont);
~horzStr.font_(~dataFont);