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
    OKBtn: TButton;
    CancelBtn: TButton;
    LMDDockManagerArchive: TLMDDockManager;
    ProgressBar: TProgressBar;
    ZipForgeArchive: TZipForge;
    LMDFileOpenDialogArchive: TLMDFileOpenDialog;
    LMDLabeledFileOpenEditTopSchematics: TLMDLabeledFileOpenEdit;
    LMDCheckListBox1: TLMDCheckListBox;
    LMDButton1: TLMDButton;

    procedure ArchiverOverallProgress(Sender: TObject; Progress: Double;
      Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
      var Cancel: Boolean);
    procedure ArchiverFileProgress(Sender: TObject; FileName: WideString;
      Progress: Double; Operation: TZFProcessOperation;
      ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure FormShow(Sender: TObject);
    procedure LMDButton1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LTCSimArchiveForm: TLTCSimArchiveForm;

implementation

{$R *.dfm}

procedure TLTCSimArchiveForm.ArchiverOverallProgress(Sender: TObject;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  ProgressBar.Position := Trunc(Progress);
  Application.ProcessMessages;
end;

procedure TLTCSimArchiveForm.ArchiverFileProgress(Sender: TObject;
  FileName: WideString; Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  //lblFile.Caption := 'Extracting: ' + FileName;
  Application.ProcessMessages;
end;
procedure TLTCSimArchiveForm.FormShow(Sender: TObject);
begin
 // Opening the window
end;

procedure TLTCSimArchiveForm.LMDButton1Click(Sender: TObject);
var
  sLVSTopNetlist: String;
begin
  Project.topLVSSchematics := LMDLabeledFileOpenEditTopSchematics.Filename;
  sLVSTopNetlist := ChangeFileExt(Project.topLVSSchematics, '.net');
  if not( FileExists( sLVSTopNetlist )) then
    begin
      MessageDlg( 'LVS netlist missing. Generate a new one and MPT will do a final compare!.',
      mtError, [mbOK], 0);
    end;

  try
    with ZipForgeArchive do
      begin
        FileName := Project.zipFileName;
        OpenArchive(fmCreate);
        BaseDir := LTCSim.localProjectsDir;
        Comment := 'LTCSim:' + ExtractFileName( Project.topLVSSchematics );
        CompressionLevel := clNone;
        ExclusionMasks.Clear();
        FileMasks.Clear();
        FileMasks.Add(IncludeTrailingPathDelimiter(LTCSim.localProjectsDir) +
          IncludeTrailingPathDelimiter(Project.Name) +
          IncludeTrailingPathDelimiter(Project.Rev) + '*.*');
          AddFiles();
          CloseArchive();
      end;
        except on E:
          Exception do
            begin
              Writeln('Exception: ', E.Message);
              Readln;
            end;
  end;

end;



end.
