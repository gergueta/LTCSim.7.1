{ $HDR$}
{
$Header: /Users/german/Documents/Development/LTCSim/6.8/LTCSim/RCS/NewRev.pas,v 1.1 2006/11/23 11:38:16 german Exp german $
}
unit NewRev;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LMDCustomControl, LMDCustomPanel, LMDButtonControl,
  LMDCustomCheckBox, LMDCheckBox;

type
   TNewRevisionDlg = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      LMDCheckBoxSch: TLMDCheckBox;
      LMDCheckBoxSym: TLMDCheckBox;
      LMDCheckBoxCir: TLMDCheckBox;
      LMDCheckBoxSp: TLMDCheckBox;
      LMDCheckBoxSpi: TLMDCheckBox;
      LMDCheckBoxNet: TLMDCheckBox;
      LMDCheckBoxLvh: TLMDCheckBox;
   private
      { Private declarations }
   public
      { Public declarations }
   end;
   
var
   NewRevisionDlg: TNewRevisionDlg;
   
implementation

{$R *.DFM}

end.
