SongAnnouncer
=============

SongAnnouncer is a Toastify plugin to announce songs played in Spotify using the festival text to speech library.

System Requirements
=============

- Only works on Windows
- Toastify (tested on 1.5), download: http://toastify.codeplex.com/
- Spotify client, download: http://www.spotify.com

Installing SongAnnouncer
=============
Easy to use installer can be found here:
http://joostvandoorn.com/songannouncer/SongAnnouncerSetup.exe

How to compile
=============
- Download festival: http://www.cstr.ed.ac.uk/projects/festival/
- Compile festival on Windows using cygwin. Use the readme & faq for festival.
- Extract the lib/ directory and place this in the "Toastify/SongAnnouncer" directory
- Move the festival.exe file to the "Toastify/SongAnnouncer" directory
- Compile SongAnnouncer.dll as a plugin for Toastify using Visual Studio (2010)
- Place SongAnnouncer.dll in the "Toastify" directory
- Add the following snippit to the <Plugin> tag in the %APPDATA%/Toastify/Toastify.xml file

```xml
    <PluginDetails>
        <FileName>SongAnnouncer.dll</FileName>
        <TypeName>SongAnnouncer.SongAnnouncer</TypeName>
    </PluginDetails>
```