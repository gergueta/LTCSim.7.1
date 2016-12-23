unit NewRevWithoutProcessCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LMDButtonControl, LMDCustomCheckBox, LMDCheckBox,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel,
  LMDCustomParentPanel, LMDCustomGroupBox, LMDGroupBox, LMDCustomComponent,
  LMDWndProcComponent, LMDCaptionButtons, LMDSimplePanel, LMDDlgButtonPanel,
  StdCtrls, LMDCustomButton, LMDButton, lmdformA, LMDCustomButtonGroup,
  LMDCustomRadioGroup, LMDRadioGroup, LMDControl, LMDBaseControl,
  LMDBaseGraphicControl, LMDBaseLabel, LMDCustomSimpleLabel,
  LMDSimpleLabel, LMDBaseEdit, LMDCustomEdit, LMDEdit, LMDCustomCheckGroup,
  LMDCheckGroup, Vcl.ComCtrls, JamControls, Vcl.ExtCtrls;

type
  TNewRevForm = class(TForm)
    LMDDlgButtonPanel1: TLMDDlgButtonPanel;
    btnOK1: TLMDButton;
    btnCancel1: TLMDButton;
    Panel1: TPanel;
    LMDRadioGroupUpdateFromServer: TLMDRadioGroup;
    EditNewRev: TEdit;
    Label1: TLabel;
    LMDCheckGroup: TLMDCheckGroup;
    Splitter1: TSplitter;
    Panel2: TPanel;
    SearchFileList: TJamFileList;
    FilesSearch: TButton;
    eOldRev: TLabeledEdit;
    ProgressBarCopyOldFiles: TProgressBar;
    procedure LMDCheckGroupChange(Sender: TObject; ButtonIndex: Integer);
    procedure FilesSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewRevForm: TNewRevForm;

implementation

{$R *.dfm}

uses Main;

procedure TNewRevForm.FilesSearchClick(Sender: TObject);
var
  sFilter: string;
  sTemp: string;
begin
  SearchFileList.Stop;
  SearchFileList.Clear;
  SearchFileList.SetFocus();
  SearchFileList.SearchOptions.Reset();
  sFilter := '';
  if NewRevForm.LMDCheckGroup.Checked[0] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.sch'
    else
      sFilter := sFilter + ';*.sch'
  end;
  if NewRevForm.LMDCheckGroup.Checked[1] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.sym'
    else
      sFilter := sFilter + ';*.sym'
  end;
  if NewRevForm.LMDCheckGroup.Checked[2] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.asc'
    else
      sFilter := sFilter + ';*.asc'
  end;
  if NewRevForm.LMDCheckGroup.Checked[3] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.asy'
    else
      sFilter := sFilter + ';*.asy'
  end;
  if NewRevForm.LMDCheckGroup.Checked[4] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.spi'
    else
      sFilter := sFilter + ';*.spi'
  end;
  if NewRevForm.LMDCheckGroup.Checked[5] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.net'
    else
      sFilter := sFilter + ';*.net'
  end;
  if NewRevForm.LMDCheckGroup.Checked[5] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.lvh'
    else
      sFilter := sFilter + ';*.lvh'
  end;
  if NewRevForm.LMDCheckGroup.Checked[6] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '*.cir'
    else
      sFilter := sFilter + ';*.cir'
  end;
  if NewRevForm.LMDCheckGroup.Checked[7] then
  begin
    if sFilter = '' then
      sFilter := sFilter + '.sp'
    else
      sFilter := sFilter + ';*.sp'
  end;
  SearchFileList.SearchOptions.Filter := sFilter;
  SearchFileList.SearchOptions.RecursiveSearch := true;
  SearchFileList.SearchOptions.FilesAndFolders := TFilesFolders.ffFilesOnly;
  sTemp := Main.Project.SchemDir;
  SearchFileList.Search(sTemp);
end;

procedure TNewRevForm.LMDCheckGroupChange(Sender: TObject;
  ButtonIndex: Integer);
begin
  if LMDCheckGroup.Checked[8] then
  begin
    LMDCheckGroup.Checked[0] := true;
    LMDCheckGroup.Checked[1] := true;
    LMDCheckGroup.Checked[2] := true;
    LMDCheckGroup.Checked[3] := true;
    LMDCheckGroup.Checked[4] := true;
    LMDCheckGroup.Checked[5] := true;
    LMDCheckGroup.Checked[6] := true;
    LMDCheckGroup.Checked[7] := true;
  end;
end;

end.
