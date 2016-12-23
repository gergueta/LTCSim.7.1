unit DisplayHideAttr;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls, ToolWin, LMDCustomScrollBox,
  LMDListBox, LMDCustomListBox, LMDCustomImageListBox,
  LMDCustomCheckListBox, LMDCheckListBox, ImgList, LMDCustomComponent,
  LMDIniCtrl, IniFiles, LMDShBase, LMDStarter, LMDExtListBox, System.ImageList;

type
  TDisplayHideAttrDlg = class(TForm)
    StatusBar1: TStatusBar;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ImageList: TImageList;
    LMDStarter: TLMDStarter;
    LMDCheckListBox: TLMDCheckListBox;
    Button1: TButton;
    Button2: TButton;
    procedure AttrDisplayCommands(Sender: TObject);
  end;

var
  DisplayHideAttrDlg: TDisplayHideAttrDlg;

implementation

uses
  MAIN;

{$R *.DFM}

procedure TDisplayHideAttrDlg.AttrDisplayCommands(Sender: TObject);
begin
  with Sender as TToolButton do
  begin
    case tag of
      1:
        begin
          // Display all (Unselect)
          LMDCheckListBox.CheckAll(true);
        end;
      2:
        begin
          // Hide all (select)
          LMDCheckListBox.CheckAll(false);
        end;
    end
  end;
end;

end.
