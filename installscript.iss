; Song Announcer plugin install script



#define MyAppName "SongAnnouncer"
#define MyAppVersion "1.0"
#define MyAppPublisher "Joost van Doorn"
#define MyAppURL "http://www.joostvandoorn.com/songannouncer"
#define MyAppExeName "SongAnnouncer.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{541541AD-B60A-4FC4-8BFB-78682D769DFB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "SongAnnouncer\*"; DestDir: "{code:GetDefaultDir}\SongAnnouncer\"; Flags: ignoreversion recursesubdirs createallsubdirs        
Source: "SongAnnouncer.dll"; DestDir: "{code:GetDefaultDir}"; Flags: ignoreversion recursesubdirs createallsubdirs



[Code]
function GetDriveType( lpDisk: String ): Integer;
external 'GetDriveTypeA@kernel32.dll stdcall';

function GetLogicalDriveStrings( nLenDrives: LongInt; lpDrives: String ): Integer;
external 'GetLogicalDriveStringsA@kernel32.dll stdcall';   
var     
  preferredDrive : string;
const
  DRIVE_UNKNOWN = 0; // The drive type cannot be determined.
  DRIVE_NO_ROOT_DIR = 1; // The root path is invalid. For example, no volume is mounted at the path.
  DRIVE_REMOVABLE = 2; // The disk can be removed from the drive.
  DRIVE_FIXED = 3; // The disk cannot be removed from the drive.
  DRIVE_REMOTE = 4; // The drive is a remote (network) drive.
  DRIVE_CDROM = 5; // The drive is a CD-ROM drive.
  DRIVE_RAMDISK = 6; // The drive is a RAM disk.
  SETTING = '<PluginDetails><FileName>SongAnnouncer.dll</FileName><TypeName>SongAnnouncer.SongAnnouncer</TypeName></PluginDetails>';

function GetDriveLocation(): string;
var
sd : string;
driveletters : string;
lenletters : Integer;
drive : string;
disktype, n: Integer;
sTemp : string;
begin
  if(Length(preferredDrive) = 0) then
  begin
    //get the system drive
    sd := UpperCase(ExpandConstant('{sd}'));
    sTemp := 'C:\';
    //get all drives letters of system
    driveletters := StringOfChar( ' ', 64 );
    lenletters := GetLogicalDriveStrings( 63, driveletters );
    SetLength( driveletters , lenletters );
    drive := '';
    n := 0;
    while ( length(driveletters) > n ) do
    begin
      drive:= UpperCase( Copy( driveletters, n, 3 ) ); 
      n := n+3;   
      // get number type of disk
      disktype := GetDriveType( drive );

      // add it only if it is not a floppy
      if ( disktype = DRIVE_FIXED ) then
      begin                       
        if drive > '' then
        begin       
          if FileExists(drive+'Program Files (x86)\Toastify\Toastify.exe') then
          begin                                                  
             sTemp := drive+'Program Files (x86)\Toastify\';
          end;
          if FileExists(drive+':\Program Files\Toastify\Toastify.exe')  then
          begin
             sTemp := drive+'Program Files\Toastify\';
          end;
        end
      end
    end; 
    preferredDrive := sTemp;           
  end;  
  Result := preferredDrive;
end;  
function GetDefaultDir(def: string): string;
var
sTemp : string;
begin
    //Set a defualt value so that the install doesn't fail.  
    sTemp := ExpandConstant('{reg:HKLM\Software\Toastify,Path|{pf}\Toastify}');

    //We need to get the current install directory.  
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\Toastify', 'InstallDir', sTemp) then
     begin
    //We found the value in the registry so we'll use that.  Otherwise we use the default 
     end;
    if FileExists(ExpandConstant('{userappdata}\Toastify\Toastify.xml'))  then
      begin
        sTemp := GetDriveLocation();
      end;
    Result := sTemp;
end;
function ConfigPlugin(): boolean;
var
sTemp : String;
begin
  if(LoadStringFromFile(ExpandConstant('{userappdata}\Toastify\Toastify.xml'), sTemp)) then
  begin
    if(Pos('SongAnnouncer.dll',sTemp)=0) then
    begin
      if(Pos('<Plugins/>',sTemp)>0) then
      begin
        StringChange(sTemp, '<Plugins/>' , '<Plugins>'+SETTING+'</Plugins>');
        SaveStringToFile(ExpandConstant('{userappdata}\Toastify\Toastify.xml'), sTemp , False);
      end else begin 
        StringChange(sTemp, '<Plugins>' , '<Plugins>'+SETTING);    
        SaveStringToFile(ExpandConstant('{userappdata}\Toastify\Toastify.xml'), sTemp , False);
      end;
    end;
  end;
end;
   
function UnConfigPlugin(): boolean;
var
sTemp : String;
begin
  if(LoadStringFromFile(ExpandConstant('{userappdata}\Toastify\Toastify.xml'), sTemp)) then
  begin  
    if(Pos('SongAnnouncer.dll',sTemp)>0) then
    begin                         
      StringChange(sTemp, SETTING , '');
      SaveStringToFile(ExpandConstant('{userappdata}\Toastify\Toastify.xml'), sTemp , False);
    end;
  end;
end;
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if(CurStep=ssPostInstall) then
  begin
    if IsUninstaller()=False then begin
      ConfigPlugin();
    end
  end;
end;
procedure CurUninstallStepChanged(CurStep: TUninstallStep);
begin
  if(CurStep=usPostUninstall) then
  begin
    if IsUninstaller()=True then begin
      UnConfigPlugin();
    end;
  end;
end;

