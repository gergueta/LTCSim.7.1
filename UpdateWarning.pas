unit UpdateWarning;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls;

type
  TUpdateWarningDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    CheckWarningMessage: TCheckBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateWarningDlg: TUpdateWarningDlg;

implementation

{$R *.DFM}

end.
