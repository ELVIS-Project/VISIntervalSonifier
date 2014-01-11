// A file describing the look and behavior of the knobs in the GUI

// Center the knobs strings
~knb1str.align = \center;
~knb2str.align = \center;
~vertMaxStr.align = \center;

//~stereoChk.value_(1);

// Knobs:
~knb1.value_(0.5);
~knb2.value_(0.5);
~knb3.value_(0.5);

// What do the knobs do?
~knb1.action_({var val=(~knb1.value*2).round(0.1);
	~knb1str.string_("~spread: "+val.asString+"\n(Octaves)");
	~spread=val;});
~knb2.action_({var val=((~knb2.value*48)+48).round;
	~knb2str.string_("Pitch: "+val.asString+"\n(MIDI)");
~transposition=val;});
~knb3.action_({var val=(10.pow((~knb3.value*2+1))).round;
	~knb3str.string_("Speed: "+val.asString+"\n(Notes/Sec)");
	~speed=1/val});