unit rename;

interface

uses
  Windows,
  SysUtils, Classes, Graphics, Forms, Controls,
  StdCtrls, Buttons, ExtCtrls;
  //, ovcbase, ovcef, ovcsf,
  //ExtCtrls;

type
  TRenameDlg = class(TForm)
		OKBtn:            TButton;
		CancelBtn:        TButton;
		Bevel1:           TBevel;
    Label1: TLabel;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RenameDlg: TRenameDlg;

implementation

{$R *.DFM}
end.



