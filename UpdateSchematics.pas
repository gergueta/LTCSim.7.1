unit UpdateSchematics;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, ShellApi,
  ImgList, ComCtrls, ToolWin, Menus, JAMControls,
  StdCtrls, ExtCtrls, Forms, Dialogs, System.ImageList, System.UITypes;

type
  TUpdateSchemDlg = class(TForm)
    JamFileList: TJamFileList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList: TImageList;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    procedure UpdateSchemCommands(Sender: TObject);
    procedure UpdateSelectedSchem;
  end;

var
  UpdateSchemDlg: TUpdateSchemDlg;

implementation

uses
  MAIN;

{$R *.DFM}

procedure TUpdateSchemDlg.UpdateSchemCommands(Sender: TObject);
begin
  with Sender as TToolButton do
  begin
    case tag of
      1:
        begin
          JamFileList.SelectAll;
        end;
      2:
        begin
          UpdateSelectedSchem;
        end;
      3:
        UpdateSchemDlg.Close;
    end
  end
end;

procedure TUpdateSchemDlg.UpdateSelectedSchem;
var
  sCommand, sArgument, sWorkingDir: string;
  i: integer;
begin
  sWorkingDir := IncludeTrailingPathDelimiter(MAIN.LTCSim.Dir);
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'Updatesc.exe';
  if (FileExists(sCommand)) then
  begin
    for i := 0 to (JamFileList.SelectedPaths.Count - 1) do
    begin
      sArgument := JamFileList.SelectedPaths.Strings[i];
      if (FileExists(sArgument)) then
        ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
          PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
      else
        MessageDlg('File ' + sArgument + ' not found!', mtError, [mbOK], 0);
    end
  end
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);
  UpdateSchemDlg.Close
end;

end.
