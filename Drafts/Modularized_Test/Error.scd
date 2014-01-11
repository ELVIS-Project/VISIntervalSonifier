// A file describing the look and behavior of the error window.

// Got to make a warning dialog from scratch.
~errorD=Window.new("ERROR",Rect(Window.availableBounds.width/2-150,
	Window.availableBounds.height/2-45,300,90)); // centered
~errorD.layout_(GridLayout.rows([[~errorT=StaticText()]]));
~errorD.layout.setAlignment(~errorT, \center);
~errorT.string_("File Must be a .csv!");
~errorT.font = Font("Monaco", 15);