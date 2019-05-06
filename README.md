# ClearAssetsCacheData


Clear Unreal project assets registry cache data. This batch file will be clear project for old assets data. You can do this in 2 situations:

   - To fast clear cache when you have removed unused Source files. (They was remains in the content browser in UE4 Editor)
   - To fast clean when you have something broken in your project.

How to use?

1. Place this file in your project root path.
2. Edit it if u want. (Read below)
3. Run batch file and wait.

[Parameters letters: 1 - Enabled | 0 - Disabled]

##!! Switch CLRASTCACHE property to clear fully assets register cache.
[Used for C++ projects, Default=1] When this parameter is '0' will be cleared only old source files cache data (*.vsxproj, *.vsxproj.filters). If u want clear only old source files data keep this parameter by disabled.

##!! [Used for C++ projects, Default=1] Switch USEGENBIN to generating project files for Visual Studio automatically.
Enable DOSILENCE=1 for close window automatically with end of process if is has done.

