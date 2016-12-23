unit ProcessDialog;

interface

uses
  Windows, SysUtils,
  Classes, Graphics, Forms, Controls,
  StdCtrls, Buttons, ComCtrls,
  ExtCtrls,
  ToolWin,
  Dialogs,
  Grids, DBCtrls,
  LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDCustomParentPanel, LMDCustomGroupBox,
  LMDCustomButtonGroup, LMDCustomCheckGroup, LMDCheckGroup,
  LMDCustomCheckBox, LMDCheckBox, LMDButtonControl, LMDRadioButton,
  LMDGroupBox, DBGrids,
  LMDBaseEdit, LMDCustomEdit, LMDCustomMaskEdit, LMDMaskEdit, LMDControl,
  LMDCustomExtCombo, LMDComboBoxExt, Data.DB;

type
  ProcessRecord = record
    Name: string;
    Process_Id: double;
    Rev: string;
    Promis: string;
    Promis_ID: string;
    option1: string;
    option1Code: string;
    option1Name: string;
    option2: string;
    option2Code: string;
    option2Name: string;
    SetupFile: string;
    IniFileName: string;
    GenericRev: string;
    device: string;
    gFileName: string;
    aFileName: string;
    asyFilename: string;
    // IniFile				: TStRegIni;
    GraphicsDir: string;
    AttributesDir: string;
    SymbolsDir: string;
  end;

  ProjectRecord = record
    Name: string;
    Rev: string;
    Dir: string;
    SetupFile: string;
    oldSetupFile: string;
    SchemDir: string;
    IniFileName: string;
    SynFileName: string;
    StyFileName: string;
  end;

  TPagesDlg = class(TForm)
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    ProcessGroupBox: TGroupBox;
    DBGridProcessNames: TDBGrid;
    ControlBar1: TControlBar;
    ControlBar2: TControlBar;
    Label1: TLabel;
    eProjectName: TEdit;
    Label2: TLabel;
    eProjectRev: TEdit;
    Label3: TLabel;
    eProcessName: TEdit;
    Label4: TLabel;
    eProcessRev: TEdit;
    Label5: TLabel;
    ePromis: TEdit;
    Label6: TLabel;
    eOption1: TEdit;
    Label7: TLabel;
    eOption2: TEdit;
    Option1Label: TLabel;
    Option2Label: TLabel;
    RevLabel: TLabel;
    PromLabel: TLabel;
    ComboBoxRev: TComboBox;
    ComboBoxProm: TComboBox;
    ComboBoxOption1: TComboBox;
    ComboBoxOption2: TComboBox;
    eGenericRev: TEdit;
    GenericLabel: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure DBGridProcessNamesCellClick(Column: TColumn);
    procedure StringGridProcessSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eProjectNameChange(Sender: TObject);
    procedure eProjectRevChange(Sender: TObject);
    procedure ComboBoxRevChange(Sender: TObject);
    procedure ComboBoxPromChange(Sender: TObject);
    procedure ComboBoxOption1Change(Sender: TObject);
    procedure ComboBoxOption2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Project: ProjectRecord;
    Process: ProcessRecord;
  end;

var
  PagesDlg: TPagesDlg;

implementation

uses
  MAIN, DataModule;

{$R *.DFM}

{ sc-----------------------------------------------------------------------
  Name:       TPagesDlg.FormActivate
  -----------------------------------------------------------------------sc }
procedure TPagesDlg.FormActivate(Sender: TObject);
begin
  ComboBoxRev.Clear;
  ComboBoxProm.Clear;
  ComboBoxOption1.Clear;
  ComboBoxOption2.Clear;
  with LibraryDatabase.UniQueryNames do
  begin
    close();
    SQL.Clear;
    SQL.Add('SELECT process_id, processname, comments');
    SQL.Add('FROM process AS p');
    SQL.Add('WHERE p.available');
    SQL.Add('ORDER BY p.processname');
    open();
  end;
  with DBGridProcessNames do
  begin
    Columns.Clear;
    Columns.Add.FieldName := 'process_id';
    Columns.Add.FieldName := 'processname';
    Columns.Add.FieldName := 'comments';
    Columns.Items[0].Visible := False;
    Columns.Items[1].Width := 100;
    Columns.Items[2].Width := 250;
  end;
