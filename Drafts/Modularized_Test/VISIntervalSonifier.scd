// VIS Interval Sonifier (or VIS)
//
//
// Created by R. Michael Winters
// Input Devices and Music Interaction Laboratory
// September 10, 2013
//
// Running SuperCollider 3.6.5 MacOSX 10.7.5
// Double click inside parenthesis to select all
// Shift-Enter to Evaluate
// Command-D for Help

s.boot;

(

// Basic GUI Appearance
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/BasicGUIAppearance.scd".loadPaths;

// ClearButton
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/clearB.scd".loadPaths;

// Loading Data
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/DataLoading.scd".loadPaths;

// The SoundFileView
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/soundFileView.scd".loadPaths;

// Knobs
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/Knobs.scd".loadPaths;

// CheckBoxes
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/CheckBoxes.scd".loadPaths;

// Error Dialog
"/Users/mikewinters/Dropbox/VIS/Modularized_Test/Error.scd".loadPaths;




//// SONIFICATION:

"/Users/mikewinters/Dropbox/VIS/Modularized_Test/Synth.scd".loadPaths;

"/Users/mikewinters/Dropbox/VIS/Modularized_Test/Tasks.scd".loadPaths;

"/Users/mikewinters/Dropbox/VIS/Modularized_Test/Play.scd".loadPaths;

// What happens when the user closes
~w.onClose_({~task.stop;~task2.stop;});


)




//Trash:
