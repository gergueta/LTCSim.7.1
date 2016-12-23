unit AscciToSchem;

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
  TASCIIToSchemForm = class(TForm)
    LMDStatusBar1: TLMDStatusBar;
    MainMenu: TMainMenu;
    Schematics2: TMenuItem;
    SelectallASCIIfilesasc1: TMenuItem;
    Generateschematicssch1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    JamFileListAsc: TJamFileList;
    procedure SelectAllClick(Sender: TObject);
    procedure GenerateSchematicsClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ASCIIToSchemForm: TASCIIToSchemForm;

implementation

uses
  MAIN;

{$R *.DFM}

procedure TASCIIToSchemForm.SelectAllClick(Sender: TObject);
begin
  JamFileListAsc.SelectAll;
end;

procedure TASCIIToSchemForm.GenerateSchematicsClick(Sender: TObject);
var
  sCommand, sArgument, sBinDir, sWorkingDir: string;
  i: integer;
begin
  sBinDir := IncludeTrailingPathDelimiter(MAIN.LTCSim.Dir);
  sCommand := IncludeTrailingPathDelimiter(sBinDir) + 'ascin.exe';
  if (FileExists(sCommand)) then
  begin
    for i := 0 to (JamFileListAsc.SelectedFileCount - 1) do
    begin
      sArgument := JamFileListAsc.SelectedPaths.Strings[i];
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
  ASCIIToSchemForm.Close
end;

procedure TASCIIToSchemForm.CloseClick(Sender: TObject);
begin
  Close
end;

end.
