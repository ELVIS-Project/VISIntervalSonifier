// A File describing the look and behavior of the checkboxes

// Set check boxes:
~vertChk.value_(true); // default;
~horzChk.value_(false); // default;
~vertChk.action_({if(~vertChk.value,{~horzChk.value_(0);~whichdata=0},{~vertChk.value_(1)})});
~horzChk.action_({if(~horzChk.value,{~vertChk.value_(0);~whichdata=1},{~horzChk.value_(1)})});

// Which of the two columns is being evaluated by default?
~whichdata=0;