end;

procedure TPagesDlg.DBGridProcessNamesCellClick(Column: TColumn);
begin
  eProcessRev.Clear;
  ePromis.Clear;
  eOption1.Clear;
  eOption2.Clear;
  ComboBoxRev.Clear;
  ComboBoxProm.Clear;
  ComboBoxOption1.Clear;
  ComboBoxOption2.Clear;
  eProcessName.Text := TRIM(DBGridProcessNames.Fields[1].AsString);
  Process.Name := TRIM(DBGridProcessNames.Fields[1].AsString);
  Process.Process_Id := DBGridProcessNames.Fields[0].AsFloat;
  with LibraryDatabase.UniQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('SELECT number, display FROM rev');
    SQL.Add('WHERE process_id = ' + FloatToStr(Process.Process_Id));
    SQL.Add('ORDER BY display DESC');
    open;
  end; { with }
  if LibraryDatabase.UniQuery.RecordCount > 0 then
  begin
    while not LibraryDatabase.UniQuery.Eof do
    begin
      ComboBoxRev.Items.Add(LibraryDatabase.UniQuery.FieldByName('number')
        .AsString);
      LibraryDatabase.UniQuery.Next
    end;
    LibraryDatabase.UniQuery.close;
    with LibraryDatabase.UniQuery do
    begin
      close;
      SQL.Clear;
      SQL.Add('SELECT promis_name, prom_id FROM prom');
      SQL.Add('WHERE process_id = ' + FloatToStr(Process.Process_Id));
      SQL.Add('ORDER BY prom_id');
      open;
    end;
    if LibraryDatabase.UniQuery.RecordCount > 0 then
    begin
      while not LibraryDatabase.UniQuery.Eof do
      begin
        ComboBoxProm.Items.Add
          (TRIM(LibraryDatabase.UniQuery.FieldByName('promis_name').AsString));
        LibraryDatabase.UniQuery.Next
      end;
      LibraryDatabase.UniQuery.close;
    end
    else
    begin
      ePromis.Text := 'N/A';
      ComboBoxProm.Items.Add('N/A');
      ComboBoxOption1.Clear;
      ComboBoxOption1.Text := 'N/A';
      ComboBoxOption1.Items.Add('N/A');
      ComboBoxOption2.Clear;
      ComboBoxOption2.Text := 'N/A';
      ComboBoxOption2.Items.Add('N/A');
      eOption1.Text := 'N/A';
      eOption2.Text := 'N/A';
      Option1Label.Caption := 'N/A';
      Option2Label.Caption := 'N/A';
      LibraryDatabase.UniQuery.close;
    end
  end
  else
  begin
    ShowMessage('Problem detected with this process. Notify CAD for support.');
    LibraryDatabase.UniQuery.close;
  end;
end;

