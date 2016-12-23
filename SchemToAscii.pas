unit SchemToAscii;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  ComCtrls, Buttons, ToolWin, StdCtrls,
  JAMDialogs,
  LMDCustomListBox, LMDCustomImageListBox, LMDCheckListBox,
  LMDCustomCheckListBox, LMDControl, JamControls,
  ShellApi, SysUtils, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDCustomStatusBar, LMDStatusBar, System.UITypes;

type
  TSchemToAsciiForm = class(TForm)
    LMDStatusBar1: TLMDStatusBar;
    MainMenu: TMainMenu;
    Schematics3: TMenuItem;
    Selectallschematicfiles1: TMenuItem;
    GenerateASCIIfiles2: TMenuItem;
    N2: TMenuItem;
    Exit2: TMenuItem;
    JamFileListSch: TJamFileList;
    procedure SelectAllClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure GenerateASCIIfilesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SchemToAsciiForm: TSchemToAsciiForm;

implementation

uses
  MAIN, SymToAsy;

{$R *.DFM}

procedure TSchemToAsciiForm.SelectAllClick(Sender: TObject);
begin
  JamFileListSch.SelectAll;
end;

procedure TSchemToAsciiForm.CloseClick(Sender: TObject);
begin
  Close
end;

procedure TSchemToAsciiForm.GenerateASCIIfilesClick(Sender: TObject);
var
  sCommand, sArgument, sBinDir, sWorkingDir: string;
  i: integer;
begin
  sBinDir := IncludeTrailingPathDelimiter(MAIN.LTCSim.Dir);
  sCommand := IncludeTrailingPathDelimiter(sBinDir) + 'ascout.exe';
  if (FileExists(sCommand)) then
  begin
    for i := 0 to (JamFileListSch.SelectedFileCount - 1) do
    begin
      sArgument := JamFileListSch.SelectedPaths.Strings[i];
      sWorkingDir := ExtractFilePath(sArgument);
      if (FileExists(sArgument)) then
        ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
          PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
      else
        MessageDlg('File ' + sArgument + ' not found!', mtError, [mbOK], 0);
    end
  end
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);
  SchemToAsciiForm.Close
end;

end.
