{ $HDR$ }
{
  $Header: /Users/german/Documents/Development/LTCSim/6.8/LTCSim/RCS/StimDlg.pas,v 1.1 2006/11/23 11:40:18 german Exp german $
}
unit StimDlg;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls;

type
  TDlgStim = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    eStimFileName: TEdit;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgStim: TDlgStim;

implementation

{$R *.DFM}

end.