procedure TPagesDlg.StringGridProcessSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  eProcessRev.Clear;
  ePromis.Clear;
  eOption1.Clear;
  eOption2.Clear;
  ComboBoxRev.Clear;
  ComboBoxProm.Clear;
  ComboBoxOption1.Clear;
  ComboBoxOption2.Clear;
  Process.Name := TRIM(DBGridProcessNames.Fields[1].AsString);
  Process.Process_Id := DBGridProcessNames.Fields[0].AsFloat;
  with LibraryDatabase.UniQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('SELECT number FROM rev');
    SQL.Add('WHERE process_id = ' + FloatToStr(Process.Process_Id));
    SQL.Add('ORDER BY number DESC');
    open;
  end; { with }
  if LibraryDatabase.UniQuery.RecordCount > 0 then
  begin
    while not LibraryDatabase.UniQuery.Eof do
    begin
      ComboBoxRev.Items.Add(LibraryDatabase.UniQuery.FieldByName('number')
        .AsString);
      LibraryDatabase.UniQuery.Next
    end;
    LibraryDatabase.UniQuery.close;
    with LibraryDatabase.UniQuery do
    begin
      close;
      SQL.Clear;
      SQL.Add('SELECT promis_name FROM prom');
      SQL.Add('WHERE (process_id = ' + FloatToStr(Process.Process_Id));
      open;
    end; { with }
    if LibraryDatabase.UniQuery.RecordCount > 0 then
    begin
      while not LibraryDatabase.UniQuery.Eof do
      begin
        ComboBoxProm.Items.Add
          (TRIM(LibraryDatabase.UniQuery.FieldByName('promis_name').AsString));
        LibraryDatabase.UniQuery.Next
      end;
      LibraryDatabase.UniQuery.close;
    end
    else
    begin
      ePromis.Text := 'N/A';
      ComboBoxProm.Items.Add('N/A');
      ComboBoxOption1.Clear;
      ComboBoxOption1.Text := 'N/A';
      ComboBoxOption1.Items.Add('N/A');
      eOption1.Text := 'N/A';
      ComboBoxOption2.Clear;
      ComboBoxOption2.Text := 'N/A';
      ComboBoxOption2.Items.Add('N/A');
      eOption2.Text := 'N/A';
      Option1Label.Caption := 'N/A';
      Option2Label.Caption := 'N/A';
      LibraryDatabase.UniQuery.close;
    end
  end
  else
  begin
    ShowMessage('Problem detected with this process. Notify CAD for support.');
    LibraryDatabase.UniQuery.close;
  end;
end;

procedure TPagesDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LibraryDatabase.UniQueryNames.close;
  Project.Name := eProjectName.Text;
  Project.Rev := eProjectRev.Text;
  Process.Name := eProcessName.Text;
  Process.Rev := eProcessRev.Text;
  Process.Promis := ePromis.Text;
  Process.option1 := eOption1.Text;
  Process.option2 := eOption2.Text;
  Process.GenericRev := eGenericRev.Text;
end;

procedure TPagesDlg.eProjectNameChange(Sender: TObject);
begin
  Project.Name := TRIM(eProjectName.Text);
end;

procedure TPagesDlg.eProjectRevChange(Sender: TObject);
begin
  Project.Rev := TRIM(eProjectRev.Text);
end;

procedure TPagesDlg.ComboBoxRevChange(Sender: TObject);
begin
  eProcessRev.Text := TRIM(ComboBoxRev.Text);
  Process.Rev := eProcessRev.Text;
  with LibraryDatabase.UniQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('SELECT generic FROM rev');
    SQL.Add('WHERE process_id = ' + FloatToStr(Process.Process_Id));
    open;
  end; { with }
  LibraryDatabase.UniQuery.First;
  eGenericRev.Text := TRIM(LibraryDatabase.UniQuery.FieldByName('generic')
    .AsString);
  Process.GenericRev := eGenericRev.Text;
  LibraryDatabase.UniQuery.close
end;

procedure TPagesDlg.ComboBoxPromChange(Sender: TObject);
var
  iCount, i: Integer;
  sOptions: string;
  sOption1: String;
  sOption2: String;
  sTemp: string;
  lDetail: TStringList;
