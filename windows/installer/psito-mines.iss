; O instalador do Psito Mines no Windows, gerado no CI com o Inno Setup.
;
;   ISCC /DAppVersion=1.2.3 windows\installer\psito-mines.iss
;
; Instala só para quem está usando, sem pedir administrador, e quem quiser pode
; instalar para todos no diálogo.
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#define AppName "Psito Mines"
#define AppExe "psito_mines.exe"
#define AppModelId "Psito.Mines"
#define Release "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{291B414C-BB0A-4CB1-AB9B-404F021FEF4C}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Psito Mines contributors
AppPublisherURL=https://francisceioseph.github.io/psito-mines/
AppSupportURL=https://github.com/francisceioseph/psito-mines/issues
AppUpdatesURL=https://github.com/francisceioseph/psito-mines/releases
VersionInfoVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
DisableDirPage=auto
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.17763
OutputDir=Output
OutputBaseFilename=psito-mines-windows-x64-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=force
RestartApplications=no

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#Release}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\..\LICENSE"; DestDir: "{app}\licenses"; DestName: "LICENSE.txt"; Flags: ignoreversion
Source: "..\..\THIRD_PARTY_LICENSES.md"; DestDir: "{app}\licenses"; Flags: ignoreversion
Source: "..\..\assets\LICENSE.md"; DestDir: "{app}\licenses"; DestName: "ART-LICENSE.md"; Flags: ignoreversion
Source: "..\..\assets\fonts\OFL.txt"; DestDir: "{app}\licenses"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppModelId}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; AppUserModelID: "{#AppModelId}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

; O desinstalador não fecha o jogo sozinho, e o arquivo aberto ficaria para trás
[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im {#AppExe}"; Flags: runhidden; RunOnceId: "StopGame"
