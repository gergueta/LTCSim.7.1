unit LTCSimArchive;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LMDControl, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDCustomParentPanel, LMDCustomGroupBox,
  LMDCustomButtonGroup, LMDCustomCheckGroup, LMDCheckGroup, LMDDckSite,
  Vcl.ComCtrls, ZipForge, LMDCustomComponent, LMDVistaDialogs, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit,
  LMDCustomListBox, LMDCustomImageListBox, LMDCustomCheckListBox,
  LMDCheckListBox, LMDCustomButton, LMDButton, Main, Dialogs;

type
  TLTCSimArchiveForm = class(TForm)
    CancelBtn: TButton;
    LMDDockManagerArchive: TLMDDockManager;
    ProgressBar: TProgressBar;
    ZipForgeArchive: TZipForge;
    LMDFileOpenDialogArchive: TLMDFileOpenDialog;
    LMDLabeledFileOpenEditTopSchematics: TLMDLabeledFileOpenEdit;
    LMDButton1: TLMDButton;
    LabelFileArchiving: TLabel;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LMDButton1Click(Sender: TObject);
    procedure ZipForgeArchiveFileProgress(Sender: TObject; FileName: string;
        Progress: Double; Operation: TZFProcessOperation; ProgressPhase:
        TZFProgressPhase; var Cancel: Boolean);
    procedure ZipForgeArchiveOverallProgress(Sender: TObject; Progress: Double;
        Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase; var
        Cancel: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LTCSimArchiveForm: TLTCSimArchiveForm;

implementation

{$R *.dfm}


procedure TLTCSimArchiveForm.CancelBtnClick(Sender: TObject);
begin
  Close();
end;

procedure TLTCSimArchiveForm.FormShow(Sender: TObject);
begin
 // Opening the window
  LMDLabeledFileOpenEditTopSchematics.InitialDir := Project.SchemDir;
  LMDLabeledFileOpenEditTopSchematics.DefaultExt := '*.net';
end;

procedure TLTCSimArchiveForm.LMDButton1Click(Sender: TObject);
var
  sLVSTopNetlist: String;
begin
  Project.topLVSSchematics := LMDLabeledFileOpenEditTopSchematics.FileName;
  sLVSTopNetlist := ChangeFileExt(Project.topLVSSchematics, '.net');
  if not(FileExists(sLVSTopNetlist)) then
  begin
    MessageDlg
      ('LVS netlist missing. Generate a new one and MPT will do a final compare!.',
      mtError, [mbOK], 0);
    Close();
  end;
  if FileExists(Project.ZipFileName) then
  begin
    if MessageDlg('Do you really want to delete ' +
      ExtractFileName(Project.ZipFileName) + '?', mtConfirmation, [mbYes, mbNo],
      0) = mrYes then
      SysUtils.DeleteFile(Project.ZipFileName)
    else
      Close();
  end;
  try
    with ZipForgeArchive do
    begin
      FileName := Project.ZipFileName;
      OpenArchive(fmCreate);
      BaseDir := LTCSim.localProjectsDir;
      Comment := 'LTCSim:' + ExtractFileName(Project.topLVSSchematics);
      CompressionLevel := clNone;
      ExclusionMasks.Clear();
      FileMasks.Clear();
      // FileMasks.Add(IncludeTrailingPathDelimiter(LTCSim.localProjectsDir) +
      // IncludeTrailingPathDelimiter(Project.Name) +
      // IncludeTrailingPathDelimiter(Project.Rev) + '*.*');
      // ExclusionMasks.Add('*.dat');
      FileMasks.Add('*.sch');
      FileMasks.Add('*.sym');
      FileMasks.Add('*.asc');
      FileMasks.Add('*.asy');
      FileMasks.Add('*.spi');
      FileMasks.Add('*.v');
      FileMasks.Add('*.cdl');
      FileMasks.Add('*.lvs');
      FileMasks.Add('*.apt');
      FileMasks.Add('*.lvh');
      FileMasks.Add('*.alvh');
      FileMasks.Add('*.edf');
      FileMasks.Add('*.sp');
      FileMasks.Add('*.cir');
      FileMasks.Add('*.netz');
      FileMasks.Add('*.net');
      FileMasks.Add('*.pdf');
      FileMasks.Add('*.doc*');
      FileMasks.Add('*.ppt*');
      FileMasks.Add('*.xl*');
      FileMasks.Add('*.snap');
      AddFiles();
      CloseArchive();
      Close();
    end;
  except
    on E: Exception do
    begin
      Writeln('Exception: ', E.Message);
      Readln;
    end;
  end;

end;

procedure TLTCSimArchiveForm.ZipForgeArchiveFileProgress(Sender: TObject;
    FileName: string; Progress: Double; Operation: TZFProcessOperation;
    ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  LabelFileArchiving.Caption := 'Archiving: ' + FileName;
  Application.ProcessMessages;
end;

procedure TLTCSimArchiveForm.ZipForgeArchiveOverallProgress(Sender: TObject;
    Progress: Double; Operation: TZFProcessOperation; ProgressPhase:
    TZFProgressPhase; var Cancel: Boolean);
begin
  ProgressBar.Position := Trunc(Progress);
  Application.ProcessMessages;
end;

end.