begin
  ePromis.Clear;
  lDetail := TStringList.Create;
  ComboBoxOption1.Clear;
  ComboBoxOption2.Clear;
  ePromis.Text := ComboBoxProm.Text;
  Process.Promis := ComboBoxProm.Text;
  if (TRIM(Process.Promis) <> 'N/A') then
  begin
    with LibraryDatabase.UniQuery do
    begin
      close;
      SQL.Clear;
      SQL.Add('SELECT * FROM prom');
      SQL.Add('WHERE promis_name =' + QuotedStr(Process.Promis));
      open;
    end;
    LibraryDatabase.UniQuery.First;
    sOption1 := TRIM(LibraryDatabase.UniQuery.FieldByName('option1').AsString);
    if (sOption1 = 'N/A') then
    begin
      Process.option1Name := sOption1;
      ComboBoxOption1.Clear;
      ComboBoxOption1.Text := 'N/A';
      ComboBoxOption1.Items.Add('N/A');
      eOption1.Text := 'N/A';
      Process.option1 := 'N/A';
      Process.option1Code := 'N/A';
      Option1Label.Caption := 'N/A';
    end
    else
    begin
      lDetail.Clear;
      sTemp := sOption1;
      ExtractStrings(['(', ')'], [' '], PChar(sTemp), lDetail);
      Process.option1Name := lDetail.Strings[0];
      sTemp := lDetail.Strings[1];
      lDetail.Clear;
      ExtractStrings([':'], [' '], PChar(sTemp), lDetail);
      Process.option1Code := lDetail.Strings[0];
      Option1Label.Caption := Process.option1Name + ' (' +
        Process.option1Code + ')';
      sOptions := lDetail.Strings[1];
      lDetail.Clear;
      ExtractStrings([','], [' '], PChar(sOptions), lDetail);
      iCount := lDetail.Count;
      ComboBoxOption1.Clear;
      for i := 0 to (iCount - 1) do
      begin
        ComboBoxOption1.Items.Add(lDetail.Strings[i]);
      end;
    end;
    lDetail.Clear;
    sOption2 := TRIM(LibraryDatabase.UniQuery.FieldByName('option2').AsString);
    if (sOption2 = 'N/A') then
    begin
      Process.option2Name := sOption2;
      ComboBoxOption2.Clear;
      ComboBoxOption2.Text := 'N/A';
      ComboBoxOption2.Items.Add('N/A');
      eOption2.Text := 'N/A';
      Process.option2 := 'N/A';
      Process.option2Code := 'N/A';
      Option2Label.Caption := 'N/A';
    end
    else
    begin
      lDetail.Clear;
      sTemp := sOption2;
      ExtractStrings(['(', ')'], [' '], PChar(sTemp), lDetail);
      Process.option1Name := lDetail.Strings[0];
      sTemp := lDetail.Strings[1];
      lDetail.Clear;
      ExtractStrings([':'], [' '], PChar(sTemp), lDetail);
      Process.option2Code := lDetail.Strings[0];
      Option2Label.Caption := Process.option2Name + ' (' +
        Process.option2Code + ')';
      sOptions := lDetail.Strings[1];
      lDetail.Clear;
      ExtractStrings([','], [' '], PChar(sOptions), lDetail);
      iCount := lDetail.Count;
      ComboBoxOption2.Clear;
      for i := 0 to (iCount - 1) do
      begin
        ComboBoxOption2.Items.Add(lDetail.Strings[i]);
      end;
    end;
    LibraryDatabase.UniQuery.close;
  end
  else
  begin
    ComboBoxOption1.Clear;
    ComboBoxOption1.Text := 'N/A';
    ComboBoxOption1.Items.Add('N/A');
    eOption1.Text := 'N/A';
    Process.option1 := 'N/A';
    Process.option1Code := 'N/A';
    Process.option1Name := 'N/A';
    ComboBoxOption2.Clear;
    ComboBoxOption2.Text := 'N/A';
    ComboBoxOption2.Items.Add('N/A');
    eOption2.Text := 'N/A';
    Process.option2 := 'N/A';
    Process.option2Code := 'N/A';
    Process.option2Name := 'N/A';
    Option1Label.Caption := 'N/A';
    Option2Label.Caption := 'N/A';
  end;
end;

procedure TPagesDlg.ComboBoxOption1Change(Sender: TObject);
begin
  eOption1.Text := ComboBoxOption1.Text;
  Process.option1 := TRIM(ComboBoxOption1.Text)
end;

procedure TPagesDlg.ComboBoxOption2Change(Sender: TObject);
begin
  eOption2.Text := ComboBoxOption2.Text;
  Process.option2 := TRIM(ComboBoxOption2.Text)
end;

end.
