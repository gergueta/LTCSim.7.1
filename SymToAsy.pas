unit SymToAsy;

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
  TSymToAsyForm = class(TForm)
    LMDStatusBar1: TLMDStatusBar;
    MainMenu: TMainMenu;
    Symbols2: TMenuItem;
    Selectallsymbolfiles2: TMenuItem;
    GenerateASCIIfilesasc1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    JamFileListSym: TJamFileList;
    procedure SelectAllSymbolFilesClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure SymbolsToASCIIClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SymToAsyForm: TSymToAsyForm;

implementation

uses
  MAIN, AsyToSymbols;

{$R *.DFM}

procedure TSymToAsyForm.SelectAllSymbolFilesClick(Sender: TObject);
begin
  JamFileListSym.SelectAll;
end;

procedure TSymToAsyForm.CloseClick(Sender: TObject);
begin
  Close
end;

procedure TSymToAsyForm.SymbolsToASCIIClick(Sender: TObject);
var
  sCommand, sArgument, sBinDir, sWorkingDir: string;
  i: integer;

begin
  sBinDir := IncludeTrailingPathDelimiter(MAIN.LTCSim.Dir);
  sCommand := IncludeTrailingPathDelimiter(sBinDir) + 'asyout.exe';
  if (FileExists(sCommand)) then
  begin
    for i := 0 to (JamFileListSym.SelectedFileCount - 1) do
    begin
      sArgument := JamFileListSym.SelectedPaths.Strings[i];
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
  SymToAsyForm.Close
end;

end.
