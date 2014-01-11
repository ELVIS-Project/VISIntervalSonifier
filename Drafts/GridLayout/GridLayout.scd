// Basic GUI Set-up
w = Window.new("VIS Interval Sonifier",
	Rect(Window.availableBounds.width/2-300,
		Window.availableBounds.height/2-250,600,500)).front;
w.layout_(GridLayout.rows(
	[nil,nil,nil,[titleS=StaticText(), rows:2, columns:3]],
	[[loadB=Button()],[clearB=Button()],nil,nil,nil,nil],
		[[loadV=ListView(),columns:3,rows:3], nil, nil, [stackChk=CheckBox()], [stereoChk=CheckBox()], [recB=Button()]],
	[nil,nil,nil,[knb1str=StaticText()],[knb2str=StaticText()],
		[knb3str=StaticText()]],
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