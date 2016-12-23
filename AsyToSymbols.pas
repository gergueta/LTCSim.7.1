unit AsyToSymbols;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  ComCtrls, Buttons, ToolWin, StdCtrls,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel,
  LMDCustomStatusBar, LMDStatusBar,
  JAMDialogs,
  LMDCustomListBox, LMDCustomImageListBox, LMDCheckListBox,
  LMDCustomCheckListBox, LMDControl, JamControls,
  ShellApi, SysUtils, System.UITypes;

type
  TAsyToSymForm = class(TForm)
    LMDStatusBar1: TLMDStatusBar;
    MainMenu: TMainMenu;
    Symbols2: TMenuItem;
    SelectallASCIIsymbolsfilesasy1: TMenuItem;
    GenerateSymbols1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    JamFileListAsy: TJamFileList;
    procedure ASCIIToSymbolsClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure SelectAllASCIISymbolsFilesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AsyToSymForm: TAsyToSymForm;

implementation

uses
  MAIN, UpdateSchematics;

{$R *.DFM}

procedure TAsyToSymForm.ASCIIToSymbolsClick(Sender: TObject);
var
  sCommand, sArgument, sBinDir, sWorkingDir: string;
  i: integer;
begin
  sBinDir := IncludeTrailingPathDelimiter(MAIN.LTCSim.Dir);
  sCommand := IncludeTrailingPathDelimiter(sBinDir) + 'asyin.exe';
  if (FileExists(sCommand)) then
  begin
    for i := 0 to (JamFileListAsy.SelectedFileCount - 1) do
    begin
      sArgument := JamFileListAsy.SelectedPaths.Strings[i];
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
  AsyToSymForm.Close
end;

procedure TAsyToSymForm.CloseClick(Sender: TObject);
begin
  Close
end;

procedure TAsyToSymForm.SelectAllASCIISymbolsFilesClick(Sender: TObject);
begin
  JamFileListAsy.SelectAll;
end;

end.
