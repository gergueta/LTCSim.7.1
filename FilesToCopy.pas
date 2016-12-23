{ $HDR$}
{
$Header: /Users/german/Documents/Development/LTCSim/6.8/LTCSim/RCS/FilesToCopy.pas,v 1.1 2006/11/23 11:37:04 german Exp german $
}

unit FilesToCopy;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, OvcBase, OvcLB, Ovcbcklb, Lmdsplta, ComCtrls,
  lmdctrl, lmdstdcS, StUtils, StStrS, OvcCkLb, LMDControl, LMDBaseControl,
  LMDBaseGraphicControl, LMDBaseLabel, LMDCustomSimpleLabel,
  LMDSimpleLabel, LMDCustomControl, StSystem, LMDCustomListBox,
  LMDCustomImageListBox, LMDCheckListBox;

type
  TFilesToCopyDlg = class(TForm)
		StatusBar1:          TStatusBar;
		HeaderControl1:      THeaderControl;
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FilesToCopyDlg: TFilesToCopyDlg;

implementation

{$R *.DFM}

function SchFilesOnly(const SR: TSearchRec;
  ForInclusion: Boolean; var Abort: Boolean) : Boolean;
begin
  if (CompUCStringS(JustExtensionS(SR.Name), 'SCH') = 0) or
     (SR.Attr and faDirectory = faDirectory)
  then
    Result := True
  else
    Result := False;
end;

procedure TFilesToCopyDlg.FormActivate(Sender: TObject);
var
  i: Longint;
  Alist: TStringList;
begin { TUpdateSchem.eUpdateSchDirChange }
  { TUpdateForm.FormActivate }
  Alist := TStringList.Create;
  Alist.Clear;
  LMDCheckListBox.Items.Clear;
  Screen.Cursor := crHourGlass;
  EnumerateFiles(LMDSimpleLabelFrom.Caption + '\schem', LMDCheckListBox.Items, True, SchFilesOnly);
end; { TUpdateSchem.eUpdateSchDirChange }

end.
