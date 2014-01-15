ELVISon

The ELVIS Interval Sonifier

This is the GitHub page of the ELVIS Interval Sonifier.  It is currently available in two versions:
	- Standalone Application for MacOSX 10.6-10.8
	- SuperCollider Source code (VISIntervalSonifier.scd)

The first should be able to run like any other application on the MacOSX 10.6-10.8 operating system, though has only been tested in 10.7.5.

The second is code that is executable in SuperCollider, which can run in any operating system.  The second is designed for people who like to code and build things to make them better.  

If you are doing the second and want to ELVISon to boot with default data, I have prepared some in the Default_Data folder of this GitHub repository.  You should put it into your SuperCollider Resources Folder:

SuperCollider.app/Contents/Resources

Hacking and Building

In the SuperCollider-Source folder are all of the necessary resources to rebuild ELVISon from its SuperCollider source.  If you are using the MacOSX standalone application, your easiest option will be to go to the onStartup.scd folder, which contains everything that happens on startup.



