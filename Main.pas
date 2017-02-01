{ $HDR$ }
unit Main;

interface

uses
  SysUtils, StrUtils, Windows, Messages, Classes, Graphics, System.UITypes,
  Controls, Db, ComCtrls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus,
  ToolWin, ImgList, OleCtrls, ShellAPI, IniFiles, Registry, ShellBrowser,
  JamControls, JAMDialogs, ShellLink, ShellControls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdRawBase, IdRawClient,
  IdIcmpClient, XMLIntf, XMLDoc, System.IOUtils, DateUtils, LMDOneInstance,
  LMDButton, LMDMRUList, LMDStorRegistryVault, LMDMaskEdit, LMDCheckBox,
  LMDGroupBox, LMDEdit, LMDFileOpenEdit, LMDComboBox, LMDCustomIniComponent,
  System.ImageList, LMDBaseMRUList, LMDStorBase, LMDCustomComponent,
  LMDThemedComboBox, LMDCustomComboBox, LMDCustomMaskEdit, LMDButtonControl,
  LMDCustomCheckBox, LMDCustomParentPanel, LMDCustomGroupBox,
  LMDCustomBrowseEdit, LMDCustomFileEdit, LMDControl, LMDCustomControl,
  LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit,
  LMDCustomButton, LMDContainerComponent, LMDBaseDialog, LMDAboutDlg,
  LMDShBase, LMDStarter, LMDBrowseDlg, LMDCustomPanelFill, LMDButtonPanel,
  LMDCustomToolBar, LMDToolBar, Vcl.ActnCtrls, Vcl.ActnMan, Vcl.ActnMenus,
  LMDDockSpeedButton, LMDBaseControl, LMDBaseGraphicControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton,
  LMDCustomFormComboBox, LMDFormComboBox, LMDCustomColorComboBox,
  LMDColorComboBox, System.Actions, Vcl.ActnList, LMDCustomScrollBox,
  LMDScrollBox, LMDShController, LMDDockButton, LMDShDlg, LMDShActions,
  LMDCustomStatusBar, LMDStatusBar, LMDBaseLabel, LMDInformationLabel,
  ElXPThemedControl, ElStatBar, LMDDckSite, LMDCustomListBox,
  LMDCustomImageListBox, LMDCustomCheckListBox, LMDCheckListBox,
  CodeSiteLogging, AppIcons, ActiveX, AxNetwork_TLB, ZipForge,
  LMDCustomExtCombo, LMDComboBoxExt, Vcl.PlatformDefaultStyleActnCtrls,
  LMDShLink, LMDShList, LMDShTree, LMDShFolder, LMDTaskDlg, JSDialog,
  LMDTextButton;

type
  TMainForm = class(TForm)
    AboutLTCSim1                    : TMenuItem;
    ActionAscToSch                  : TAction;
    ActionAsyToSym                  : TAction;
    ActionEditSchematics            : TAction;
    ActionLibraryInitialize         : TAction;
    ActionLibraryUpdate             : TAction;
    ActionListFolder                : TActionList;
    ActionManagerMain               : TActionManager;
    ActionNavigateSchematics        : TAction;
    ActionRestartCohesionLicense    : TAction;
    ActionSchematicsNew             : TAction;
    ActionSchematicsOpen            : TAction;
    ActionSchToAsc                  : TAction;
    ActionSymToAsy                  : TAction;
    ActionSynIniEditor              : TAction;
    ADCIItoSym1                     : TMenuItem;
    ArchiveProject1                 : TMenuItem;
    ASCIItoSchem1                   : TMenuItem;
    btnViewStyle                    : TToolButton;
    cbAPTBipolarArea                : TCheckBox;
    cbAPTBipolarWL                  : TCheckBox;
    cbAPTGND                        : TCheckBox;
    cbAPTOmitPrefix                 : TLMDCheckBox;
    cbAPTShrink                     : TCheckBox;
    cbAPTSubcircuit                 : TCheckBox;
    cbAPTXGNDX                      : TCheckBox;
    cbAssuraBipolarArea             : TCheckBox;
    cbAssuraBipolarWL               : TCheckBox;
    cbAssuraGND                     : TCheckBox;
    cbAssuraOmitPrefix              : TLMDCheckBox;
    cbAssuraShrink                  : TCheckBox;
    cbAssuraSubcircuit              : TCheckBox;
    cbAssuraXGNDX                   : TCheckBox;
    cbDraculaBipolarArea            : TCheckBox;
    cbDraculaBipolarWL              : TCheckBox;
    cbDraculaGND                    : TCheckBox;
    cbDraculaOmitPrefix             : TLMDCheckBox;
    cbDraculaShrink                 : TCheckBox;
    cbDraculaSubcircuit             : TCheckBox;
    cbDraculaXGNDX                  : TCheckBox;
    cbFilterAfterNetlist            : TCheckBox;
    cbFilterAfterSchematics         : TCheckBox;
    cbFilterAfterSimulation         : TCheckBox;
    cbHSpiceGND                     : TCheckBox;
    cbHSpiceOmitPrefix              : TLMDCheckBox;
    cbHSpiceShrink                  : TCheckBox;
    cbHSpiceSubcircuit              : TCheckBox;
    cbHSpiceVerilogA                : TCheckBox;
    cbHSpiceXGNDX                   : TCheckBox;
    cbIgnoreCase                    : TCheckBox;
    cbLocation                      : TComboBox;
    cbLTspiceGND                    : TCheckBox;
    cbLTspiceOmitPrefix             : TLMDCheckBox;
    cbLTspiceSchematics             : TCheckBox;
    cbLTspiceShrink                 : TCheckBox;
    cbLTspiceSubcircuit             : TCheckBox;
    cbLTspiceXGNDX                  : TCheckBox;
    cbPrimitiveReport               : TCheckBox;
    cbPSpiceMixedSignal             : TCheckBox;
    cbPSspiceGND                    : TCheckBox;
    cbPSspiceOmitPrefix             : TLMDCheckBox;
    cbPSspiceShrink                 : TCheckBox;
    cbPSspiceSubcircuit             : TCheckBox;
    cbPSspiceXGNDX                  : TCheckBox;
    cbSchematics                    : TComboBox;
    cbStim                          : TComboBox;
    cbTool                          : TComboBox;
    Changeoptions1                  : TMenuItem;
    Cohesion1                       : TMenuItem;
    Configure1                      : TMenuItem;
    Control1                        : TMenuItem;
    CoolBar1                        : TCoolBar;
    Copy1                           : TMenuItem;
    CT2                             : TMenuItem;
    Cut1                            : TMenuItem;
    Delete1                         : TMenuItem;
    Delete2                         : TMenuItem;
    Details2                        : TMenuItem;
    Devicelist1                     : TMenuItem;
    DiisplayHideattributes1         : TMenuItem;
    eAPTBracketSubstitutionLeft     : TLMDLabeledMaskEdit;
    eAPTBracketSubstitutionRight    : TLMDLabeledMaskEdit;
    eAPTLVS_Short                   : TLMDLabeledEdit;
    eAssuraBracketSubstitutionLeft  : TLMDLabeledMaskEdit;
    eAssuraBracketSubstitutionRight : TLMDLabeledMaskEdit;
    eAssuraLVS_Short                : TLMDLabeledEdit;
    Edit1                           : TMenuItem;
    Editschematics1                 : TMenuItem;
    Editstimulus1                   : TMenuItem;
    eDraculaBracketSubstitutionLeft : TLMDLabeledMaskEdit;
    eDraculaBracketSubstitutionRight: TLMDLabeledMaskEdit;
    eDraculaLVS_Short               : TLMDLabeledEdit;
    eFileBrowserFilter              : TEdit;
    eGenericVer                     : TLMDLabeledEdit;
    eHSpiceBracketSubstitutionLeft  : TLMDLabeledMaskEdit;
    eHSpiceBracketSubstitutionRight : TLMDLabeledMaskEdit;
    eHSpiceFileName                 : TLMDLabeledFileOpenEdit;
    eHSpiceOptions                  : TLMDLabeledEdit;
    eHSpiceViewerCommand            : TLMDLabeledFileOpenEdit;
    eHSpiceViewerOptions            : TLMDLabeledEdit;
    eLTCSpiceFileName               : TLMDLabeledFileOpenEdit;
    eLTCSpiceOptions                : TLMDLabeledEdit;
    eLTspiceBracketSubstitutionLeft : TLMDLabeledMaskEdit;
    eLTspiceBracketSubstitutionRight: TLMDLabeledMaskEdit;
    eOption1                        : TLMDLabeledEdit;
    eOption1Code                    : TLMDLabeledEdit;
    eOption1Name                    : TLMDLabeledEdit;
    eOption2                        : TLMDLabeledEdit;
    eOption2Code                    : TLMDLabeledEdit;
    eOption2Name                    : TLMDLabeledEdit;
    eProcessName                    : TLMDLabeledEdit;
    eProcessOpt                     : TEdit;
    eProcessRev                     : TLMDLabeledEdit;
    ePromis                         : TLMDLabeledEdit;
    ePSpiceBracketSubstitutionLeft  : TLMDLabeledMaskEdit;
    ePSpiceBracketSubstitutionRight : TLMDLabeledMaskEdit;
    ePspiceFileName                 : TLMDLabeledFileOpenEdit;
    ePspiceOptions                  : TLMDLabeledEdit;
    ePspiceWaveformTool             : TLMDLabeledFileOpenEdit;
    ePspiceWaveformToolOptions      : TLMDLabeledEdit;
    eTextEditor                     : TJamPathEdit;
    Exit1                           : TMenuItem;
    ExitLTCSim                      : TAction;
    FloatingGate1                   : TMenuItem;
    FolderBackward                  : TAction;
    FolderForward                   : TAction;
    FolderUp                        : TAction;
    FromASCII1                      : TMenuItem;
    FromASCII2                      : TMenuItem;
    GroupBox1                       : TGroupBox;
    GroupBox2                       : TGroupBox;
    Help1                           : TMenuItem;
    Help2                           : TMenuItem;
    ImageList                       : TImageList;
    INIEditor1                      : TMenuItem;
    Initialize1                     : TMenuItem;
    Initializwe1                    : TMenuItem;
    Install1                        : TMenuItem;
    JamFileOperationArchive         : TJamFileOperation;
    JamShellLinkMain                : TJamShellLink;
    JamShellListMain                : TJamShellList;
    JamShellTreeMain                : TJamShellTree;
    JSDialogMain                    : TJSDialog;
    Label2                          : TLabel;
    Label3                          : TLabel;
    Label4                          : TLabel;
    Label7                          : TLabel;
    LabelFilter                     : TLabel;
    Largeicons2                     : TMenuItem;
    Library1                        : TMenuItem;
    LinkLabel2                      : TLinkLabel;
    LinkLabel3                      : TLinkLabel;
    List2                           : TMenuItem;
    LMDAboutDlg                     : TLMDAboutDlg;
    LMDBrowseDirDlg                 : TLMDBrowseDlg;
    LMDButton1                      : TLMDButton;
    LMDButton2                      : TLMDButton;
    LMDButton3                      : TLMDButton;
    LMDButtonAll                    : TLMDButton;
    LMDButtonAlvh                   : TLMDButton;
    LMDButtonApt                    : TLMDButton;
    LMDButtonAsc                    : TLMDButton;
    LMDButtonCir                    : TLMDButton;
    LMDButtonEdf                    : TLMDButton;
    LMDButtonLvh                    : TLMDButton;
    LMDButtonLvs                    : TLMDButton;
    LMDButtonNet                    : TLMDButton;
    LMDButtonSch                    : TLMDButton;
    LMDButtonSp                     : TLMDButton;
    LMDButtonSpi                    : TLMDButton;
    LMDButtonSym                    : TLMDButton;
    LMDButtonV                      : TLMDButton;
    LMDDockPanelAPT                 : TLMDDockPanel;
    LMDDockPanelAssura              : TLMDDockPanel;
    LMDDockPanelBottom              : TLMDDockPanel;
    LMDDockPanelCalibre             : TLMDDockPanel;
    LMDDockPanelDracula             : TLMDDockPanel;
    LMDDockPanelExplorer            : TLMDDockPanel;
    LMDDockPanelHSpice              : TLMDDockPanel;
    LMDDockPanelLTspice             : TLMDDockPanel;
    LMDDockPanelProcess             : TLMDDockPanel;
    LMDDockPanelPSpice              : TLMDDockPanel;
    LMDDockPanelSetup               : TLMDDockPanel;
    LMDDockPanelTools               : TLMDDockPanel;
    LMDDockSiteMain                 : TLMDDockSite;
    LMDGroupBoxAPT                  : TLMDGroupBox;
    LMDGroupBoxAssura               : TLMDGroupBox;
    LMDGroupBoxDracula              : TLMDGroupBox;
    LMDGroupBoxHSpice               : TLMDGroupBox;
    LMDGroupBoxLTspice              : TLMDGroupBox;
    LMDGroupBoxPSpice               : TLMDGroupBox;
    LMDMRUListMain                  : TLMDMRUList;
    LMDShellLink1                   : TLMDShellLink;
    LMDStarterArchive               : TLMDStarter;
    LMDTaskDialogMain               : TLMDTaskDialog;
    LTC1                            : TMenuItem;
    LTCBackannotation1              : TMenuItem;
    LTCSim1                         : TMenuItem;
    LTCSim2                         : TMenuItem;
    LTCSimuserguide1                : TMenuItem;
    LTCSimuserguidepdf1             : TMenuItem;
    LTSExporer1                     : TMenuItem;
    MainMenu                        : TMainMenu;
    Migrateschematics2              : TMenuItem;
    ModifySchematics1               : TMenuItem;
    N1                              : TMenuItem;
    N10                             : TMenuItem;
    N12                             : TMenuItem;
    N13                             : TMenuItem;
    N14                             : TMenuItem;
    N2                              : TMenuItem;
    N22                             : TMenuItem;
    N28                             : TMenuItem;
    N3                              : TMenuItem;
    N4                              : TMenuItem;
    N5                              : TMenuItem;
    N6                              : TMenuItem;
    N7                              : TMenuItem;
    N8                              : TMenuItem;
    N9                              : TMenuItem;
    Navigate1                       : TMenuItem;
    Navigateschematics1             : TMenuItem;
    Netlist1                        : TMenuItem;
    Netlist2                        : TMenuItem;
    NetlistSimulate1                : TMenuItem;
    New1                            : TMenuItem;
    New2                            : TMenuItem;
    Newfolder1                      : TMenuItem;
    NewRev1                         : TMenuItem;
    oASCII1                         : TMenuItem;
    oASCII2                         : TMenuItem;
    Open1                           : TMenuItem;
    Open2                           : TMenuItem;
    Open3                           : TMenuItem;
    OpenDialog                      : TOpenDialog;
    PageControlTools                : TPageControl;
    Panel4                          : TPanel;
    PanelLTCSimOptions1             : TPanel;
    PanelLTCSimOptions2             : TPanel;
    PanelMainList                   : TPanel;
    PanelMainTree                   : TPanel;
    pAPT1                           : TMenuItem;
    Paste2                          : TMenuItem;
    PopupMenuFileList               : TPopupMenu;
    PopupMenuFileListStyle          : TPopupMenu;
    PopupMenuFileTree               : TPopupMenu;
    PopupMenuSchem                  : TPopupMenu;
    PopupMenuStim                   : TPopupMenu;
    PopupMenuTray                   : TPopupMenu;
    ProjectArchiveMain              : TAction;
    ProjectInitialize2              : TAction;
    ProjectNew                      : TAction;
    ProjectNewRev                   : TAction;
    ProjectOpen                     : TAction;
    ProjectReOpen                   : TMenuItem;
    ProjectSave                     : TAction;
    RadioGroupLTspiceSyntax         : TRadioGroup;
    RenameSchematicSymbols1         : TMenuItem;
    Restartlicense1                 : TMenuItem;
    rgArchiveNetlist                : TRadioGroup;
    Save1                           : TMenuItem;
    Schematics1                     : TMenuItem;
    SchematicsSnapshot              : TAction;
    SchematicsToAPT                 : TAction;
    SchematicstoASCII1              : TMenuItem;
    Selectall2                      : TMenuItem;
    Server2                         : TMenuItem;
    Simulate1                       : TMenuItem;
    Simulate2                       : TMenuItem;
    Smallicons2                     : TMenuItem;
    Snapshot2                       : TMenuItem;
    SnapshotViewer                  : TAction;
    Snapshotviewer2                 : TMenuItem;
    Splitter2                       : TSplitter;
    Start1                          : TMenuItem;
    Start2                          : TMenuItem;
    Start3                          : TMenuItem;
    Start4                          : TMenuItem;
    Start5                          : TMenuItem;
    STart6                          : TMenuItem;
    Start7                          : TMenuItem;
    Start8                          : TMenuItem;
    Start9                          : TMenuItem;
    Stop1                           : TMenuItem;
    Sxchematics1                    : TMenuItem;
    Symbol1                         : TMenuItem;
    SymbolstoASCII1                 : TMenuItem;
    TabSheet10                      : TTabSheet;
    TabSheet5                       : TTabSheet;
    TabSheet6                       : TTabSheet;
    TabSheet7                       : TTabSheet;
    TabSheet8                       : TTabSheet;
    TabSheet9                       : TTabSheet;
    ToolBar1                        : TToolBar;
    ToolBarFileList                 : TToolBar;
    ToolButton1                     : TToolButton;
    ToolButton10                    : TToolButton;
    ToolButton2                     : TToolButton;
    ToolButton3                     : TToolButton;
    ToolButton6                     : TToolButton;
    ToolButton7                     : TToolButton;
    ToolButton8                     : TToolButton;
    ToolButtonDirUp                 : TToolButton;
    TreePopupMenu                   : TPopupMenu;
    Uninstall1                      : TMenuItem;
    UpdateSchematics1               : TMenuItem;
    UserGuide1                      : TMenuItem;
    UserGuide2                      : TMenuItem;
    UserGuide3                      : TMenuItem;
    UserGuide4                      : TMenuItem;
    UserGuide5                      : TMenuItem;
    UseruideG1                      : TMenuItem;
    Utilities2                      : TMenuItem;
    Viewer2                         : TMenuItem;
    VNC2                            : TMenuItem;
    LMDDockPanelLSF: TLMDDockPanel;
    PanelLTCSimOptions3: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    eComputeServer: TEdit;
    eUserName: TEdit;
    bLSFUpdate: TButton;
    eUserPassword: TEdit;
    cmdConnect: TButton;
    procedure AboutLTCSimClick(Sender: TObject);
    procedure AboutProcessClick(Sender: TObject);
    procedure ActionAscToSchExecute(Sender: TObject);
    procedure ActionAsyToSymExecute(Sender: TObject);
    procedure ActionLibraryInitializeExecute(Sender: TObject);
    procedure ActionLibraryUpdateExecute(Sender: TObject);
    procedure ActionLTCSimExitExecute(Sender: TObject);
    procedure ActionProjectArchiveExecute(Sender: TObject);
    procedure ActionProjectInitializeExecute(Sender: TObject);
    procedure ActionProjectNewExecute(Sender: TObject);
    procedure ActionProjectNewRevExecute(Sender: TObject);
    procedure ActionProjectOpenExecute(Sender: TObject);
    procedure ActionProjectSaveExecute(Sender: TObject);
    procedure ActionRestartCohesionLicenseExecute(Sender: TObject);
    procedure ActionSchematicsEditExecute(Sender: TObject);
    procedure ActionSchematicsNavigateExecute(Sender: TObject);
    procedure ActionSchematicsNewExecute(Sender: TObject);
    procedure ActionSchematicsOpenExecute(Sender: TObject);
    procedure ActionSchematicsSnapshotExecute(Sender: TObject);
    procedure ActionSchematicsToAPTExecute(Sender: TObject);
    procedure ActionSchToAscExecute(Sender: TObject);
    procedure ActionSnapshotViewerExecute(Sender: TObject);
    procedure ActionSymToAsyExecute(Sender: TObject);
    procedure ActionSynIniEditorExecute(Sender: TObject);
    procedure cbSaveActiveProjectClick(Sender: TObject);
    procedure cbToolChange(Sender: TObject);
    procedure CheckCurrrentProcessVersion;
    procedure CohesionArchive(sSchematics: string);
    procedure CohesionUserGuideClick(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure Control1Click(Sender: TObject);
    procedure CopyOldFiles;
    procedure CreateDirectories;
    procedure CreateIniFile;
    procedure CreateStimFile(sStimFileName: string; sSimulator: string);
    procedure CreateSynarioFiles;
    procedure Delete1Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure DetailsClick(Sender: TObject);
    procedure DisplayHideattributesDlg(Sender: TObject);
    procedure EditFile(sFileName: string);
    function EditSchematics(sFileName: string): Boolean;
    procedure EditStimulus;
    function EditSymbol(sFileName: string): Boolean;
    procedure eFileBrowserFilterChange(Sender: TObject);
    procedure eLTCSimOptionsChange(Sender: TObject);
    procedure EraseLibraryFiles;
    procedure ExtractAllSchematics;
    procedure FolderBackwardExecute(Sender: TObject);
    procedure FolderForwardExecute(Sender: TObject);
    procedure FolderUpExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InitializeForm;
    procedure InitializeLibrary;
    procedure Install1Click(Sender: TObject);
    procedure InstallLicense1Click(Sender: TObject);
    procedure InstallSoftware1Click(Sender: TObject);
    procedure ipwPingError(Sender: TObject; ErrorCode: Integer; const
        Description: string);
    procedure JamDropFileSchDrop(Sender: TObject; KeyState: TShiftState;
        MousePos: TPoint; var JamDropEffect: TJamDropEffect);
    procedure JamDropFilesStimDrop(Sender: TObject; KeyState: TShiftState;
        MousePos: TPoint; var JamDropEffect: TJamDropEffect);
    procedure JSDialogMainDialogClose(Sender: TJSCustomDialog);
    function libraryDBAvailable: Boolean;
    procedure LMDButtonFilter(Sender: TObject);
    procedure LMDMRUListClick(Sender: TObject; const aValue: string; var
        Remove: Boolean);
    procedure LTCSimArchiveNetlist(sSchematics: string);
    procedure LTCSimArchiveSnapshot(sSchematics: string);
    procedure LTCSimNewProject;
    procedure LTCSimOptionsChange(Sender: TObject);
    procedure LTCSimProjectOpen;
    procedure LTCSimUserGuideClick(Sender: TObject);
    procedure MenuButtonTopFormClick(Sender: TObject);
    procedure MigrateGlobalSignals(sOldSchemDir, sNewSchemDir, sOldRev,
        sNewRev: string);
    procedure MigrateLibFilesToNewRev(sOldRevDir, sNewRevDir: string);
    procedure MigrateProjectIniFileToNewrev(sOldSchemDir, sNewSchemDir: string);
    procedure MigrateSetupIniFileToNewrev(sOldSchemDir, sNewSchemDir: string);
    procedure ModifyECSRegistry(sKey, sString, sValue: string);
    procedure ModifyProjectIniFile(sKey, sString, sValue: string);
    function NavigateSchematics(sFileName: string): Boolean;
    function NetworkAvailable: Boolean;
    procedure OpenProjectRevClick(Sender: TObject);
    procedure OpenUpdateSchematicsDlg(Sender: TObject);
    procedure ProcessInformationClick(Sender: TObject);
    procedure ProjectArchive(sZipFileName: string);
    procedure ProjectCreateNewRevFromExistingRev;
    procedure ProjectCreateNewRevFromServer;
    procedure ReadLTCSimOptions(sLTCSimOptionsFile: String);
    procedure ReadLTCSimSites(sLTCSimSitesFile: String);
    procedure ReadOldLTCSimOptions;
    procedure ReadProjectSetupFile;
    procedure ReadSetupFile6;
    procedure ReadXMLFile71;
    procedure ReadXMLFileSetup6;
    procedure runEdifNetlist(bView: bool; sSchematicsFile: string);
    procedure runHSpice(sSimulationFile: string);
    procedure runLTCSimNetlist(sSchematicsFile: string; bDisplay, bSimulate:
        Boolean);
    procedure runLTspice(sSimulationFile: string);
    procedure runLTspiceNetlist(sSchematics: string);
    procedure runPSpice(sSimulationFile: string);
    procedure runSCSNavigator(sSchematicFile: string);
    procedure runSCSSchEditor(sSchematicFile: string);
    procedure runSCSSymEditor(sSchematicFile: string);
    procedure runSimulation(sSimulationFile: string);
    procedure SaveActiveProjectInformation;
    procedure SaveActiveProjectToReg;
    procedure SaveLTCSimOptions(sLTCSimOptionsFile: String);
    procedure SaveLTspiceIniFile;
    procedure SaveXMLFile71;
    procedure SetDirectoryBrowsers(Directory: string);
    procedure SimulateClick(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure StartECSIniEditor;
    procedure StartListMenu(Sender: TObject);
    procedure StartSCSShell;
    procedure Stop1Click(Sender: TObject);
    procedure StopSCSShell;
    function TimeDelay(seconds: DWORD): Boolean;
    procedure ToolButtonBckClick(Sender: TObject);
    procedure ToolButtonTopFormClick(Sender: TObject);
    procedure TransferAndBuildFiles(sIniFile, DirectoryDest: string);
    function TransferFileList(StringOfFiles: TStringList; DirectorySource,
        DirectoryDest: string): Integer;
    procedure TransferSymbols;
    procedure Uninstall1Click(Sender: TObject);
    procedure UpdateFormComponents;
    procedure UpdateProjectVariables;
    procedure UtilitiesRun(Sender: TObject);
    function ValidateSearchPath: Boolean;
    function ValidProject: Boolean;
    function ValidString(sCharacters: string): Boolean;
    procedure Viewer2Click(Sender: TObject);
    function WindowsName(FileName: string): string;
  end;

  ProjectRecord = record
    Name                 : string;
    Rev                  : string;
    newRev               : string;
    oldRev               : string;
    Dir                  : string;
    LibDir               : string;
    SetupFile            : string;
    XMLSetupFile6        : string;
    XMLSetupFile71       : string;
    XSDFile              : string;
    oldSetupFile         : string;
    RevDir               : string;
    newRevDir            : string;
    oldRevDir            : string;
    SchemDir             : string;
    newSchemDir          : string;
    oldSchemDir          : string;
    IniFileName          : string;
    LTspiceIniFileName   : string;
    SimulationDir        : string;
    xmlSimulationDir     : string;
    NetlistDir           : string;
    WorkingDir           : string;
    SCSWindowHandle      : THandle;
    DesignSettingsIniFile: string;
    topLVSSchematics     : string;
    projectsDirPath      : string;
    cohesionDir          : string;
    genericVersion       : string;
    ignoreCase           : Boolean;
    currentSchematics    : string;
    currentStimulus      : string;
    currentTool          : string;
    lSchematicsUsed      : TStringList;
    lStimulusUsed        : TStringList;
    primitiveReport      : Boolean;
    zipFileName          : string;
    ltspiceGND           : Boolean;
    ltspiceXGNDX         : Boolean;
    ltspiceOmitPrefix    : Boolean;
    ltspiceShrink        : Boolean;
    ltspiceSubCircuit    : Boolean;
    ltspiceschematics    : Boolean;
    ltspiceLeftBracket   : string;
    ltspiceRightBracket  : string;
    ltspiceCommand       : string;
    ltspiceCommandOptions: string;
    ltspiceSyntax        : Integer;
    pspiceGND            : Boolean;
    pspiceXGNDX          : Boolean;
    pspiceOmitPrefix     : Boolean;
    pspiceShrink         : Boolean;
    pspiceSubCircuit     : Boolean;
    pspiceAD             : Boolean;
    pspiceLeftBracket    : string;
    pspiceRightBracket   : string;
    pspiceCommand        : string;
    pspiceCommandOptions : string;
    pspiceViewer         : string;
    pspiceViewerOptions  : string;
    hspiceGND            : Boolean;
    hspiceXGNDX          : Boolean;
    hspiceOmitPrefix     : Boolean;
    hspiceShrink         : Boolean;
    hspiceSubCircuit     : Boolean;
    hspiceVerilogA       : Boolean;
    hspiceLeftBracket    : string;
    hspiceRightBracket   : string;
    hspiceCommand        : string;
    hspiceCommandOptions : string;
    hspiceViewer         : string;
    hspiceViewerOptions  : string;
    aptBipolarArea       : Boolean;
    aptBipolarWL         : Boolean;
    aptGND               : Boolean;
    aptXGNDX             : Boolean;
    aptOmitPrefix        : Boolean;
    aptShrink            : Boolean;
    aptSubCircuit        : Boolean;
    aptLeftBracket       : string;
    aptRightBracket      : string;
    aptShort             : string;
    assuraBipolarArea    : Boolean;
    assuraBipolarWL      : Boolean;
    assuraGND            : Boolean;
    assuraXGNDX          : Boolean;
    assuraOmitPrefix     : Boolean;
    assuraShrink         : Boolean;
    assuraSubCircuit     : Boolean;
    assuraLeftBracket    : string;
    assuraRightBracket   : string;
    assuraShort          : string;
    draculaBipolarArea   : Boolean;
    draculaBipolarWL     : Boolean;
    draculaGND           : Boolean;
    draculaXGNDX         : Boolean;
    draculaOmitPrefix    : Boolean;
    draculaShrink        : Boolean;
    draculaSubCircuit    : Boolean;
    draculaLeftBracket   : string;
    draculaRightBracket  : string;
    draculaShort         : string;
  end;

  ProcessRecord = record
    Name           : string;
    Rev            : string;
    Promis         : string;
    option1        : string;
    option1Name    : string;
    option1Code    : string;
    option2        : string;
    option2Name    : string;
    option2Code    : string;
    GenericRev     : string;
    Process_Id     : Double;
    ProcessInfoDir : string;
    ProcessInfoFile: string;
  end;

  LTCSimRecord = record
    Dir                 : string;
    designer6Dir        : string;
    cohesionDir         : string;
    libraryDir          : string;
    xmlFileName         : string;
    xmlSitesFile        : string;
    ArchiveNetlistIndex : Integer;
    AssuraToLayout      : Boolean;
    DraculaToLayout     : Boolean;
    lTools              : TStringList;
    lSites              : TStringList;
    dbServer            : string;
    localProjectsDir    : string;
    localSiteProjectsDir: string;
    librariesServer     : string;
    shellLicenseStarted : Boolean;
  end;

  TTool = (LTspice, PSpice, HSpice, APT, Assura, Dracula, Verilog, Edif);

var
  MainForm               : TMainForm;
  Project                : ProjectRecord;
  Process                : ProcessRecord;
  LTCSim                 : LTCSimRecord;
  ToolInUse              : TTool;
  sSchFileName           : string;
  sWindowsDir            : string;
  debugMode              : Boolean;
  sSynarioDir            : string;
  sLibraryDir            : string;
  Version                : string;
  bCheckWarningMessage   : Boolean;
  sECSRegistryIniFileName: string;
  CohesionShellHandle    : THandle;
  bNetlistSim            : Boolean;
  LTCSimVersion          : Double;
  bNetworkAvailable      : Boolean;
  cadMode                : Boolean;
  HDSShellHandle         : THandle;

implementation

uses
  ProcessDialog,
  Rename,
  StimDlg,
  UpdateWarning,
  newRev,
  SchemToAscii,
  AscciToSchem,
  SymToAsy,
  AsyToSymbols,
  DataModule,
  NewRevWithoutProcessCode,
  LTCSimArchive,
  UpdateSchematics,
  DisplayHideAttr;

{$R *.DFM}

const
  lMRStr: array [0 .. 10] of string = ('mrNone', 'mrOk', 'mrCancel', 'mrAbort',
    'mrRetry', 'mrIgnore', 'mrYes', 'mrNo', 'mrAll', 'mrNoToAll', 'mrYesToAll');
  BoolStr: array [Boolean] of string = ('False', 'True');

{
********************************** TMainForm ***********************************
}
procedure TMainForm.AboutLTCSimClick(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'AboutLTCSimClick');

  LMDAboutDlg.Appname := 'LTCSim';
  LMDAboutDlg.CaptionTitle := 'About LTCSim...';
  LMDAboutDlg.EMail := 'gergueta@linear.com';
  LMDAboutDlg.Copyright := 'Linear Technology Corp.';
  LMDAboutDlg.Execute;

  CodeSite.ExitMethod(Self, 'AboutLTCSimClick');
end;

procedure TMainForm.AboutProcessClick(Sender: TObject);
var
  sFileName: string;
begin
  CodeSite.EnterMethod(Self, 'AboutProcessClick');

  sFileName := IncludeTrailingPathDelimiter(sLibraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'help\' + Process.Name + '.hlp';
  if FileExists(sFileName) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sFileName), nil, nil,
      SW_NORMAL)
  else
    MessageDlg('Not available on this process yet!', mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'AboutProcessClick');
end;

procedure TMainForm.ActionAscToSchExecute(Sender: TObject);
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  sDirectoryPath: string;
begin
  CodeSite.EnterMethod(Self, 'ActionAscToSchExecute');

  if ValidProject() then
  begin
    ASCIIToSchemForm.JamFileListAsc.Stop;
    ASCIIToSchemForm.JamFileListAsc.Clear;
    ASCIIToSchemForm.JamFileListAsc.SearchOptions.Filter := '*.asc';
    ASCIIToSchemForm.JamFileListAsc.SearchOptions.RecursiveSearch := False;
    lInfo := TStringList.Create;
    ProjectIniFile := TIniFile.Create(Project.IniFileName);
    try
      ProjectIniFile := TIniFile.Create(Project.IniFileName);
      ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
      if (lInfo.Count > 0) then
      begin
        for I := 0 to (lInfo.Count - 1) do
        begin
          sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
          if (System.Pos('$(projects)', sDirectoryPath) > 0) then
          begin
            sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
              '$(projects)', LowerCase(LTCSim.localProjectsDir),
              [rfIgnoreCase, rfReplaceAll]);
          end;
          ASCIIToSchemForm.JamFileListAsc.Search(sDirectoryPath);
        end
      end;
      lInfo.Clear;
    finally
      ProjectIniFile.Free;
      lInfo.Free;
    end;
    ASCIIToSchemForm.ShowModal;
    ASCIIToSchemForm.JamFileListAsc.Stop;
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionAscToSchExecute');
end;

procedure TMainForm.ActionAsyToSymExecute(Sender: TObject);
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  sDirectoryPath: string;
begin
  CodeSite.EnterMethod(Self, 'ActionAsyToSymExecute');

  if ValidProject() then
  begin
    AsyToSymForm.JamFileListAsy.Stop;
    AsyToSymForm.JamFileListAsy.Clear;
    AsyToSymForm.JamFileListAsy.SearchOptions.Filter := '*.asy';
    AsyToSymForm.JamFileListAsy.SearchOptions.RecursiveSearch := False;
    lInfo := TStringList.Create;
    ProjectIniFile := TIniFile.Create(Project.IniFileName);
    try
      ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
      if (lInfo.Count > 0) then
      begin
        for I := 0 to (lInfo.Count - 1) do
        begin
          sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
          if (System.Pos('$(projects)', sDirectoryPath) > 0) then
          begin
            sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
              '$(projects)', LowerCase(LTCSim.localProjectsDir),
              [rfIgnoreCase, rfReplaceAll]);
          end;
          AsyToSymForm.JamFileListAsy.Search(sDirectoryPath);
        end
      end;
      lInfo.Clear;
    finally
      ProjectIniFile.Free;
      lInfo.Free;
    end;
    AsyToSymForm.ShowModal;
    AsyToSymForm.JamFileListAsy.Stop;
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionAsyToSymExecute');
end;

procedure TMainForm.ActionLibraryInitializeExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionLibraryInitializeExecute');

  if ValidProject then
  begin
    if NetworkAvailable then
    begin
      if (MessageDlg('Are you sure you want to initialize the library?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        if libraryDBAvailable then
        begin
          StopSCSShell;
          try
            Screen.Cursor := crHourGlass;
            if (LibraryDatabase.UniConnectionLTCSim.Connected) then
              InitializeLibrary
            else
              MessageDlg
                ('Problems connecting to local server. Please get CAD support (Can not open DB)!',
                mtError, [mbOK], 0);
          finally
            Screen.Cursor := crDefault;
          end
        end
      end
    end
    else
      MessageDlg('Server not available!', mtError, [mbOK], 0);
  end
  else
    MessageDlg('You need to have a valid project loaded first!', mtError,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionLibraryInitializeExecute');
end;

procedure TMainForm.ActionLibraryUpdateExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionLibraryUpdateExecute');

  if ValidProject then
  begin
    if NetworkAvailable then
    begin
      if libraryDBAvailable then
      begin
        StopSCSShell;
        try
          Screen.Cursor := crHourGlass;
          if (LibraryDatabase.UniConnectionLTCSim.Connected) then
          begin
            PagesDlg.eProjectName.Enabled := False;
            PagesDlg.eProjectRev.Enabled := False;
            PagesDlg.eProjectName.Color := clInactiveBorder;
            PagesDlg.eProjectRev.Color := clInactiveBorder;
            PagesDlg.eProjectName.Text := Project.Name;
            PagesDlg.eProjectRev.Text := Project.Rev;
            if (PagesDlg.ShowModal = mrOk) then
            begin
              LTCSimNewProject;
              StartSCSShell;
            end;
          end
          else
          begin
            MessageDlg
              ('Problems connecting to local server. Please get CAD support (Can not open DB)!',
              mtError, [mbOK], 0);
          end
        finally
          Screen.Cursor := crDefault;
        end
      end
    end
    else
      MessageDlg('Server not available!', mtError, [mbOK], 0);
  end
  else
    MessageDlg('You need an existing project already opened!', mtInformation,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionLibraryUpdateExecute');
end;

procedure TMainForm.ActionLTCSimExitExecute(Sender: TObject);
begin
      { TMainForm.FileExit }
  CodeSite.EnterMethod(Self, 'ActionLTCSimExitExecute');

  StopSCSShell;
  SaveLTCSimOptions(LTCSim.xmlFileName);
  Application.Terminate;

  CodeSite.ExitMethod(Self, 'ActionLTCSimExitExecute');
end;

procedure TMainForm.ActionProjectArchiveExecute(Sender: TObject);
var
  sZipFileName: string;
begin
  CodeSite.EnterMethod(Self, 'ActionProjectArchiveExecute');

  if ValidProject then
  begin
    sZipFileName := IncludeTrailingPathDelimiter(LTCSim.localProjectsDir) +
      IncludeTrailingPathDelimiter(Project.Name) + Project.Name + '_' +
      Project.Rev + '_archive.zip';
    ProjectArchive(sZipFileName);
  end
  else
    MessageDlg('You need to have a valid project loaded first!', mtError,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionProjectArchiveExecute');
end;

procedure TMainForm.ActionProjectInitializeExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionProjectInitializeExecute');

  if ValidProject then
  begin
    if NetworkAvailable then
    begin
      if (MessageDlg('Are you sure you want to initialize the project?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        if libraryDBAvailable then
        begin
          StopSCSShell;
          try
            Screen.Cursor := crHourGlass;
            if (LibraryDatabase.UniConnectionLTCSim.Connected) then
            begin
              EraseLibraryFiles;
              CreateDirectories;
              CreateSynarioFiles;
              TransferSymbols;
              UpdateProjectVariables;
              AppIcons.IconModule.LMDMRUList.Add
                (ExtractFileDir(Project.SetupFile));
              SetDirectoryBrowsers(Project.SimulationDir);
              SaveActiveProjectInformation;
              StartSCSShell;
            end
            else
              MessageDlg
                ('Problems connecting to local server. Please get CAD support (Can not open DB)!',
                mtError, [mbOK], 0);
          finally
            Screen.Cursor := crDefault;
          end
        end
      end
    end
    else
      MessageDlg('Server not available!', mtError, [mbOK], 0)
  end
  else
    MessageDlg('You need to have a valid project loaded first!', mtError,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionProjectInitializeExecute');
end;

procedure TMainForm.ActionProjectNewExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionProjectNewExecute');

  if (LTCSim.localProjectsDir = '') then
  begin
    MessageDlg('"PROJECTS" variable not defined!', mtError, [mbOK], 0);
    Screen.Cursor := crDefault;
    Abort
  end;
  if libraryDBAvailable then
  begin
    StopSCSShell;
    try
      Screen.Cursor := crHourGlass;
      if (LibraryDatabase.UniConnectionLTCSim.Connected) then
      begin
        PagesDlg.eProjectName.Enabled := true;
        PagesDlg.eProjectName.Color := clWindow;
        PagesDlg.eProjectName.Clear;
        PagesDlg.eProjectRev.Enabled := true;
        PagesDlg.eProjectRev.Color := clWindow;
        PagesDlg.eProjectRev.Clear;
        PagesDlg.ActiveControl := PagesDlg.eProjectName;
        if (PagesDlg.ShowModal = mrOk) then
        begin
          if (ValidString(PagesDlg.eProjectName.Text) and
            ValidString(PagesDlg.eProjectRev.Text)) then
          begin
            LTCSimNewProject;
            StartSCSShell;
          end
          else
            MessageDlg
              ('Problems with Project Name or Project Rev using illegal characters!',
              mtError, [mbOK], 0);
        end;
      end
      else
        MessageDlg
          ('Problems connecting to local library server. Please get CAD support (Can not open DB)!',
          mtError, [mbOK], 0);
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
    MessageDlg
      ('Problems connecting to local library server. Please get CAD support (Can not open DB)!',
      mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionProjectNewExecute');
end;

procedure TMainForm.ActionProjectNewRevExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionProjectNewRevExecute');

  if ValidProject then
  begin
    NewRevForm.eOldRev.Text := Project.Rev;
    if (NewRevForm.ShowModal = mrOk) then
    begin
      Project.newRev := NewRevForm.EditNewRev.Text;
      Project.newRevDir := IncludeTrailingPathDelimiter(Project.Dir) +
        Project.newRev;
      Project.newSchemDir := IncludeTrailingPathDelimiter(Project.newRevDir)
        + 'schem';
      Project.oldRev := Project.Rev;
      Project.oldRevDir := Project.RevDir;
      Project.oldSchemDir := Project.SchemDir;
      if NewRevForm.LMDRadioGroupUpdateFromServer.ItemIndex = 0 then
      begin
        if NetworkAvailable then
          ProjectCreateNewRevFromServer
        else
          MessageDlg('Network not available!', mtInformation, [mbOK], 0);
      end
      else
        ProjectCreateNewRevFromExistingRev;
    end;
  end
  else
  begin
    MessageDlg('You need an existing project already opened!', mtInformation,
      [mbOK], 0);
    Screen.Cursor := crDefault;
  end;

  CodeSite.ExitMethod(Self, 'ActionProjectNewRevExecute');
end;

procedure TMainForm.ActionProjectOpenExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionProjectOpenExecute');

  AppIcons.IconModule.JamBrowseForFolder.RootedAtFileSystemFolder :=
    LTCSim.localProjectsDir;
  AppIcons.IconModule.JamBrowseForFolder.Title :=
    'Select a valid revision directory';
  AppIcons.IconModule.JamBrowseForFolder.WindowTitle :=
    'LTCSim - Projects directory';
  if AppIcons.IconModule.JamBrowseForFolder.Execute then
  begin
    Project.RevDir := AppIcons.IconModule.JamBrowseForFolder.Path;
    Project.Dir := ExcludeTrailingPathDelimiter
      (ExtractFilePath(Project.RevDir));
    ReadProjectSetupFile;
  end;
  if (ValidateSearchPath()) then
  begin
    LTCSimProjectOpen;
  end
  else
  begin
    if (MessageDlg
      ('You have ilegal directories in use( outside the local project directory). Issue with archiving. Please move directories if needed inside local project',
      mtError, [mbYes, mbNo], 0) = mrYes) then
      StartECSIniEditor();
  end;

  CodeSite.ExitMethod(Self, 'ActionProjectOpenExecute');
end;

procedure TMainForm.ActionProjectSaveExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionProjectSaveExecute');

  if ValidProject then
  begin
    SaveActiveProjectInformation
  end
  else
    MessageDlg('You need to have a valid project loaded first!', mtError,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionProjectSaveExecute');
end;

procedure TMainForm.ActionRestartCohesionLicenseExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionRestartCohesionLicenseExecute');

  AppIcons.IconModule.LMDStarterShell.TerminateProcess;
  StartSCSShell;

  CodeSite.ExitMethod(Self, 'ActionRestartCohesionLicenseExecute');
end;

procedure TMainForm.ActionSchematicsEditExecute(Sender: TObject);
var
  sSchematicsFile, sFileExtension: String;
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsEditExecute');

  // Edit schematics from cbSchematics
  sFileExtension := '.sch';
  sSchematicsFile := cbSchematics.Text + sFileExtension;
  EditSchematics(sSchematicsFile);

  CodeSite.ExitMethod(Self, 'ActionSchematicsEditExecute');
end;

procedure TMainForm.ActionSchematicsNavigateExecute(Sender: TObject);
var
  sSchematicsFile, sFileExtension: String;
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsNavigateExecute');

  sFileExtension := '.sch';
  sSchematicsFile := cbSchematics.Text + sFileExtension;
  NavigateSchematics(sSchematicsFile);

  CodeSite.ExitMethod(Self, 'ActionSchematicsNavigateExecute');
end;

procedure TMainForm.ActionSchematicsNewExecute(Sender: TObject);
var
  sCommand: string;
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsNewExecute');

  { Starting schematic editor }
  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'schem.exe';
  ShellExecute(MainForm.Handle, 'open', PChar(sCommand), nil,
    PChar(Project.SchemDir), SW_SHOWNORMAL);

  CodeSite.ExitMethod(Self, 'ActionSchematicsNewExecute');
end;

procedure TMainForm.ActionSchematicsOpenExecute(Sender: TObject);
var
  sCommand: string;
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsOpenExecute');

  SetCurrentDirectory(PChar(Project.SchemDir));
  OpenDialog.InitialDir := Project.SchemDir;
  OpenDialog.Filter := 'Schematic files (*.sch)|*.SCH';
  if OpenDialog.Execute then
  begin
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'schem.exe';
    ShellExecute(MainForm.Handle, 'open', PChar(sCommand),
      PChar(ExtractFileName(OpenDialog.FileName)),
      PChar(ExtractFileDir(OpenDialog.FileName)), SW_SHOWNORMAL);
  end;

  CodeSite.ExitMethod(Self, 'ActionSchematicsOpenExecute');
end;

procedure TMainForm.ActionSchematicsSnapshotExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsSnapshotExecute');

  if ValidProject then
  begin
    SetCurrentDirectory(PChar(Project.SchemDir));
    OpenDialog.InitialDir := Project.SchemDir;
    // OpenDialog.Filter := 'Schematic files (*.tre)|*.TRE';
    OpenDialog.Filter := 'Schematic files (*.sch)|*.SCH';
    if OpenDialog.Execute then
    begin
      LTCSimArchiveSnapshot(OpenDialog.FileName);
    end;
  end
  else
    MessageDlg('You  need to have a valid project loaded.', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionSchematicsSnapshotExecute');
end;

procedure TMainForm.ActionSchematicsToAPTExecute(Sender: TObject);
var
  sTopSchematics: string;
  sLayoutSchematicsDirectory, sNetzFileName, sNewNetzFileName, sCommand, sTemp,
    sDate, sTime, sArgument, sNewAPTNetlistFile, sNewDraculaOrAssuraFile,
    sWorkingDir, sAPTNetlistFile, sDraculaOrAssuraFile, sTreFile: string;
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  tempToolInUse: TTool;
begin
  CodeSite.EnterMethod(Self, 'ActionSchematicsToAPTExecute');

  { Copy schematics to layout }
  if ValidProject then
  begin
    OpenDialog.Title := 'Top schematics for layout to use:';
    OpenDialog.DefaultExt := 'sch';
    OpenDialog.Filter := 'Schematic files (*.sch)|*.SCH';
    OpenDialog.InitialDir := IncludeTrailingPathDelimiter
      (LTCSim.localProjectsDir) + IncludeTrailingPathDelimiter(Project.Name) +
      IncludeTrailingPathDelimiter(Project.Rev) + 'schem';
    OpenDialog.Options := [ofReadOnly, ofNoChangeDir, ofFileMustExist,
      ofHideReadOnly];
    if OpenDialog.Execute then
    begin
      Screen.Cursor := crHourGlass;
      sTopSchematics := OpenDialog.FileName;
      sTreFile := ChangeFileExt(sTopSchematics, '.tre');
      if not FileExists(sTreFile) then
      begin
        MessageDlg
          (Format('File %s can not be found!. Generate it from the Navigator.',
          [sTreFile]), mtError, [mbOK], 0);
        Abort
      end;
      if DirectoryExists(LTCSim.localSiteProjectsDir) then
      begin
        { Generate APT netlist }
        tempToolInUse := ToolInUse;
        ToolInUse := APT;
        sAPTNetlistFile := ChangeFileExt(sTopSchematics, '.apt');
        sDraculaOrAssuraFile := ChangeFileExt(sTopSchematics, '.net');
        sNetzFileName := ChangeFileExt(sTopSchematics, '.netz');
        SaveActiveProjectInformation;
        if FileExists(sTopSchematics) then
        begin
          runLTCSimNetlist(sTopSchematics, False, False);
          { Generate Assura or Dracula netlist selected in the options tab }
          if rgArchiveNetlist.ItemIndex = 0 then
            ToolInUse := Assura
          else
            ToolInUse := Dracula;
          SaveActiveProjectInformation;
          runLTCSimNetlist(sTopSchematics, False, False);
          LTCSimArchiveNetlist(sTopSchematics);
        end
        else
        begin
          MessageDlg('Schematics file [' + sTopSchematics + '] not available',
            mtError, [mbOK], 0);
          Abort;
        end;
        { Generate Dracula/Assura netlist }
        ToolInUse := tempToolInUse;
        SaveActiveProjectInformation;
        Screen.Cursor := crHourGlass;
        { Check Project Directory }
        sTemp := IncludeTrailingPathDelimiter(LTCSim.localSiteProjectsDir) +
          IncludeTrailingPathDelimiter(Project.Name);
        if not DirectoryExists(sTemp) then
          CreateDir(sTemp);
        { Check revision directory }
        sTemp := sTemp + IncludeTrailingPathDelimiter(Project.Rev);
        if not DirectoryExists(sTemp) then
          CreateDir(sTemp);
        { Check for schematics directory }
        DateTimeToString(sDate, '_mmddyy', Now);
        DateTimeToString(sTime, '_hhnn', Now);
        sTemp := sTemp + IncludeTrailingPathDelimiter
          (ChangeFileExt(ExtractFileName(sTopSchematics), '') + sDate + sTime);
        if not DirectoryExists(sTemp) then
          CreateDir(sTemp);
        sLayoutSchematicsDirectory := sTemp;
        { Select top schematics for layout to use }
        sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'archive.exe ';
        sArgument := ' -save=' + sLayoutSchematicsDirectory + ' ' +
          sTopSchematics;
        sWorkingDir := sLayoutSchematicsDirectory;
        FillChar(SEInfo, SizeOf(SEInfo), 0);
        SEInfo.cbSize := SizeOf(TShellExecuteInfo);
        with SEInfo do
        begin
          fMask := SEE_MASK_NOCLOSEPROCESS;
          Wnd := Application.Handle;
          lpFile := PChar(sCommand);
          lpParameters := PChar(sArgument);
          lpDirectory := PChar(sWorkingDir);
          nShow := SW_SHOWNORMAL;
        end;
        if ShellExecuteEx(@SEInfo) then
        begin
          repeat
            Application.ProcessMessages;
            GetExitCodeProcess(SEInfo.hProcess, ExitCode);
          until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
        end;
        { Copy APT netlist file to shared project directory }
        sNewAPTNetlistFile := IncludeTrailingPathDelimiter
          (sLayoutSchematicsDirectory) +
          ChangeFileExt(ExtractFileName(sTopSchematics), '.apt');
        if FileExists(sAPTNetlistFile) then
          CopyFile(PChar(sAPTNetlistFile), PChar(sNewAPTNetlistFile), true)
        else
        begin
          MessageDlg('File [' + sAPTNetlistFile + '] not found!', mtError,
            [mbOK], 0);
          Abort;
        end;
        { Copy NET netlist file to shared project directory }
        sNewDraculaOrAssuraFile := IncludeTrailingPathDelimiter
          (sLayoutSchematicsDirectory) +
          ChangeFileExt(ExtractFileName(sTopSchematics), '.net');
        if FileExists(sDraculaOrAssuraFile) then
          CopyFile(PChar(sDraculaOrAssuraFile),
            PChar(sNewDraculaOrAssuraFile), true)
        else
        begin
          MessageDlg('File [' + sDraculaOrAssuraFile + '] not found!', mtError,
            [mbOK], 0);
          Abort
        end;
        sNewNetzFileName := IncludeTrailingPathDelimiter
          (sLayoutSchematicsDirectory) +
          ChangeFileExt(ExtractFileName(sTopSchematics), '.netz');
        if FileExists(sNetzFileName) then
          CopyFile(PChar(sNetzFileName), PChar(sNewNetzFileName), true)
        else
        begin
          MessageDlg('File [' + sNetzFileName + '] not found!', mtError,
            [mbOK], 0);
          Abort;
        end
      end
      else
        MessageDlg('Directory ' + LTCSim.localSiteProjectsDir + ' not found!',
          mtError, [mbOK], 0);
      Screen.Cursor := crDefault;
    end;
  end
  else
    MessageDlg('You  need to have a valid project loaded.', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionSchematicsToAPTExecute');
end;

procedure TMainForm.ActionSchToAscExecute(Sender: TObject);
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  sDirectoryPath: string;
begin
  CodeSite.EnterMethod(Self, 'ActionSchToAscExecute');

  if ValidProject() then
  begin
    SchemToAsciiForm.JamFileListSch.Stop;
    SchemToAsciiForm.JamFileListSch.Clear;
    SchemToAsciiForm.JamFileListSch.SearchOptions.Filter := '*.sch';
    SchemToAsciiForm.JamFileListSch.SearchOptions.RecursiveSearch := False;
    lInfo := TStringList.Create;
    ProjectIniFile := TIniFile.Create(Project.IniFileName);
    try
      ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
      if (lInfo.Count > 0) then
      begin
        for I := 0 to (lInfo.Count - 1) do
        begin
          sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
          if (System.Pos('$(projects)', sDirectoryPath) > 0) then
          begin
            sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
              '$(projects)', LowerCase(LTCSim.localProjectsDir),
              [rfIgnoreCase, rfReplaceAll]);
          end;
          SchemToAsciiForm.JamFileListSch.Search(sDirectoryPath);
        end
      end;
      lInfo.Clear;
    finally
      ProjectIniFile.Free;
      lInfo.Free;
    end;
    SchemToAsciiForm.ShowModal;
    SchemToAsciiForm.JamFileListSch.Stop;
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionSchToAscExecute');
end;

procedure TMainForm.ActionSnapshotViewerExecute(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
  sSnapFileName, sSnapDir, sFilesDir: string;
  sTopSchematicsFile: string;
  archiver: TZipForge;
begin
  CodeSite.EnterMethod(Self, 'ActionSnapshotViewerExecute');

  SetCurrentDirectory(PChar(Project.SchemDir));
  OpenDialog.InitialDir := Project.SchemDir;
  OpenDialog.Filter := 'Schematic files (*.snap)|*.SNAP';
  if OpenDialog.Execute then
  begin
    sSnapFileName := OpenDialog.FileName;
    LMDBrowseDirDlg.CaptionTitle := 'Select directory to place Snapshot files';
    if LMDBrowseDirDlg.Execute then
      sSnapDir := LMDBrowseDirDlg.SelectedFolder;
    // Create an instance of the TZipForge class
    archiver := TZipForge.Create(nil);
    try
      with archiver do
      begin
        // The name of the archive file
        // from which we want to extract file
        FileName := sSnapFileName;
        // Because we extract file from an existing archive,
        // we set Mode to fmOpenRead
        OpenArchive(fmOpenRead);
        // Set base (default) directory for all archive operations
        BaseDir := sSnapDir;
        // Extract test.txt file from the archive
        // to the default directory
        ExtractFiles('*.*');
        sTopSchematicsFile := archiver.Comment;
        CloseArchive();
      end;
    except
      on E: Exception do
      begin
        Writeln('Exception: ', E.Message);
        // Wait for the key to be pressed
        Readln;
      end;
    end
  end;
  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'hiernav.exe';
  sFilesDir := IncludeTrailingPathDelimiter(sSnapDir) +
    ChangeFileExt(sTopSchematicsFile, '.dir');
  sArgument := '';
  // sArgument := ' -ini ' + IncludeTrailingPathDelimiter( sFilesDir ) + 'design_settings.ini ';
  // sArgument := sArgument + IncludeTrailingPathDelimiter( sFilesDir ) + sTopSchematicsFile;
  sWorkingDir := sFilesDir;
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'ActionSnapshotViewerExecute');
end;

procedure TMainForm.ActionSymToAsyExecute(Sender: TObject);
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  sDirectoryPath: string;
begin
  CodeSite.EnterMethod(Self, 'ActionSymToAsyExecute');

  if ValidProject() then
  begin
    SymToAsyForm.JamFileListSym.Stop;
    SymToAsyForm.JamFileListSym.Clear;
    SymToAsyForm.JamFileListSym.SearchOptions.Filter := '*.sym';
    SymToAsyForm.JamFileListSym.SearchOptions.RecursiveSearch := False;
    lInfo := TStringList.Create;
    ProjectIniFile := TIniFile.Create(Project.IniFileName);
    try
      ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
      if (lInfo.Count > 0) then
      begin
        for I := 0 to (lInfo.Count - 1) do
        begin
          sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
          if (System.Pos('$(projects)', sDirectoryPath) > 0) then
          begin
            sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
              '$(projects)', LowerCase(LTCSim.localProjectsDir),
              [rfIgnoreCase, rfReplaceAll]);
          end;
          SymToAsyForm.JamFileListSym.Search(sDirectoryPath);
        end
      end;
      lInfo.Clear;
    finally
      ProjectIniFile.Free;
      lInfo.Free;
    end;
    SymToAsyForm.ShowModal;
    SymToAsyForm.JamFileListSym.Stop;
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionSymToAsyExecute');
end;

procedure TMainForm.ActionSynIniEditorExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'ActionSynIniEditorExecute');

  if ValidProject then
  begin
    StartECSIniEditor();
  end
  else
    MessageDlg
      ('The project does not have enough information. Project.ini file not found!',
      mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ActionSynIniEditorExecute');
end;

procedure TMainForm.cbSaveActiveProjectClick(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'cbSaveActiveProjectClick');

  if (ValidProject) then
    SaveActiveProjectInformation;

  CodeSite.ExitMethod(Self, 'cbSaveActiveProjectClick');
end;


procedure TMainForm.cbToolChange(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'cbToolChange');

  if (cbTool.Text = 'LTspice') then
    ToolInUse := LTspice
  else if (cbTool.Text = 'HSpice') then
    ToolInUse := HSpice
  else if (cbTool.Text = 'PSpice') then
    ToolInUse := PSpice
  else if (cbTool.Text = 'Verilog') then
    ToolInUse := Verilog
  else if (cbTool.Text = 'Edif') then
    ToolInUse := Edif
  else if (cbTool.Text = 'APT') then
    ToolInUse := APT
  else if (cbTool.Text = 'Assura') then
    ToolInUse := Assura
  else if (cbTool.Text = 'Dracula') then
    ToolInUse := Dracula;
  SaveActiveProjectInformation;

  CodeSite.ExitMethod(Self, 'cbToolChange');
end;

procedure TMainForm.CheckCurrrentProcessVersion;
var
  fCurrentRevision, fProjectProcessRev: Double;
begin
  CodeSite.EnterMethod(Self, 'CheckCurrrentProcessVersion');

  { Comparing used process version vs. exiting process version }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM process');
    SQL.Add('WHERE processname = ' + QuotedStr(Process.Name));
    Open;
  end; { with }
  if LibraryDatabase.UniQuery.RecordCount > 0 then
  begin
    Process.Process_Id := LibraryDatabase.UniQuery.FieldByName('process_id')
      .AsInteger;
    with LibraryDatabase.UniQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT number FROM rev');
      SQL.Add('WHERE process_id = ' + FloatToStr(Process.Process_Id));
      SQL.Add('ORDER BY number');
      Open;
    end; { with }
    LibraryDatabase.UniQuery.Last;
    fCurrentRevision :=
      StrToFloat(LibraryDatabase.UniQuery.FieldByName('NUMBER').AsString);
    fProjectProcessRev := StrToFloat(Process.Rev);
    if (fCurrentRevision > fProjectProcessRev) then
    begin
      ShowMessage(Format('For %s there is a new process release: %f.',
        [Process.Name, fCurrentRevision]));
    end;
  end
  else
    ShowMessage('Problem reviewing current revision. Get CAD support!');

  CodeSite.ExitMethod(Self, 'CheckCurrrentProcessVersion');
end;

procedure TMainForm.CohesionArchive(sSchematics: string);
var
  sArchiveDir: string;
begin
  CodeSite.EnterMethod(Self, 'CohesionArchive');

  sArchiveDir := IncludeTrailingPathDelimiter(Project.RevDir) + 'layout';
  sArchiveDir := IncludeTrailingPathDelimiter(sArchiveDir) +
    ExtractFileName(sSchematics);
  if not DirectoryExists(sArchiveDir) then
    CreateDir(sArchiveDir)
  else
  begin
    AppIcons.IconModule.JamFileOperationArchive.Options :=
      [soFilesOnly, soNoConfirmation];
    AppIcons.IconModule.JamFileOperationArchive.Operation := otDelete;
    AppIcons.IconModule.JamFileOperationArchive.SourceFiles.Clear;
    AppIcons.IconModule.JamFileOperationArchive.SourceFiles.Add
      (IncludeTrailingPathDelimiter(sArchiveDir) + '*.*');
    AppIcons.IconModule.JamFileOperationArchive.Execute;
  end;
  with AppIcons.IconModule.LMDStartArchive do
  begin
    Command := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'archive.exe';
    DefaultDir := sArchiveDir;
    Parameters := ' -save=' + sArchiveDir + ' ' + sSchematics;
    Execute;
  end;

  CodeSite.ExitMethod(Self, 'CohesionArchive');
end;

procedure TMainForm.CohesionUserGuideClick(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'CohesionUserGuideClick');

  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) + 'doc\';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
    'CohesionDesigner.pdf';
  sArgument := '';
  if (FileExists(sCommand)) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
      PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'CohesionUserGuideClick');
end;

procedure TMainForm.Configure1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Configure1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-configservice';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Configure1Click');
end;

procedure TMainForm.Control1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Control1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-controlservice';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Control1Click');
end;

procedure TMainForm.CopyOldFiles;
var
  sSource: string;
  sSourceDir: string;
  sDestDir: string;
  sDest: string;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'CopyOldFiles');

  NewRevWithoutProcessCode.NewRevForm.ProgressBarCopyOldFiles.Min := 0;
  NewRevWithoutProcessCode.NewRevForm.ProgressBarCopyOldFiles.Max :=
    NewRevWithoutProcessCode.NewRevForm.SearchFileList.TotalFileCount - 1;
  for I := 0 to (NewRevWithoutProcessCode.NewRevForm.SearchFileList.
    TotalFileCount - 1) do
  begin
    sSource := NewRevWithoutProcessCode.NewRevForm.SearchFileList.Items.
      Item[I].Path;
    sSourceDir := ExtractFileDir(sSource);
    sDestDir := ReplaceText(sSourceDir, Project.oldSchemDir,
      Project.newSchemDir);
    if not(DirectoryExists(sDestDir)) then
      TDirectory.CreateDirectory(sDestDir);
    sDest := IncludeTrailingPathDelimiter(sDestDir) + ExtractFileName(sSource);
    TFile.Copy(sSource, sDest);
    NewRevWithoutProcessCode.NewRevForm.ProgressBarCopyOldFiles.Position := I;
  end;

  CodeSite.ExitMethod(Self, 'CopyOldFiles');
end;

procedure TMainForm.CreateDirectories;
begin
  CodeSite.EnterMethod(Self, 'CreateDirectories');

  if not DirectoryExists(Project.Dir) then
    CreateDir(Project.Dir);
  SetCurrentDir(Project.Dir);
  if not DirectoryExists(Project.Rev) then
    CreateDir(Project.Rev);
  SetCurrentDir(Project.Rev);
  if not DirectoryExists('lib') then
    CreateDir('lib');
  if not DirectoryExists('schem') then
    CreateDir('schem');
  if not DirectoryExists('layout') then
    CreateDir('layout');
  SetCurrentDir('lib');
  if not DirectoryExists('cadence') then
    CreateDir('cadence');
  if not DirectoryExists('cats') then
    CreateDir('cats');
  if not DirectoryExists('cats') then
    CreateDir('cats');
  if not DirectoryExists('dracula') then
    CreateDir('dracula');
  if not DirectoryExists('assura') then
    CreateDir('assura');
  if not DirectoryExists('ecs') then
    CreateDir('ecs');
  if not DirectoryExists('hspice') then
    CreateDir('hspice');
  if not DirectoryExists('ledit') then
    CreateDir('ledit');
  if not DirectoryExists('local') then
    CreateDir('local');
  if not DirectoryExists('pspice') then
    CreateDir('pspice');
  if not DirectoryExists('ltspice') then
    CreateDir('ltspice');
  if not DirectoryExists('verilog') then
    CreateDir('verilog');
  if not DirectoryExists('doc') then
    CreateDir('doc');
  SetCurrentDir('ecs');
  if not DirectoryExists('analog') then
    CreateDir('analog');
  if not DirectoryExists('digital') then
    CreateDir('digital');
  if not DirectoryExists('generic') then
    CreateDir('generic');
  if not DirectoryExists('package') then
    CreateDir('package');
  if not DirectoryExists('ideal') then
    CreateDir('ideal');
  SetCurrentDir('analog');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  SetCurrentDir('..\digital');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  SetCurrentDir('..\generic');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  SetCurrentDir('..\package');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  SetCurrentDir('..\ideal');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  SetCurrentDir('..\..\local');
  if not DirectoryExists('hspice') then
    CreateDir('hspice');
  if not DirectoryExists('netlists') then
    CreateDir('netlists');
  if not DirectoryExists('pspice') then
    CreateDir('pspice');
  if not DirectoryExists('ltspice') then
    CreateDir('ltspice');
  if not DirectoryExists('schematics') then
    CreateDir('schematics');
  if not DirectoryExists('symbols') then
    CreateDir('symbols');
  SetCurrentDir(LTCSim.localProjectsDir);

  CodeSite.ExitMethod(Self, 'CreateDirectories');
end;

procedure TMainForm.CreateIniFile;
var
  ProjectIniFile: TIniFile;
  sValueName, sValue: string;
  I: Integer;
  sOption: string;
  lInfo: TStringList;
  lDetail: TStringList;
  lSubDetail: TStringList;
  sTemp: string;
  pTemp: PChar;
  bTemp: Boolean;
begin
      { TMainForm.CreateIniFile }
  CodeSite.EnterMethod(Self, 'CreateIniFile');

  lInfo := TStringList.Create;
  lDetail := TStringList.Create;
  lSubDetail := TStringList.Create;
  ProjectIniFile := TIniFile.Create(Project.IniFileName);
  try
    { Create Scs section }
    with ProjectIniFile do
    begin
      WriteString('Scs', 'Version', '1.0');
      with LibraryDatabase.UniQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM process_released');
        SQL.Add('WHERE processname = ' + QuotedStr(Process.Name));
        SQL.Add('AND version = ' + Process.Rev);
        Open;
      end;
      if (LibraryDatabase.UniQuery.RecordCount = 0) then
      begin
        with LibraryDatabase.UniQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM process');
          SQL.Add('WHERE processname = ' + QuotedStr(Process.Name));
          Open;
        end;
      end;
      if (LibraryDatabase.UniQuery.RecordCount > 0) then
      begin
        lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('nets'));

        { Create Controls section }
        for I := 1 to lInfo.Count do
        begin
          ExtractStrings(['='], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
          sValueName := lDetail.Strings[0];
          sValue := lDetail.Strings[1];
          WriteString('Controls', sValueName, sValue)
        end;
        lInfo.Clear;

        { Create SymbolLibraries section }
        lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('sym_path'));
        for I := 1 to lInfo.Count do
        begin
          lDetail.Clear;
          ExtractStrings(['='], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
          sValueName := '$(PROJECTS)\' + IncludeTrailingPathDelimiter
            (Project.Name) + IncludeTrailingPathDelimiter(Project.Rev) +
            lDetail.Strings[0];
          sValue := lDetail.Strings[1];
          WriteString('SymbolLibraries', sValueName, sValue)
        end;
        lInfo.Clear;
        lDetail.Clear;
        { Create ProjectLibraries section }
        lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('sch_path'));
        for I := 1 to lInfo.Count do
        begin
          lDetail.Clear;
          ExtractStrings(['='], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
          sValueName := '$(PROJECTS)\' + IncludeTrailingPathDelimiter
            (Project.Name) + IncludeTrailingPathDelimiter(Project.Rev) +
            lDetail.Strings[0];
          sValue := lDetail.Strings[1];
          WriteString('ProjectLibraries', sValueName, sValue)
        end;
        lInfo.Clear;
        { Create GlobalConstants section }
        lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('layers'));
        for I := 1 to lInfo.Count do
        begin
          lDetail.Clear;
          ExtractStrings(['='], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
          sValueName := lDetail.Strings[0];
          sValue := lDetail.Strings[1];
          WriteString('GlobalConstants', sValueName, sValue)
        end;
      end;
      LibraryDatabase.UniQuery.Close;
      with LibraryDatabase.UniQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM prom_released');
        SQL.Add('WHERE promis_name = ' + QuotedStr(Process.Promis));
        SQL.Add('AND processname = ' + QuotedStr(Process.Name));
        SQL.Add('AND version = ' + Process.Rev);
        Open;
      end;
      if (LibraryDatabase.UniQuery.RecordCount = 0) then
      begin
        with LibraryDatabase.UniQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM prom');
          SQL.Add('WHERE promis_name = ' + QuotedStr(Process.Promis));
          Open;
        end;
      end;
      if (LibraryDatabase.UniQuery.RecordCount > 0) then
      begin
        { Dealing with option 1 }
        if Process.option1 <> 'N/A' then
        begin
          lInfo.Clear;
          lDetail.Clear;
          lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('option1_la'));
          for I := 1 to lInfo.Count do
          begin
            {
              sOption := ExtractWordS(1, lInfo.Strings[i - 1], ':');
            }
            ExtractStrings([':'], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
            sOption := lDetail.Strings[0];
            if sOption = Process.option1 then
            begin
              pTemp := PChar(lDetail.Strings[1]);
              sTemp := AnsiExtractQuotedStr(pTemp, '"');
              ExtractStrings(['='], [' '], PChar(sTemp), lSubDetail);
              sValueName := lSubDetail.Strings[0];
              sValue := lSubDetail.Strings[1];
              WriteString('GlobalConstants', sValueName, sValue);
            end;
            lDetail.Clear;
            lSubDetail.Clear;
          end;
        end;
        { Dealing with option 2 }
        if Process.option2 <> 'N/A' then
        begin
          lInfo.Clear;
          lDetail.Clear;
          lInfo.Assign(LibraryDatabase.UniQuery.FieldByName('option2_la'));
          for I := 1 to lInfo.Count do
          begin
            ExtractStrings([':'], [' '], PChar(lInfo.Strings[I - 1]), lDetail);
            sOption := lDetail.Strings[0];
            if sOption = Process.option2 then
            begin
              pTemp := PChar(lDetail.Strings[1]);
              sTemp := AnsiExtractQuotedStr(pTemp, '"');
              ExtractStrings(['='], [' '], PChar(sTemp), lSubDetail);
              sValueName := lSubDetail.Strings[0];
              sValue := lSubDetail.Strings[1];
              WriteString('GlobalConstants', sValueName, sValue);
            end
          end
        end;
      end;
      LibraryDatabase.UniQuery.Close;
      with LibraryDatabase.UniQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM process_released');
        SQL.Add('WHERE processname = ' + QuotedStr(Process.Name));
        SQL.Add('AND version = ' + Process.Rev);
        Open;
      end;
      bTemp := False;
      if (LibraryDatabase.UniQuery.RecordCount > 0) then
        bTemp := LibraryDatabase.UniQuery.FieldByName('lt_pspice').AsVariant;
      if bTemp then
        RadioGroupLTspiceSyntax.ItemIndex := 0
      else
        RadioGroupLTspiceSyntax.ItemIndex := 1;
    end;
  finally
    ProjectIniFile.Free;
  end;
  lInfo.Free;

  CodeSite.ExitMethod(Self, 'CreateIniFile');
end;

procedure TMainForm.CreateStimFile(sStimFileName: string; sSimulator: string);
var
  StringList: TStringList;
  sFileExtension: string;
begin
  CodeSite.EnterMethod(Self, 'CreateStimFile');

  { Creating a new stimulus file }
  if ValidProject then
  begin
    sFileExtension := '.spi';
    StringList := TStringList.Create;
    try
      StringList.Clear;
      StringList.Add('* Stimulus file created for ' + sSimulator);
      StringList.Add('.include ' + cbSchematics.Text + sFileExtension);
      StringList.Add('.end');
      StringList.SaveToFile(sStimFileName)
    finally
      StringList.Free
    end
  end
  else
  begin
    MessageDlg
      ('Project was not properly opened or incomplete information available.',
      mtError, [mbOK], 0)
  end;

  CodeSite.ExitMethod(Self, 'CreateStimFile');
end;

procedure TMainForm.CreateSynarioFiles;
begin
  CodeSite.EnterMethod(Self, 'CreateSynarioFiles');

  CreateIniFile;

  CodeSite.ExitMethod(Self, 'CreateSynarioFiles');
end;

procedure TMainForm.Delete1Click(Sender: TObject);
var
  ix: Integer;
begin
  CodeSite.EnterMethod(Self, 'Delete1Click');

  ix := cbStim.Items.IndexOf(cbStim.Text);
  cbStim.Items.Delete(ix);
  cbStim.Text := '';

  CodeSite.ExitMethod(Self, 'Delete1Click');
end;

procedure TMainForm.Delete2Click(Sender: TObject);
var
  ix: Integer;
begin
  CodeSite.EnterMethod(Self, 'Delete2Click');

  ix := cbSchematics.Items.IndexOf(cbSchematics.Text);
  cbSchematics.Items.Delete(ix);
  cbSchematics.Text := '';

  CodeSite.ExitMethod(Self, 'Delete2Click');
end;

procedure TMainForm.DetailsClick(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'DetailsClick');

  JamShellListMain.ViewStyle := TViewStyle(Integer(TComponent(Sender).tag));
  case JamShellListMain.ViewStyle of
    vsIcon:
      begin
        Largeicons2.checked := true;
        Largeicons2.checked := true
      end;
    vsSmallIcon:
      begin
        Smallicons2.checked := true;
        Smallicons2.checked := true
      end;
    vsList:
      begin
        List2.checked := true;
        List2.checked := true
      end;
    vsReport:
      begin
        Details2.checked := true;
        Details2.checked := true
      end;
  end;

  CodeSite.ExitMethod(Self, 'DetailsClick');
end;

procedure TMainForm.DisplayHideattributesDlg(Sender: TObject);
var
  ProjectIniFile: TMemIniFile;
  DesignIniFile: TMemIniFile;
  I: Integer;
  p: Integer;
  lKeys: TStringList;
  lValues: TStringList;
  sTemp: string;
  sTemp2: string;
  sTemp3: string;
  iTemp: Integer;
  iPos: Integer;
  sWindowTitle: string;
  TheWindow: HWnd;
begin
      { TMainForm.CreateIniFile }
  CodeSite.EnterMethod(Self, 'DisplayHideattributesDlg');

  if not(cbLTspiceSchematics.checked and (ToolInUse = LTspice)) then
  begin
    if ValidProject() then
    begin
      { Checking for Schematic Editor }
      sWindowTitle := 'Schematic Editor';
      TheWindow := FindWindow(PChar(sWindowTitle), nil);
      if (TheWindow <> 0) then
      begin
        ShowMessage
          ('You need to close all schematic windows before you change attribute display option.');
        Abort;
      end;
      TimeDelay(200);
      lKeys := TStringList.Create;
      lValues := TStringList.Create;
      ProjectIniFile := TMemIniFile.Create(Project.IniFileName);
      Project.DesignSettingsIniFile := IncludeTrailingPathDelimiter
        (LTCSim.designer6Dir) + IncludeTrailingPathDelimiter('config') +
        'design_settings.ini';
      DesignIniFile := TMemIniFile.Create(Project.DesignSettingsIniFile);
      try
        DisplayHideAttrDlg.LMDCheckListBox.Clear;
        { Read Design default }
        DesignIniFile.ReadSection('SymAttrNames', lKeys);
        for I := 0 to (lKeys.Count - 1) do
        begin
          sTemp := lKeys.Strings[I];
          sTemp2 := DesignIniFile.ReadString('SymAttrNames', sTemp, '');
          p := Pos(',', sTemp2);
          if p > 0 then
            DisplayHideAttrDlg.LMDCheckListBox.Items.Add(sTemp);
        end;
        // Sort attributes
        DisplayHideAttrDlg.LMDCheckListBox.Sorted := true;
        lKeys.Clear;
        lValues.Clear;
        // Check for local project changes
        ProjectIniFile.ReadSection('SymAttrNames', lKeys);
        if lKeys.Count > 0 then
        begin
          // Local changes, update dialog
          for I := 0 to (lKeys.Count - 1) do
          begin
            sTemp := lKeys.Strings[I];
            if (DisplayHideAttrDlg.LMDCheckListBox.Items.IndexOf(sTemp) <> 0)
            then
            begin
              iTemp := DisplayHideAttrDlg.LMDCheckListBox.Items.IndexOf(sTemp);
              DisplayHideAttrDlg.LMDCheckListBox.checked[iTemp] := true;
            end
          end
        end;
        if (DisplayHideAttrDlg.ShowModal = mrOk) then
        begin
          // Change all selected
          for I := 0 to (DisplayHideAttrDlg.LMDCheckListBox.Items.Count - 1) do
          begin
            sTemp := DisplayHideAttrDlg.LMDCheckListBox.Items.Strings[I];
            sTemp2 := DesignIniFile.ReadString('SymAttrNames', sTemp, '');
            iPos := Pos(',', sTemp2);
            sTemp3 := LeftStr(sTemp2, (iPos - 1));
            if DisplayHideAttrDlg.LMDCheckListBox.checked[I] then
              ProjectIniFile.WriteString('SymAttrNames', sTemp, sTemp3)
          end;
          // Erase all unselected
          for I := 0 to (DisplayHideAttrDlg.LMDCheckListBox.Items.Count - 1) do
          begin
            sTemp := DisplayHideAttrDlg.LMDCheckListBox.Items.Strings[I];
            if not DisplayHideAttrDlg.LMDCheckListBox.checked[I] then
              ProjectIniFile.DeleteKey('SymAttrNames', sTemp);
          end
        end;
      finally
        ProjectIniFile.UpdateFile;
        ProjectIniFile.Free;
        DesignIniFile.Free;
        lKeys.Free;
        lValues.Free;
      end
    end
    else
      MessageDlg('You need a valid project open', mtError, [mbOK], 0);
  end
  else
    MessageDlg('This utility will not work with LTspice schematics',
      mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'DisplayHideattributesDlg');
end;

procedure TMainForm.EditFile(sFileName: string);
var
  sCommand: string;
begin
  CodeSite.EnterMethod(Self, 'EditFile');

  { Editing file sFileName }
  sCommand := eTextEditor.Path;
  if FileExists(sFileName) then
  begin
    if FileExists(sCommand) then
    begin
      ShellExecute(MainForm.Handle, 'open', PChar(sCommand), PChar(sFileName),
        PChar(ExtractFileDir(sFileName)), SW_SHOWNORMAL);
    end
    else
      MessageDlg('Command ' + sCommand +
        ' Not found. Change your Editor setup in LTCSim options.',
        mtInformation, [mbOK], 0)
  end
  else
    MessageDlg('File ' + sFileName + ' not found.', mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'EditFile');
end;

function TMainForm.EditSchematics(sFileName: string): Boolean;
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'EditSchematics');

  if not(cbLTspiceSchematics.checked) then
  begin
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'schem.exe';
    sArgument := sFileName;
    sWorkingDir := Project.SchemDir;
    if ValidProject then
    begin
      SaveActiveProjectInformation;
    end;
    if (FileExists(sArgument)) then
    begin
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);
      Result := true
    end
    else
    begin
      MessageDlg('File ' + sArgument + ' not found!', mtError, [mbOK], 0);
      Result := False
    end
  end
  else
  begin
    if not(FileExists(sFileName)) then
      sFileName := ChangeFileExt(sFileName, '.sch');
    sCommand := eLTCSpiceFileName.FileName;
    sArgument := ' -LTCSim ' + sFileName;
    sWorkingDir := Project.SchemDir;
    if ValidProject then
    begin
      SaveActiveProjectInformation;
    end;
    if (FileExists(sCommand)) then
    begin
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);
      Result := true
    end
    else
    begin
      MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);
      Result := False
    end
  end;

  CodeSite.ExitMethod(Self, 'EditSchematics');
end;

procedure TMainForm.EditStimulus;
var
  sStimFile, sStimFileExt, sSimulator: string;
begin
  CodeSite.EnterMethod(Self, 'EditStimulus');

  case ToolInUse of
    LTspice:
      begin
        sStimFileExt := '.cir';
        sSimulator := 'LTspice'
      end;
    PSpice:
      begin
        sStimFileExt := '.cir';
        sSimulator := 'PSpice'
      end;
    HSpice:
      begin
        sStimFileExt := '.sp';
        sSimulator := 'HSpice'
      end;
  end;
  if (ToolInUse = HSpice) or (ToolInUse = PSpice) or (ToolInUse = LTspice) then
  begin
    if (cbStim.Text = '') then
    begin
      if (cbSchematics.Text = '') then
      begin
        if (DlgStim.ShowModal = mrOk) then
        begin
          sStimFile := DlgStim.eStimFileName.Text;
          sStimFile := IncludeTrailingPathDelimiter(Project.SchemDir) +
            sStimFile + sStimFileExt;
          if not FileExists(sStimFile) then
          begin
            if (cbStim.Items.IndexOf(sStimFile) < 0) then
              {
                cbStim.Items.Add(JustFilenameS(sStimFile));
              }
              cbStim.Items.Add(ExtractFileName(sStimFile));
            {
              cbStim.Text := JustFilenameS(sStimFile);
            }
            cbStim.Text := ExtractFileName(sStimFile);
            CreateStimFile(sStimFile, sSimulator);
            EditFile(sStimFile)
          end
          else
          begin
            if (MessageDlg('File already exists. Do you want to edit it?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
            begin
              if (cbStim.Items.IndexOf(sStimFile) < 0) then
              begin
                cbStim.Items.Add(ExtractFileName(sStimFile))
              end;
              cbStim.Text := ExtractFileName(sStimFile);
              EditFile(sStimFile)
            end
          end
        end
      end
      else
      begin
        sStimFile := IncludeTrailingPathDelimiter(Project.SchemDir) +
          cbSchematics.Text + sStimFileExt;
        if not FileExists(sStimFile) then
        begin
          if (cbStim.Items.IndexOf(sStimFile) < 0) then
            cbStim.Items.Add(ExtractFileName(sStimFile));
          cbStim.Text := ExtractFileName(sStimFile);
          CreateStimFile(sStimFile, sSimulator);
          EditFile(sStimFile)
        end
        else
        begin
          if (MessageDlg('File already exists. Do you want to edit it?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          begin
            if (cbStim.Items.IndexOf(sStimFile) < 0) then
            begin
              cbStim.Items.Add(ExtractFileName(sStimFile))
            end;
            cbStim.Text := ExtractFileName(sStimFile);
            EditFile(sStimFile)
          end
        end
      end
    end
    else
    begin
      sStimFile := IncludeTrailingPathDelimiter(Project.SchemDir) + cbStim.Text;
      EditFile(sStimFile)
    end
  end
  else
    MessageDlg('Not applicable when using dracula or verilog netlist' +
      'The header will be added to dracula netlist automatically if lvh file' +
      'is available.', mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'EditStimulus');
end;

function TMainForm.EditSymbol(sFileName: string): Boolean;
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'EditSymbol');

  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'sym.exe';
  sArgument := sFileName;
  sWorkingDir := Project.SchemDir;
  if ValidProject then
  begin
    SaveActiveProjectInformation;
  end;
  if (FileExists(sArgument)) then
  begin
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
      PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);
    Result := true
  end
  else
  begin
    MessageDlg('File ' + sArgument + ' not found!', mtError, [mbOK], 0);
    Result := False
  end;

  CodeSite.ExitMethod(Self, 'EditSymbol');
end;

procedure TMainForm.eFileBrowserFilterChange(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'eFileBrowserFilterChange');

  JamShellListMain.Filter := eFileBrowserFilter.Text;
  JamShellListMain.Update;

  CodeSite.ExitMethod(Self, 'eFileBrowserFilterChange');
end;

procedure TMainForm.eLTCSimOptionsChange(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'eLTCSimOptionsChange');

  SaveLTCSimOptions(LTCSim.xmlFileName);
  ModifyProjectIniFile('Controls', 'Editor for PC', eTextEditor.Path);
  ModifyProjectIniFile('Controls', 'Viewer for PC', eTextEditor.Path);

  CodeSite.ExitMethod(Self, 'eLTCSimOptionsChange');
end;

procedure TMainForm.EraseLibraryFiles;
var
  sTemp: string;
begin
  CodeSite.EnterMethod(Self, 'EraseLibraryFiles');

  { Erasing analog symbols }
  AppIcons.IconModule.JamFileOperation.Operation := otDelete;
  AppIcons.IconModule.JamFileOperation.Options :=
    [soFilesOnly, soNoConfirmation];
  AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\analog\netlists\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) +
    '\lib\ecs\analog\schematics\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\analog\symbols\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\digital\netlists\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) +
    '\lib\ecs\digital\schematics\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\digital\symbols\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\generic\netlists\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) +
    '\lib\ecs\generic\schematics\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\generic\symbols\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\ideal\netlists\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\ideal\schematics\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\ideal\symbols\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\package\netlists\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) +
    '\lib\ecs\package\schematics\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ecs\package\symbols\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\assura\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\cadence\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\cats\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\doc\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\dracula\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\hspice\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\ledit\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\pspice\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  sTemp := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + '\lib\verilog\*.*';
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
  AppIcons.IconModule.JamFileOperation.Execute;
  { Erasing HSpice files }

  CodeSite.ExitMethod(Self, 'EraseLibraryFiles');
end;

procedure TMainForm.ExtractAllSchematics;
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'ExtractAllSchematics');

  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'updatesc.exe';
  sArgument := ExtractFileName(IncludeTrailingPathDelimiter(Project.SchemDir) +
    cbSchematics.Text + '.sch');
  sWorkingDir := ExtractFileDir(IncludeTrailingPathDelimiter(Project.SchemDir) +
    cbSchematics.Text + '.sch');
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_SHOWNORMAL);

  CodeSite.ExitMethod(Self, 'ExtractAllSchematics');
end;

procedure TMainForm.FolderBackwardExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'FolderBackwardExecute');

  JamShellListMain.MoveInHistory(-1);

  CodeSite.ExitMethod(Self, 'FolderBackwardExecute');
end;

procedure TMainForm.FolderForwardExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'FolderForwardExecute');

  JamShellListMain.MoveInHistory(+1);

  CodeSite.ExitMethod(Self, 'FolderForwardExecute');
end;

procedure TMainForm.FolderUpExecute(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'FolderUpExecute');

  JamShellListMain.GoUp;

  CodeSite.ExitMethod(Self, 'FolderUpExecute');
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CodeSite.EnterMethod(Self, 'FormClose');

  if (LTCSim.shellLicenseStarted) then
  begin
    StopSCSShell;
    SaveLTCSimOptions(LTCSim.xmlFileName)
  end;
  Application.Terminate;

  CodeSite.ExitMethod(Self, 'FormClose');
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  VarValue: array [0 .. 200] of Char;
begin
  CodeSite.EnterMethod(Self, 'FormCreate');

  debugMode := False;
  cadMode := False;
  if (ParamStr(1) = '-d') then
    debugMode := true;
  if (ParamStr(1) = '-c') then
    cadMode := true;
  if (ParamStr(1) = '-cd') then
  begin
    debugMode := true;
    cadMode := true;
  end;
  GetCurrentDirectory(200, VarValue);
  LTCSim.Dir := VarValue;
  LTCSim.cohesionDir := ExtractFileDir(LTCSim.Dir);
  LTCSim.xmlFileName := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'LTCSim.xml';
  LTCSim.xmlSitesFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
    'LTCSimSites.xml';
  LTCSim.designer6Dir := ExtractFileDir(LTCSim.Dir);
  MainForm.Caption := 'LTC Simulation environment';

  CodeSite.ExitMethod(Self, 'FormCreate');
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'FormShow');

  LTCSim.lTools := TStringList.Create;
  LTCSim.lSites := TStringList.Create;
  sWindowsDir := Trim(GetEnvironmentVariable('windir'));
  ReadLTCSimOptions(LTCSim.xmlFileName);
  ReadLTCSimSites(LTCSim.xmlSitesFile);
  if not(DirectoryExists(LTCSim.localProjectsDir)) then
  begin
    MessageDlg('"Projects directory "' + LTCSim.localProjectsDir +
      '" not found!', mtError, [mbOK], 0);
    Screen.Cursor := crDefault;
    // Close;
    Application.Terminate;
  end
  else
  begin
    SetDirectoryBrowsers(LTCSim.localProjectsDir);
    LTCSim.libraryDir := '\\' + LTCSim.librariesServer +
      '\cad\cadtools\library';
    // ReadOldLTCSimOptions;
    if (not NetworkAvailable) then
    begin
      // ProjectNewMenu.Enabled := False;
      bLSFUpdate.Enabled := False;
    end;
    Project.lSchematicsUsed := TStringList.Create;
    Project.lStimulusUsed := TStringList.Create;
  end;
  LTCSim.shellLicenseStarted := False;
  MainForm.Caption := 'LTCSIM - No project is opened';

  CodeSite.ExitMethod(Self, 'FormShow');
end;

procedure TMainForm.InitializeForm;
begin
  CodeSite.EnterMethod(Self, 'InitializeForm');

  eProcessName.Clear;
  eProcessRev.Clear;
  ePromis.Clear;
  eOption1Name.Clear;
  eOption1Code.Clear;
  eOption1.Clear;
  eOption2Name.Clear;
  eOption2Code.Clear;
  eOption2.Clear;
  eGenericVer.Clear;
  cbSchematics.Clear;
  cbStim.Clear;
  eProcessOpt.Clear;

  CodeSite.ExitMethod(Self, 'InitializeForm');
end;

procedure TMainForm.InitializeLibrary;
begin
  CodeSite.EnterMethod(Self, 'InitializeLibrary');

  Screen.Cursor := crHourGlass;
  StopSCSShell;
  EraseLibraryFiles;
  TransferSymbols;
  StartSCSShell;
  Screen.Cursor := crDefault;

  CodeSite.ExitMethod(Self, 'InitializeLibrary');
end;

procedure TMainForm.Install1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Install1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-install';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Install1Click');
end;

procedure TMainForm.InstallLicense1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'InstallLicense1Click');

  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'DocuPrinter';
  sCommand := IncludeTrailingPathDelimiter(sWindowsDir) + 'regedit.exe';
  sArgument := ' /s ' + IncludeTrailingPathDelimiter(sWorkingDir) +
    'license.reg';
  if (FileExists(sCommand)) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
      PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'InstallLicense1Click');
end;

procedure TMainForm.InstallSoftware1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'InstallSoftware1Click');

  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'DocuPrinter';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'dprinter.exe';
  sArgument := ' /silent';
  if (FileExists(sCommand)) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
      PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'InstallSoftware1Click');
end;

procedure TMainForm.ipwPingError(Sender: TObject; ErrorCode: Integer; const
    Description: string);
begin
  CodeSite.EnterMethod(Self, 'ipwPingError');

  // ProjectNewMenu.Enabled := False;

  CodeSite.ExitMethod(Self, 'ipwPingError');
end;

procedure TMainForm.JamDropFileSchDrop(Sender: TObject; KeyState: TShiftState;
    MousePos: TPoint; var JamDropEffect: TJamDropEffect);
var
  sFileName, sFileExtension, sFilePathName: string;
  sNewPathName: string;
begin
  CodeSite.EnterMethod(Self, 'JamDropFileSchDrop');

  if AppIcons.IconModule.JamDropFileSch.DroppedFiles.Count = 1 then
  begin
    sFileName := AppIcons.IconModule.JamDropFileSch.DroppedFiles.Strings[0];
    sFileExtension := ExtractFileExt(sFileName);
    sFilePathName := ExtractFileDir(sFileName);
    if ((AnsiCompareText(sFileExtension, '.sch') = 0) or
      (AnsiCompareText(sFileExtension, '.asc') = 0)) then
    begin
      if (Pos(Project.RevDir, sFilePathName) <> 0) then
      begin
        sNewPathName := RightStr(sFilePathName,
          (Length(sFilePathName) - Length(Project.SchemDir) - 1));
        if sNewPathName <> '' then
          sFileName := IncludeTrailingPathDelimiter(sNewPathName) +
            ChangeFileExt(ExtractFileName(sFileName), '')
        else
          sFileName := ChangeFileExt(ExtractFileName(sFileName), '');
        if (cbSchematics.Items.IndexOf(sFileName) < 0) then
        begin
          cbSchematics.Items.Insert(0, sFileName);
          cbSchematics.Text := sFileName
        end;
        cbSchematics.Text := sFileName;
        if cbFilterAfterSchematics.checked then
        begin
          JamShellListMain.Filter := ChangeFileExt(sFileName, '.*');
          JamShellListMain.Update
        end
      end
      else
        MessageDlg
          (Format('Schematics file from outside of supported directory: %s!',
          [Project.SchemDir]), mtError, [mbOK], 0);
    end
  end
  else
    MessageDlg('Select just one file', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'JamDropFileSchDrop');
end;

procedure TMainForm.JamDropFilesStimDrop(Sender: TObject; KeyState: TShiftState;
    MousePos: TPoint; var JamDropEffect: TJamDropEffect);
var
  sFileName, sFileExtension, sFilePathName: string;
  sNewPathName: string;
begin
  CodeSite.EnterMethod(Self, 'JamDropFilesStimDrop');

  if AppIcons.IconModule.JamDropFilesStim.DroppedFiles.Count = 1 then
  begin
    sFileName := AppIcons.IconModule.JamDropFilesStim.DroppedFiles.Strings[0];
    sFileExtension := ExtractFileExt(sFileName);
    sFilePathName := ExtractFileDir(sFileName);
    if ((AnsiCompareText(sFileExtension, '.cir') = 0) or
      (AnsiCompareText(sFileExtension, '.sp') = 0)) then
    begin
      if (Pos(Project.RevDir, sFilePathName) <> 0) then
      begin
        sNewPathName := RightStr(sFilePathName,
          (Length(sFilePathName) - Length(Project.SchemDir) - 1));
        if sNewPathName <> '' then
          sFileName := IncludeTrailingPathDelimiter(sNewPathName) +
            ExtractFileName(sFileName)
        else
          sFileName := ExtractFileName(sFileName);
        if (cbStim.Items.IndexOf(sFileName) < 0) then
        begin
          cbStim.Items.Insert(0, sFileName);
          cbStim.Text := sFileName
        end;
        cbStim.Text := sFileName;
      end
      else
        MessageDlg
          (Format('Schematics file from outside of supported directory: %s!',
          [Project.SchemDir]), mtError, [mbOK], 0);
    end
  end
  else
    MessageDlg('Select just one file', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'JamDropFilesStimDrop');
end;

procedure TMainForm.JSDialogMainDialogClose(Sender: TJSCustomDialog);
var
  bAnswer: Boolean;
  sTemp: String;
  sSchematics, sSchemDirectory, sSchemFileName: String;
begin
  CodeSite.EnterMethod(Self, 'JSDialogMainDialogClose');

  sTemp := lMRStr[Sender.ModalResult];
  sSchematics := ChangeFileExt(Sender.Content[0], '.sch');
  sSchemFileName := ExtractFileName(sSchematics);
  sSchemDirectory := ExtractFilePath(sSchematics);

  if (sTemp = 'mrOk') then
  begin
    with AppIcons.IconModule.LMDStarterShell do
    begin
      Command := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'HierNav.exe';
      DefaultDir := sSchemDirectory;
      Parameters := sSchemFileName;
      Execute;
    end;
  end;

  CodeSite.ExitMethod(Self, 'JSDialogMainDialogClose');
end;

function TMainForm.libraryDBAvailable: Boolean;
begin
  CodeSite.EnterMethod(Self, 'libraryDBAvailable');

  if NetworkAvailable then
  begin
    try
      LibraryDatabase.UniConnectionLTCSim.Close;
      LibraryDatabase.UniConnectionLTCSim.ProviderName := 'PostgreSQL';
      LibraryDatabase.UniConnectionLTCSim.Username := 'ltcsimuser';
      LibraryDatabase.UniConnectionLTCSim.Password := 'LTCSim';
      LibraryDatabase.UniConnectionLTCSim.Database := 'LTCSim';
      LibraryDatabase.UniConnectionLTCSim.Server := 'LTCSimDB';
      LibraryDatabase.UniConnectionLTCSim.Open;
      Result := true;
    except
      LibraryDatabase.UniConnectionLTCSim.Disconnect;
      Result := False;
    end;
  end
  else
    Result := False;

  CodeSite.ExitMethod(Self, 'libraryDBAvailable');
end;

procedure TMainForm.LMDButtonFilter(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'LMDButtonFilter');

  with Sender as TLMDButton do
  begin
    JamShellListMain.Filter := '*.' + Caption;
    JamShellListMain.Update;
  end;

  CodeSite.ExitMethod(Self, 'LMDButtonFilter');
end;

procedure TMainForm.LMDMRUListClick(Sender: TObject; const aValue: string; var
    Remove: Boolean);
begin
  CodeSite.EnterMethod(Self, 'LMDMRUListClick');

  Project.RevDir := aValue;
  Project.Dir := ExtractFileDir(Project.RevDir);
  ReadProjectSetupFile;
  if (ValidateSearchPath()) then
  begin
    LTCSimProjectOpen;
  end
  else
  begin
    if (MessageDlg
      ('You have ilegal directories in use( outside the local project directory). Issue with archiving. Please move directories if needed inside local project',
      mtError, [mbYes, mbNo], 0) = mrYes) then
      StartECSIniEditor();
  end;

  CodeSite.ExitMethod(Self, 'LMDMRUListClick');
end;

procedure TMainForm.LTCSimArchiveNetlist(sSchematics: string);
var
  sSchemDirectory, sSchemFileName, sSchemZipDirectory, sNetlistFileName, sDate,
    sTime, sTemp: string;
  sCommand, sArgument, sWorkingDir, sZipFileName, sAPTNetlistFileName,
    sTreFileName: string;
  archiver: TZipForge;
begin
  CodeSite.EnterMethod(Self, 'LTCSimArchiveNetlist');

  sSchemFileName := ExtractFileName(sSchematics);
  sSchemDirectory := ExtractFilePath(sSchematics);
  sSchemZipDirectory := IncludeTrailingPathDelimiter
    (ExtractFilePath(sSchematics) + ChangeFileExt(sSchemFileName, '.dir'));
  sNetlistFileName := ChangeFileExt(sSchematics, '.net');
  sAPTNetlistFileName := ChangeFileExt(sSchematics, '.apt');
  sTreFileName := ChangeFileExt(sSchematics, '.tre');
  if not(FileExists(sTreFileName)) then
  begin
    MessageDlg('File ' + sTreFileName + ' not found!', mtError, [mbOK], 0);
    Abort;
  end;
  if not(FileExists(sNetlistFileName)) then
  begin
    MessageDlg('File ' + sNetlistFileName + ' not found!', mtError, [mbOK], 0);
    Abort;
  end;
  if not(FileExists(sAPTNetlistFileName)) then
  begin
    MessageDlg('File ' + sAPTNetlistFileName + ' not found!', mtError,
      [mbOK], 0);
    Abort;
  end;
  if DirectoryExists(sSchemZipDirectory) then
  begin
    JamFileOperationArchive.Options := [soFilesOnly, soNoConfirmation];
    JamFileOperationArchive.Operation := otDelete;
    JamFileOperationArchive.SourceFiles.Clear;
    JamFileOperationArchive.SourceFiles.Add
      (IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
    JamFileOperationArchive.Execute;
    RemoveDir(sSchemZipDirectory)
  end
  else
  begin
    CreateDir(sSchemZipDirectory);
  end;
  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'archive.exe ';
  sArgument := ' -save=' + sSchemZipDirectory + ' ' + sSchematics;
  sWorkingDir := sSchemDirectory;
  with IconModule.LMDStartArchive do
  begin
    Wait := true;
    Command := sCommand;
    DefaultDir := sWorkingDir;
    Parameters := sArgument;
    Execute;
  end; // with
  // Copy APT netlist inside
  sTemp := IncludeTrailingPathDelimiter(sSchemZipDirectory) +
    ChangeFileExt(sSchemFileName, '.apt');
  CopyFile(PChar(sAPTNetlistFileName), PChar(sTemp), true);
  // Copy Assura/Dracula inside
  sTemp := IncludeTrailingPathDelimiter(sSchemZipDirectory) +
    ChangeFileExt(sSchemFileName, '.net');
  CopyFile(PChar(sNetlistFileName), PChar(sTemp), true);
  // Copy Navigator file inside
  sTemp := IncludeTrailingPathDelimiter(sSchemZipDirectory) +
    ChangeFileExt(sSchemFileName, '.tre');
  CopyFile(PChar(sTreFileName), PChar(sTemp), true);

  DateTimeToString(sDate, 'mmdd', Now);
  DateTimeToString(sTime, 'hhnn', Now);
  // sDate := DateToStr( Date);
  // sTime := TimeToStr( Now );
  sZipFileName := IncludeTrailingPathDelimiter(sSchemDirectory) +
    ChangeFileExt(sSchemFileName, '.netz');
  // Copy zip file to location of schematics
  if FileExists(sZipFileName) then
  begin
    DeleteFile(PChar(sZipFileName))
  end;
  try
    archiver := TZipForge.Create(nil);
    with archiver do
    begin
      FileName := sZipFileName;
      OpenArchive(fmCreate);
      BaseDir := sSchemDirectory;
      Comment := Format('LTCSim files for: %s ,Date: %s, Time:%s',
        [ExtractFileName(sSchematics), sDate, sTime]);
      CompressionLevel := clNone;
      AddFiles(IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
      CloseArchive();
    end;
  except
    on E: Exception do
    begin
      Writeln('Exception: ', E.Message);
      Readln;
    end;
  end;
  // Remove old directory
  if DirectoryExists(sSchemZipDirectory) then
  begin
    JamFileOperationArchive.Options := [soFilesOnly, soNoConfirmation];
    JamFileOperationArchive.Operation := otDelete;
    JamFileOperationArchive.SourceFiles.Clear;
    JamFileOperationArchive.SourceFiles.Add
      (IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
    JamFileOperationArchive.Execute;
    RemoveDir(sSchemZipDirectory);
  end;

  CodeSite.ExitMethod(Self, 'LTCSimArchiveNetlist');
end;

procedure TMainForm.LTCSimArchiveSnapshot(sSchematics: string);
var
  sSchemDirectory, sSchemFileName, sSchemZipDirectory, sNetlistFileName, sDate,
    sTime, sTemp: string;
  sCommand, sArgument, sWorkingDir, sZipFileName, sHierNavFileName: string;
  sTreFile: string;
  archiver: TZipForge;
begin
  CodeSite.EnterMethod(Self, 'LTCSimArchiveSnapshot');

  sSchemFileName := ExtractFileName(sSchematics);
  sSchemDirectory := ExtractFilePath(sSchematics);
  sSchemZipDirectory := IncludeTrailingPathDelimiter
    (ExtractFilePath(sSchematics) + ChangeFileExt(sSchemFileName, '.dir'));
  sTreFile := ChangeFileExt(sSchematics, '.tre');
  if FileExists(sTreFile) then
  begin
    if DirectoryExists(sSchemZipDirectory) then
    begin
      JamFileOperationArchive.Options := [soFilesOnly, soNoConfirmation];
      JamFileOperationArchive.Operation := otDelete;
      JamFileOperationArchive.SourceFiles.Clear;
      JamFileOperationArchive.SourceFiles.Add
        (IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
      JamFileOperationArchive.Execute;
      RemoveDir(sSchemZipDirectory)
    end
    else
    begin
      CreateDir(sSchemZipDirectory);
    end;
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'archive.exe ';
    sArgument := ' -save=' + sSchemZipDirectory + ' ' + sSchematics;
    sWorkingDir := sSchemDirectory;
    { Copy HierNav and support files to same directory }
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'HierNav.exe'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'HierNav.exe'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tcl84.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tcl84.dll'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tk84.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tk84.dll'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tkdata.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tkdata.dll'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tkhtml.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tkhtml.dll'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tkmesg.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tkmesg.dll'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'tkwdog.exe'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'tkwdog.exe'), False);
    CopyFile(PChar(IncludeTrailingPathDelimiter(LTCSim.Dir) + 'nttapkp.dll'),
      PChar(IncludeTrailingPathDelimiter(sSchemZipDirectory) +
      'nttapkp.dll'), False);
    with LMDStarterArchive do
    begin
      Wait := true;
      Command := sCommand;
      DefaultDir := sWorkingDir;
      Parameters := sArgument;
      Execute;
    end; { with }
    sDate := formatdatetime('mm/dd/yy', Today);
    sTime := formatdatetime('hh:mm', Now);
    // sDate := CurrentDateString('MMDDYY', true);
    // sTime := CurrentTimeString('hhmm', true);
    {
      sZipFileName := IncludeTrailingPathDelimiter( sSchemDirectory )
      + ChangeFileExt( sSchemFileName,'.exe' );
    }
    sZipFileName := IncludeTrailingPathDelimiter(sSchemDirectory) +
      ChangeFileExt(sSchemFileName, '.snap');
    { Copy zip file to location of schematics }
    if FileExists(sZipFileName) then
    begin
      DeleteFile(PChar(sZipFileName))
    end;
    try
      archiver := TZipForge.Create(nil);
      with archiver do
      begin
        FileName := sZipFileName;
        // SFXStub := IncludeTrailingPathDelimiter(sLTCSimDir) + 'SFXStub.exe';
        OpenArchive(fmCreate);
        BaseDir := sSchemDirectory;
        Comment := 'Schematics ' + ExtractFileName(sSchematics) + ': ' + sDate +
          ' ' + sTime;
        CompressionLevel := clNone;
        AddFiles(IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
        CloseArchive();
      end;
    except
      on E: Exception do
      begin
        Writeln('Exception: ', E.Message);
        Readln;
      end;
    end;
    { Remove old directory }
    if DirectoryExists(sSchemZipDirectory) then
    begin
      JamFileOperationArchive.Options := [soFilesOnly, soNoConfirmation];
      JamFileOperationArchive.Operation := otDelete;
      JamFileOperationArchive.SourceFiles.Clear;
      JamFileOperationArchive.SourceFiles.Add
        (IncludeTrailingPathDelimiter(sSchemZipDirectory) + '*.*');
      JamFileOperationArchive.Execute;
      RemoveDir(sSchemZipDirectory);
    end
  end
  else
  begin
    // JSDialogMain.Header.Icon := tdiCustom;
    // the 'SHIELD' icon has a black border and looks better when the background is dark
    JSDialogMain.Content.Clear();
    JSDialogMain.Expando.Lines.Clear();
    JSDialogMain.Header.Glyph.Bitmap.LoadFromResourceName(hInstance,
      'JSD_SHIELD');
    JSDialogMain.Header.Glyph.Bitmap.Transparent := true;
    JSDialogMain.Instruction.Text :=
      'Navigator "<>.tre" file not found. Need to open with Navigator and save it first. Do you want to open the Navigator?';
    JSDialogMain.Expando.ShowText := 'Show schematics file name';
    JSDialogMain.Expando.HideText := 'Hide schematics file name';
    JSDialogMain.Expando.Lines.Add(sSchematics);
    JSDialogMain.Content.Add(sTreFile);
    JSDialogMain.Execute;
  end;

  CodeSite.ExitMethod(Self, 'LTCSimArchiveSnapshot');
end;

procedure TMainForm.LTCSimNewProject;
begin
  CodeSite.EnterMethod(Self, 'LTCSimNewProject');

  with Project do
  begin
    Name := Trim(PagesDlg.Project.Name);
    Rev := Trim(PagesDlg.Project.Rev);
  end;
  with Process do
  begin
    Name := Trim(PagesDlg.Process.Name);
    Rev := Trim(PagesDlg.Process.Rev);
    Promis := Trim(PagesDlg.Process.Promis);
    option1Name := Trim(PagesDlg.Process.option1Name);
    option1Code := Trim(PagesDlg.Process.option1Code);
    option1 := Trim(PagesDlg.Process.option1);
    option2Name := Trim(PagesDlg.Process.option2Name);
    option2Code := Trim(PagesDlg.Process.option2Code);
    option2 := Trim(PagesDlg.Process.option2);
    GenericRev := Trim(PagesDlg.Process.GenericRev);
  end;
  if (not ValidProject) then
  begin
    MessageDlg
      ('Incomplete information ! Project name, project rev process name, process rev and process options required!',
      mtError, [mbOK], 0);
    Screen.Cursor := crDefault;
    Abort
  end
  else
  begin
    MainForm.Caption := 'LTCSim (Project:' + Project.Name + ' Rev:' +
      Project.Rev + ')';
    eProcessName.Text := Process.Name;
    eProcessRev.Text := Process.Rev;
    ePromis.Text := Process.Promis;
    eOption1Name.Text := Process.option1Name;
    eOption1Code.Text := Process.option1Code;
    eOption1.Text := Process.option1;
    eOption2Name.Text := Process.option2Name;
    eOption2Code.Text := Process.option2Code;
    eOption2.Text := Process.option2;
    eGenericVer.Text := Process.GenericRev;
    UpdateProjectVariables;
    Project.SimulationDir := Project.SchemDir;
    if not FileExists(Project.Dir) then
    begin
      try
        CreateDirectories;
        CreateSynarioFiles;
        TransferSymbols;
        LMDMRUListMain.Add(Project.RevDir);
        AppIcons.IconModule.LMDMRUList.Add(Project.RevDir);
        SetDirectoryBrowsers(Project.SimulationDir);
        Project.XMLSetupFile6 := IncludeTrailingPathDelimiter(Project.RevDir) +
          'setup.xml';
        SaveActiveProjectInformation;
        SetDirectoryBrowsers(Project.SchemDir);
        SetCurrentDirectory(PChar(Project.SchemDir));
      finally
        Screen.Cursor := crDefault;
      end
    end
    else
    begin
      MessageDlg
        ('Directory can not be created. You may have one file or directory with the same name already!',
        mtError, [mbOK], 0);
      Screen.Cursor := crDefault;
      Abort
    end
  end;

  CodeSite.ExitMethod(Self, 'LTCSimNewProject');
end;

procedure TMainForm.LTCSimOptionsChange(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'LTCSimOptionsChange');

  ReadLTCSimSites(LTCSim.xmlSitesFile);

  CodeSite.ExitMethod(Self, 'LTCSimOptionsChange');
end;

procedure TMainForm.LTCSimProjectOpen;
var
  sIsDir, sShouldDir: string;
begin
  CodeSite.EnterMethod(Self, 'LTCSimProjectOpen');

  StopSCSShell;
  UpdateFormComponents;
  if ((Project.Name = '') or (Project.Rev = '')) then
    if MessageDlg('Invalid process information. Do you want to continue?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Abort;
  if (eProcessOpt.Text <> '') and (ePromis.Text = '') then
  begin
    ePromis.Text := 'N/A';
    eOption1Name.Text := 'N/A';
    eOption1Code.Text := 'N/A';
    eOption1.Text := 'N/A';
    eOption2Name.Text := 'N/A';
    eOption2Code.Text := 'N/A';
    eOption2.Text := 'N/A';
    eGenericVer.Text := '1.0';
  end;
  if ((ePromis.Text = '') or (ePromis.Text = 'N/A')) then
  begin
    ePromis.Text := 'N/A';
    eOption1Name.Text := 'N/A';
    eOption1Code.Text := 'N/A';
    eOption1.Text := 'N/A';
    eOption2Name.Text := 'N/A';
    eOption2Code.Text := 'N/A';
    eOption2.Text := 'N/A';
    eGenericVer.Text := '1.0';
  end;
  if ((eOption1.Text = '') or (eOption1.Text = 'N/A')) then
  begin
    eOption1Name.Text := 'N/A';
    eOption1Code.Text := 'N/A';
    eOption1.Text := 'N/A';
    eOption2Name.Text := 'N/A';
    eOption2Code.Text := 'N/A';
    eOption2.Text := 'N/A';
    eGenericVer.Text := '1.0';
  end;
  if ((eOption2.Text = '') or (eOption2.Text = 'N/A')) then
  begin
    eOption2Name.Text := 'N/A';
    eOption2Code.Text := 'N/A';
    eOption2.Text := 'N/A';
    eGenericVer.Text := '1.0';
  end;
  if (eOption1Code.Text = '') then
  begin
    if ((UpperCase(eOption1.Text) = '1K') or (UpperCase(eOption1.Text) = '3K')
      or (UpperCase(eOption1.Text) = '2.5K') or
      (UpperCase(eOption1.Text) = '30K') or (UpperCase(eOption1.Text) = '10K'))
    then
    begin
      eOption1Code.Text := 'TF';
    end
  end;
  if (eOption2Code.Text = '') then
  begin
    eOption2Code.Text := 'N/A';
  end;
  if (eGenericVer.Text = '') then
  begin
    eGenericVer.Text := '1.0';
  end;
  UpdateProjectVariables;
  if (LMDMRUListMain.Items.IndexOf(Project.RevDir) < 0) then
  begin
    if (LMDMRUListMain.Items.Count > 5) then
    begin
      LMDMRUListMain.Items.Delete(5);
      LMDMRUListMain.Add(Project.RevDir);
    end
    else
      LMDMRUListMain.Add(Project.RevDir);
  end;

  if (AppIcons.IconModule.LMDMRUList.Items.IndexOf(Project.RevDir) < 0) then
  begin
    if (AppIcons.IconModule.LMDMRUList.Items.Count > 5) then
    begin
      AppIcons.IconModule.LMDMRUList.Items.Delete(5);
      AppIcons.IconModule.LMDMRUList.Add(Project.RevDir);
    end
    else
      AppIcons.IconModule.LMDMRUList.Add(Project.RevDir);
  end;
  SetDirectoryBrowsers(Project.SchemDir);
  SetCurrentDirectory(PChar(Project.SchemDir));
  SaveActiveProjectInformation;
  MainForm.Caption := 'LTCSim (Project:' + Project.Name + ' Rev:' +
    Project.Rev + ')';
  if (not(ValidateSearchPath())) then
    if (MessageDlg
      ('You have ilegal directories in use( outside the local project directory). Modify now?',
      mtError, [mbYes, mbNo], 0) = mrYes) then
      StartECSIniEditor();
  StartSCSShell;
  if eAssuraLVS_Short.Text = '' then
    eAssuraLVS_Short.Text := '0.001';
  if eDraculaLVS_Short.Text = '' then
    eDraculaLVS_Short.Text := '0.001';

  CodeSite.ExitMethod(Self, 'LTCSimProjectOpen');
end;

procedure TMainForm.LTCSimUserGuideClick(Sender: TObject);
var
  sCommand: string;
begin
  CodeSite.EnterMethod(Self, 'LTCSimUserGuideClick');

  sCommand := ExtractFileDir(LTCSim.Dir) + '\doc\LTCSim\LTCSim.pdf';
  if FileExists(sCommand) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand), nil, nil,
      SW_NORMAL)
  else
    MessageDlg('Help is in development!', mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'LTCSimUserGuideClick');
end;

procedure TMainForm.MenuButtonTopFormClick(Sender: TObject);
var
  sSchematics: string;
  sStimulus: string;
  sFileExtension: string;
begin
  CodeSite.EnterMethod(Self, 'MenuButtonTopFormClick');

  if ValidProject() then
  begin
    if (not cbLTspiceSchematics.checked) then
      sFileExtension := '.sch'
    else
      sFileExtension := '.asc';
    sSchematics := IncludeTrailingPathDelimiter(Project.SchemDir) +
      cbSchematics.Text + sFileExtension;
    sStimulus := IncludeTrailingPathDelimiter(Project.SchemDir) + cbStim.Text;
    Project.SimulationDir := ExtractFilePath(sStimulus);
    with Sender as TLMDSpeedButton do
    begin
      case tag of
        1:
          EditSchematics(sSchematics);
        2:
          NavigateSchematics(sSchematics);
        3:
          EditStimulus;
        5:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runLTCSimNetlist(sSchematics, true, False);
          end;
        6:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runSimulation(sStimulus)
          end;
        7:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runLTCSimNetlist(sSchematics, true, true)
          end;
      end
    end
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'MenuButtonTopFormClick');
end;

procedure TMainForm.MigrateGlobalSignals(sOldSchemDir, sNewSchemDir, sOldRev,
    sNewRev: string);
var
  OldProjectIniFile, NewProjectIniFile: TIniFile;
  sOldValue: string;
  sOldKey, sNewKey: string;
  sGlobalNetsDef: string;
  lSymbolLibrarySection: TStringList;
  lProjectLibrariesSection: TStringList;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'MigrateGlobalSignals');

  OldProjectIniFile := TIniFile.Create
    (IncludeTrailingPathDelimiter(sOldSchemDir) + 'project.ini');
  NewProjectIniFile := TIniFile.Create
    (IncludeTrailingPathDelimiter(sNewSchemDir) + 'project.ini');
  try
    { Global nets }
    sGlobalNetsDef := 'bBN cSUB jBP';
    sOldValue := OldProjectIniFile.ReadString('Controls', 'GlobalNets',
      sGlobalNetsDef);
    NewProjectIniFile.DeleteKey('Controls', 'GlobalNets');
    NewProjectIniFile.WriteString('Controls', 'GlobalNets', sOldValue);
    lSymbolLibrarySection := TStringList.Create;
    { Symbol libraries }
    OldProjectIniFile.ReadSection('SymbolLibraries', lSymbolLibrarySection);
    for I := 0 to (lSymbolLibrarySection.Count - 1) do
    begin
      sOldKey := lSymbolLibrarySection.Strings[I];
      sOldValue := OldProjectIniFile.ReadString('SymbolLibraries',
        sOldKey, 'Y');
      NewProjectIniFile.DeleteKey('SymbolLibraries', sOldKey);
      sNewKey := StringReplace(sOldKey, sOldRev, sNewRev, [rfIgnoreCase]);
      NewProjectIniFile.WriteString('SymbolLibraries', sNewKey, sOldValue);
    end;
    { Project Libraries }
    lProjectLibrariesSection := TStringList.Create;
    OldProjectIniFile.ReadSection('ProjectLibraries', lProjectLibrariesSection);
    for I := 0 to (lProjectLibrariesSection.Count - 1) do
    begin
      sOldKey := lProjectLibrariesSection.Strings[I];
      sOldValue := OldProjectIniFile.ReadString('ProjectLibraries',
        sOldKey, 'Y');
      NewProjectIniFile.DeleteKey('ProjectLibraries', sOldKey);
      sNewKey := StringReplace(sOldKey, sOldRev, sNewRev, [rfIgnoreCase]);
      NewProjectIniFile.WriteString('ProjectLibraries', sNewKey, sOldValue);
    end;
  finally
    OldProjectIniFile.Free;
    NewProjectIniFile.Free;
  end;
  lSymbolLibrarySection.Free;
  lProjectLibrariesSection.Free;

  CodeSite.ExitMethod(Self, 'MigrateGlobalSignals');
end;

procedure TMainForm.MigrateLibFilesToNewRev(sOldRevDir, sNewRevDir: string);
var
  sOldLibDir: string;
begin
  CodeSite.EnterMethod(Self, 'MigrateLibFilesToNewRev');

  sOldLibDir := IncludeTrailingPathDelimiter(sOldRevDir) + 'lib';
  AppIcons.IconModule.JamFileOperation.Operation := otCopy;
  AppIcons.IconModule.JamFileOperation.Options :=
    [soNoConfirmMkDir, soSimpleProgress, soNoConfirmation];
  AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
  AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sOldLibDir);
  AppIcons.IconModule.JamFileOperation.Destination := sNewRevDir;
  if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
    MessageDlg('Error transferring library files.', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'MigrateLibFilesToNewRev');
end;

procedure TMainForm.MigrateProjectIniFileToNewrev(sOldSchemDir, sNewSchemDir:
    string);
begin
  CodeSite.EnterMethod(Self, 'MigrateProjectIniFileToNewrev');

  { Migrate Project.ini file }

  CodeSite.ExitMethod(Self, 'MigrateProjectIniFileToNewrev');
end;

procedure TMainForm.MigrateSetupIniFileToNewrev(sOldSchemDir, sNewSchemDir:
    string);
begin
  CodeSite.EnterMethod(Self, 'MigrateSetupIniFileToNewrev');

  { Migrate Setup.ini file }

  CodeSite.ExitMethod(Self, 'MigrateSetupIniFileToNewrev');
end;

procedure TMainForm.ModifyECSRegistry(sKey, sString, sValue: string);
var
  ECSIniFile: TIniFile;
begin
  CodeSite.EnterMethod(Self, 'ModifyECSRegistry');

  sECSRegistryIniFileName := IncludeTrailingPathDelimiter(sWindowsDir) +
    'schematic_preferences\project_state.ini';
  ECSIniFile := TIniFile.Create(sECSRegistryIniFileName);
  if FileExists(sECSRegistryIniFileName) then
  begin
    with ECSIniFile do
    begin
      WriteString(sKey, sString, sValue);
    end;
  end;
  ECSIniFile.Free;

  CodeSite.ExitMethod(Self, 'ModifyECSRegistry');
end;

procedure TMainForm.ModifyProjectIniFile(sKey, sString, sValue: string);
var
  ProjectIniFile: TIniFile;
begin
  CodeSite.EnterMethod(Self, 'ModifyProjectIniFile');

  if FileExists(Project.IniFileName) then
  begin
    ProjectIniFile := TIniFile.Create(Project.IniFileName);
    with ProjectIniFile do
    begin
      WriteString(sKey, sString, sValue);
    end;
    ProjectIniFile.Free;
  end;

  CodeSite.ExitMethod(Self, 'ModifyProjectIniFile');
end;

function TMainForm.NavigateSchematics(sFileName: string): Boolean;
var
  sWindowTitle: string;
  TheWindow: HWnd;
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'NavigateSchematics');

  if not cbLTspiceSchematics.checked then
  begin
    sArgument := sFileName;
    sWindowTitle := 'Hierarchy Navigator';
    TheWindow := FindWindow(PChar(sWindowTitle), nil);
    if (TheWindow <> 0) then
      SendMessage(TheWindow, WM_CLOSE, 0, 0);
    if FileExists(sArgument) then
    begin
      sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'hiernav.exe';
      sWorkingDir := ExtractFileDir(sArgument);
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);
      Result := true
    end
    else
    begin
      MessageDlg('File ' + sFileName + ' not found!', mtError, [mbOK], 0);
      Result := False
    end
  end
  else
  begin
    MessageDlg('Navigator not available when using LTspice schematics', mtError,
      [mbOK], 0);
    Result := False;
  end;

  CodeSite.ExitMethod(Self, 'NavigateSchematics');
end;

function TMainForm.NetworkAvailable: Boolean;
var
  objICMP: Icmp;
  I: Integer;
  strHost: string;

begin
  CodeSite.EnterMethod(Self, 'NetworkAvailable');

  CoInitialize(nil);
  objICMP := COIcmp.Create();
  strHost := LTCSim.dbServer;
  objICMP.Ping(strHost, 5000); // 5000: timeout in msecs
  if (objICMP.LastError <> 0) then
    Result := False
  else
    Result := true;

  CodeSite.ExitMethod(Self, 'NetworkAvailable');
end;

procedure TMainForm.OpenProjectRevClick(Sender: TObject);
begin
  CodeSite.EnterMethod(Self, 'OpenProjectRevClick');

  Project.RevDir := JamShellTreeMain.SelectedFolder;
  LTCSimProjectOpen;

  CodeSite.ExitMethod(Self, 'OpenProjectRevClick');
end;

procedure TMainForm.OpenUpdateSchematicsDlg(Sender: TObject);
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  sDirectoryPath: string;
begin
  CodeSite.EnterMethod(Self, 'OpenUpdateSchematicsDlg');

  if not(cbLTspiceSchematics.checked and (ToolInUse = LTspice)) then
  begin
    if ValidProject() then
    begin
      UpdateSchemDlg.JamFileList.Stop;
      UpdateSchemDlg.JamFileList.Clear;
      UpdateSchemDlg.JamFileList.SearchOptions.Filter := '*.sch';
      UpdateSchemDlg.JamFileList.SearchOptions.RecursiveSearch := False;
      // UpdateSchemDlg.JamFileList.SearchOptions.FilesOnly := true;
      lInfo := TStringList.Create;
      ProjectIniFile := TIniFile.Create(Project.IniFileName);
      try
        ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
        if (lInfo.Count > 0) then
        begin
          for I := 0 to (lInfo.Count - 1) do
          begin
            sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
            if (System.Pos('$(projects)', sDirectoryPath) > 0) then
            begin
              sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
                '$(projects)', LowerCase(LTCSim.localProjectsDir),
                [rfIgnoreCase, rfReplaceAll]);
            end;
            UpdateSchemDlg.JamFileList.Search(sDirectoryPath);
          end
        end;
        lInfo.Clear;
      finally
        ProjectIniFile.Free;
        lInfo.Free;
      end;
      UpdateSchemDlg.ShowModal;
      UpdateSchemDlg.JamFileList.Stop;
    end
    else
      MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);
  end
  else
    MessageDlg('This utility does not work with LTspice schematics',
      mtInformation, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'OpenUpdateSchematicsDlg');
end;

procedure TMainForm.ProcessInformationClick(Sender: TObject);
var
  sCommand: string;
begin
  CodeSite.EnterMethod(Self, 'ProcessInformationClick');

  if ValidProject then
  begin
    sCommand := Process.ProcessInfoFile;
    if FileExists(sCommand) then
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand), nil, nil,
        SW_NORMAL)
    else
      MessageDlg('Process information in development!', mtInformation,
        [mbOK], 0);
  end
  else
    MessageDlg('You need to have a valid project loaded first!', mtError,
      [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ProcessInformationClick');
end;

procedure TMainForm.ProjectArchive(sZipFileName: string);
var
  sTopSchematics: string;
  sLayoutDirectory, sLayoutSchematicsDirectory, sRevDir, sCommand, sOptions,
    sArgument, sWorkingDir, sLVSTopNetlist: string;
  SearchRec: TSearchRec;
  NumberZipped: Integer;
begin
  CodeSite.EnterMethod(Self, 'ProjectArchive');

  Project.zipFileName := sZipFileName;
  if ValidateSearchPath() then
    LTCSimArchiveForm.ShowModal
  else
    MessageDlg
      ('Your project includes a directory outside the selected project. The archive would not be complete!.',
      mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ProjectArchive');
end;

procedure TMainForm.ProjectCreateNewRevFromExistingRev;
var
  sOldProjectIni, sNewProjectIni: string;
begin
  CodeSite.EnterMethod(Self, 'ProjectCreateNewRevFromExistingRev');

  if (NewRevForm.EditNewRev.Text <> '') then
  begin
    sOldProjectIni := IncludeTrailingPathDelimiter(Project.SchemDir) +
      'Project.ini';
    sNewProjectIni := IncludeTrailingPathDelimiter(Project.newSchemDir) +
      'Project.ini';
    if DirectoryExists(Project.newRevDir) then
      MessageDlg('Revision already in use!', mtError, [mbOK], 0)
    else
    begin
      Project.Rev := NewRevForm.EditNewRev.Text;;
      UpdateProjectVariables;
      CreateDirectories;
      TFile.Copy(sOldProjectIni, sNewProjectIni);
      MigrateLibFilesToNewRev(Project.oldRevDir, Project.newRevDir);
      CopyOldFiles;
      MigrateGlobalSignals(Project.oldSchemDir, Project.newSchemDir,
        Project.oldRev, Project.newRev);
      Project.SimulationDir := Project.newSchemDir;
      AppIcons.IconModule.LMDMRUList.Add(Project.newRevDir);
      SetDirectoryBrowsers(Project.SimulationDir);
      Project.XMLSetupFile6 := IncludeTrailingPathDelimiter(Project.newRevDir) +
        'setup.xml';
      Project.XMLSetupFile71 := IncludeTrailingPathDelimiter(Project.newRevDir)
        + 'project.xml';
      SaveActiveProjectInformation;
      StartSCSShell;
    end;
  end
  else
    MessageDlg('You need to have a new revision name!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ProjectCreateNewRevFromExistingRev');
end;

procedure TMainForm.ProjectCreateNewRevFromServer;
begin
  CodeSite.EnterMethod(Self, 'ProjectCreateNewRevFromServer');

  if (NewRevForm.EditNewRev.Text <> '') then
  begin
    if DirectoryExists(Project.newSchemDir) then
      MessageDlg('Revision already in use!', mtError, [mbOK], 0)
    else
    begin
      if libraryDBAvailable then
      begin
        PagesDlg.eProjectName.Enabled := False;
        PagesDlg.eProjectName.Color := clInactiveBorder;
        PagesDlg.eProjectName.Text := Project.Name;
        PagesDlg.eProjectRev.Enabled := False;
        PagesDlg.eProjectRev.Color := clInactiveBorder;
        PagesDlg.eProjectRev.Text := NewRevForm.EditNewRev.Text;
        PagesDlg.eProcessName.Text := Process.Name;
        PagesDlg.eProcessRev.Text := Process.Rev;
        PagesDlg.ePromis.Text := Process.Promis;
        PagesDlg.eOption1.Text := Process.option1;
        PagesDlg.Option1Label.Caption := Process.option1Name;
        PagesDlg.Process.option1Name := Process.option1Name;
        PagesDlg.Process.option1Code := Process.option1Code;
        PagesDlg.eOption2.Text := Process.option2;
        PagesDlg.Option2Label.Caption := Process.option2Name;
        PagesDlg.Process.option2Name := Process.option2Name;
        PagesDlg.Process.option2Code := Process.option2Code;
        PagesDlg.eGenericRev.Text := Process.GenericRev;
        if (PagesDlg.ShowModal = mrOk) then
        begin
          Screen.Cursor := crHourGlass;
          StopSCSShell;
          LTCSimNewProject;
          CopyOldFiles;
          MigrateGlobalSignals(Project.SchemDir, Project.newSchemDir,
            Project.Rev, Project.newRev);
          StartSCSShell;
          Screen.Cursor := crDefault;
        end;
        PagesDlg.eProjectName.Enabled := true;
        PagesDlg.eProjectName.Color := clWindow;
        PagesDlg.eProjectRev.Enabled := true;
        PagesDlg.eProjectRev.Color := clWindow;
      end
      else
        MessageDlg
          ('Problems connecting to local server. Please get CAD support (Can not open DB)!',
          mtError, [mbOK], 0);
    end
  end
  else
    MessageDlg('You need to have a new revision name!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ProjectCreateNewRevFromServer');
end;

procedure TMainForm.ReadLTCSimOptions(sLTCSimOptionsFile: String);
Var
  XDoc: IXMLDocument;
  RootNode, Node, CNode: IXMLNode;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'ReadLTCSimOptions');

  XDoc := TXMLDocument.Create(nil);
  XDoc.Active := true;
  XDoc := LoadXMLDocument(sLTCSimOptionsFile);
  RootNode := XDoc.DocumentElement;

  if Assigned(RootNode) then
    Node := RootNode.ChildNodes.FindNode('tbTextEditorExe');
  if Assigned(Node) then
    eTextEditor.Path := Node.Text;
  // Node := RootNode.ChildNodes.FindNode('localProjectsDir');
  // if Assigned(Node) then
  // LTCSim.localProjectsDir := Node.Text;
  // if (LTCSim.localProjectsDir = '') then
  LTCSim.localProjectsDir := Trim(GetEnvironmentVariable('PROJECTS'));
  Node := RootNode.ChildNodes.FindNode('rbAssuraToLayout');
  if Assigned(Node) then
    LTCSim.AssuraToLayout := Node.NodeValue;
  if LTCSim.AssuraToLayout then
    rgArchiveNetlist.ItemIndex := 0
  else
    rgArchiveNetlist.ItemIndex := 1;
  Node := RootNode.ChildNodes.FindNode('cbCaseSensitive');
  if Assigned(Node) then
    cbIgnoreCase.checked := Node.NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterNetlist');
  if Assigned(Node) then
    cbFilterAfterNetlist.checked := Node.NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterSimulation');
  if Assigned(Node) then
    cbFilterAfterSimulation.checked := Node.NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterSchematics');
  if Assigned(Node) then
    cbFilterAfterSchematics.checked := Node.NodeValue;
  Node := RootNode.ChildNodes.FindNode('userName');
  if Assigned(Node) then
    eUserName.Text := Node.Text;
  Node := RootNode.ChildNodes.FindNode('userPassword');
  if Assigned(Node) then
    eUserPassword.Text := Node.Text;
  Node := RootNode.ChildNodes.FindNode('computeServer');
  if Assigned(Node) then
    eComputeServer.Text := Node.Text;
  Node := RootNode.ChildNodes.FindNode('location');
  if Assigned(Node) then
    cbLocation.Text := Node.Text;

  { Read Tools }
  LTCSim.lTools.Clear;
  Node := RootNode.ChildNodes.FindNode('Tools');
  for I := 0 to (Node.ChildNodes.Count - 1) do
  begin
    CNode := Node.ChildNodes[I];
    LTCSim.lTools.Add(CNode.Text)
  end;

  { Read sites }
  LTCSim.lSites.Clear;
  Node := RootNode.ChildNodes.FindNode('Sites');
  for I := 0 to (Node.ChildNodes.Count - 1) do
  begin
    CNode := Node.ChildNodes[I];
    LTCSim.lSites.Add(CNode.Text)
  end;

  cbFilterAfterNetlist.checked := cbFilterAfterNetlist.checked;
  cbFilterAfterSimulation.checked := cbFilterAfterSimulation.checked;
  cbPrimitiveReport.checked := cbPrimitiveReport.checked;
  rgArchiveNetlist.ItemIndex := LTCSim.ArchiveNetlistIndex;
  cbLocation.Text := cbLocation.Text;
  eComputeServer.Text := eComputeServer.Text;
  eUserName.Text := eUserName.Text;
  eUserPassword.Text := eUserPassword.Text;

  for I := 0 to (LTCSim.lTools.Count - 1) do
    cbTool.Items.Add(LTCSim.lTools.Strings[I]);
  for I := 0 to (LTCSim.lSites.Count - 1) do
    cbLocation.Items.Add(LTCSim.lSites.Strings[I]);

  XDoc.Active := False;
  XDoc := nil;

  CodeSite.ExitMethod(Self, 'ReadLTCSimOptions');
end;

procedure TMainForm.ReadLTCSimSites(sLTCSimSitesFile: String);
Var
  XDoc: IXMLDocument;
  RootNode, Node, CNode: IXMLNode;
begin
  CodeSite.EnterMethod(Self, 'ReadLTCSimSites');

  XDoc := TXMLDocument.Create(nil);
  XDoc.Active := true;
  XDoc := LoadXMLDocument(sLTCSimSitesFile);
  RootNode := XDoc.DocumentElement;

  { Read local site }
  Node := RootNode.ChildNodes.FindNode(cbLocation.Text);
  CNode := Node.ChildNodes.FindNode('dbServer');
  if Assigned(CNode) then
    LTCSim.dbServer := CNode.Text;
  CNode := Node.ChildNodes.FindNode('localSiteProjectsDir');
  if Assigned(CNode) then
    LTCSim.localSiteProjectsDir := CNode.Text;
  CNode := Node.ChildNodes.FindNode('librariesServer');
  if Assigned(CNode) then
    LTCSim.librariesServer := CNode.Text;

  XDoc.Active := False;
  XDoc := nil;

  CodeSite.ExitMethod(Self, 'ReadLTCSimSites');
end;

procedure TMainForm.ReadOldLTCSimOptions;
var
  Registry: TRegistry;
begin
  CodeSite.EnterMethod(Self, 'ReadOldLTCSimOptions');

  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey('\Software\LTC\LTCSim\Options\eTextEditor', False);
    eTextEditor.Path := Registry.ReadString('FileName');
    Registry.OpenKey('\Software\LTC\LTCSim\Options\eLibraryDirectory', False);
    LTCSim.libraryDir := Registry.ReadString('Text');
    Registry.OpenKey
      ('\Software\LTC\LTCSim\Options\eServerProjectDirectory', False);
    LTCSim.localProjectsDir := Registry.ReadString('Text');
  finally
    Registry.Free;
  end;

  CodeSite.ExitMethod(Self, 'ReadOldLTCSimOptions');
end;

procedure TMainForm.ReadProjectSetupFile;
var
  sIsDir, sShouldDir: String;
begin
  CodeSite.EnterMethod(Self, 'ReadProjectSetupFile');

  Project.SetupFile := IncludeTrailingPathDelimiter(Project.RevDir) +
    'setup.ini';
  Project.XMLSetupFile6 := IncludeTrailingPathDelimiter(Project.RevDir) +
    'setup.xml';
  Project.XMLSetupFile71 := IncludeTrailingPathDelimiter(Project.RevDir) +
    'setup71.xml';
  Project.LTspiceIniFileName := IncludeTrailingPathDelimiter(Project.RevDir) +
    'ltspice.ini';
  if (FileExists(Project.XMLSetupFile71)) then
  begin
    ReadXMLFile71;
    sIsDir := ExtractFileDir(Project.XMLSetupFile71);
    sShouldDir := IncludeTrailingPathDelimiter(Project.Dir) + Project.Rev;
    if (not(StrComp(StrUpper(PChar(sIsDir)), StrUpper(PChar(sShouldDir))) = 0))
    then
    begin
      MessageDlg
        ('This project does not meet the conventional directory structure.',
        mtError, [mbOK], 0);
      Abort
    end
 end
  else
  begin
    if (FileExists(Project.XMLSetupFile6)) then
    begin
      // Migrate to 7.1
      ReadXMLFileSetup6;
      sIsDir := ExtractFileDir(Project.XMLSetupFile6);
      sShouldDir := IncludeTrailingPathDelimiter(Project.Dir) + Project.Rev;
      if (not(StrComp(StrUpper(PChar(sIsDir)), StrUpper(PChar(sShouldDir))) = 0))
      then
      begin
        MessageDlg
          ('This project does not meet the conventional directory structure.',
          mtError, [mbOK], 0);
        Abort
      end
      else
      begin
        SaveXMLFile71;
      end;
    end
    else
    begin
      if FileExists(Project.SetupFile) then
      begin
        // Migrate to version 7.1
        ReadSetupFile6;
        sIsDir := ExtractFileDir(Project.SetupFile);
        sShouldDir := IncludeTrailingPathDelimiter(Project.Dir) + Project.Rev;
        if (not(StrComp(StrUpper(PChar(sIsDir)), StrUpper(PChar(sShouldDir)))
          = 0)) then
        begin
          MessageDlg
            ('This project does not meet the conventional directory structure.',
            mtError, [mbOK], 0);
          Abort
        end
        else
        begin
          SaveXMLFile71;
        end;
      end
    end
  end;

  CodeSite.ExitMethod(Self, 'ReadProjectSetupFile');
end;

procedure TMainForm.ReadSetupFile6;
begin
  CodeSite.EnterMethod(Self, 'ReadSetupFile6');

  {
    OvcIniFileStoreProject.IniFileName := Project.SetupFile;
    OvcIniFileStoreProject.Open;
    OvcComponentStateProject.RestoreState;
    LMDStorXMLVaultProject.FileName := Project.XMLSetupFile;
    LMDStorPropertiesStorageProject.Enabled := True;
    LMDStorPropertiesStorageProject.Save;
    LMDStorPropertiesStorageProject.Enabled := False;
    OvcIniFileStoreProject.Close
  }
  MessageDlg
    ('This project seems to be from original version not supported. Please CAD support to resolve it.',
    mtError, [mbOK], 0);
  Abort;

  CodeSite.ExitMethod(Self, 'ReadSetupFile6');
end;

procedure TMainForm.ReadXMLFile71;
Var
  XDoc: IXMLDocument;
  Node, CNode: IXMLNode;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'ReadXMLFile71');

  XDoc := TXMLDocument.Create(nil);
  XDoc.Active := true;
  XDoc := LoadXMLDocument(Project.XMLSetupFile71);

  Node := XDoc.DocumentElement.ChildNodes.FindNode('Project');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('name');
  if Assigned(CNode) then
    Project.Name := CNode.Text;
  CNode := Node.ChildNodes.FindNode('rev');
  if Assigned(CNode) then
    Project.Rev := CNode.Text;
  if Assigned(CNode) then
    Project.genericVersion := CNode.Text;
  CNode := Node.ChildNodes.FindNode('ignoreCase');
  if Assigned(CNode) then
    Project.ignoreCase := CNode.NodeValue;
  { currentSchematics }
  CNode := Node.ChildNodes.FindNode('currentSchematics');
  if Assigned(CNode) then
    Project.currentSchematics := CNode.Text;
  CNode := Node.ChildNodes.FindNode('currentStimulus');
  if Assigned(CNode) then
    Project.currentStimulus := CNode.Text;
  CNode := Node.ChildNodes.FindNode('currentTool');
  if Assigned(CNode) then
    Project.currentTool := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('Process');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('name');
  if Assigned(CNode) then
    Process.Name := CNode.Text;
  CNode := Node.ChildNodes.FindNode('rev');
  if Assigned(CNode) then
    Process.Rev := CNode.Text;
  CNode := Node.ChildNodes.FindNode('promis');
  if Assigned(CNode) then
    Process.Promis := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option1');
  if Assigned(CNode) then
    Process.option1 := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option1Code');
  if Assigned(CNode) then
    Process.option1Code := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option1Name');
  if Assigned(CNode) then
    Process.option1Name := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option2');
  if Assigned(CNode) then
    Process.option2 := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option2Code');
  if Assigned(CNode) then
    Process.option2Code := CNode.Text;
  CNode := Node.ChildNodes.FindNode('option2Name');
  if Assigned(CNode) then
    Process.option2Name := CNode.Text;
  CNode := Node.ChildNodes.FindNode('genericRev');
  if Assigned(CNode) then
    Process.GenericRev := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('LTspice');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('ltspiceGND');
  if Assigned(CNode) then
    Project.ltspiceGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceXGNDX');
  if Assigned(CNode) then
    Project.ltspiceXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceOmitPrefix');
  if Assigned(CNode) then
    Project.ltspiceOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceShrink');
  if Assigned(CNode) then
    Project.ltspiceShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceSubCircuit');
  if Assigned(CNode) then
    Project.ltspiceSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceschematics');
  if Assigned(CNode) then
    Project.ltspiceschematics := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('ltspiceLeftBracket');
  if Assigned(CNode) then
  Begin
    if (CNode.Text <> '') then
      Project.ltspiceLeftBracket := CNode.Text
    else
      Project.ltspiceLeftBracket := '_';
  End;
  CNode := Node.ChildNodes.FindNode('ltspiceRightBracket');
  if Assigned(CNode) then
  Begin
    if (CNode.Text <> '') then
      Project.ltspiceRightBracket := CNode.Text
    else
      Project.ltspiceLeftBracket := '_';
  End;
  CNode := Node.ChildNodes.FindNode('ltspiceCommand');
  if Assigned(CNode) then
    Project.ltspiceCommand := CNode.Text;
  CNode := Node.ChildNodes.FindNode('ltspiceCommandOptions');
  if Assigned(CNode) then
    Project.ltspiceCommandOptions := CNode.Text;
  CNode := Node.ChildNodes.FindNode('ltspiceSyntax');
  if Assigned(CNode) then
    Project.ltspiceSyntax := CNode.NodeValue;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('PSpice');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('pspiceGND');
  if Assigned(CNode) then
    Project.pspiceGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceXGNDX');
  if Assigned(CNode) then
    Project.pspiceXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceOmitPrefix');
  if Assigned(CNode) then
    Project.pspiceOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceShrink');
  if Assigned(CNode) then
    Project.pspiceShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceSubCircuit');
  if Assigned(CNode) then
    Project.pspiceSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceAD');
  if Assigned(CNode) then
    Project.pspiceAD := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('pspiceLeftBracket');
  if Assigned(CNode) then
  Begin
    if (CNode.Text <> '') then
      Project.pspiceLeftBracket := CNode.Text
    else
      Project.pspiceLeftBracket := '_'
  End;
  CNode := Node.ChildNodes.FindNode('pspiceRightBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.pspiceRightBracket := CNode.Text
    else
      Project.pspiceRightBracket := '_'
  end;
  CNode := Node.ChildNodes.FindNode('pspiceCommand');
  if Assigned(CNode) then
    Project.pspiceCommand := CNode.Text;
  CNode := Node.ChildNodes.FindNode('pspiceCommandOptions');
  if Assigned(CNode) then
    Project.pspiceCommandOptions := CNode.Text;
  CNode := Node.ChildNodes.FindNode('pspiceViewer');
  if Assigned(CNode) then
    Project.pspiceViewer := CNode.Text;
  CNode := Node.ChildNodes.FindNode('pspiceViewerOptions');
  if Assigned(CNode) then
    Project.pspiceViewerOptions := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('HSpice');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('hspiceGND');
  if Assigned(CNode) then
    Project.hspiceGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceXGNDX');
  if Assigned(CNode) then
    Project.hspiceXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceOmitPrefix');
  if Assigned(CNode) then
    Project.hspiceOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceShrink');
  if Assigned(CNode) then
    Project.hspiceShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceSubCircuit');
  if Assigned(CNode) then
    Project.hspiceSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceVerilogA');
  if Assigned(CNode) then
    Project.hspiceVerilogA := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('hspiceLeftBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.hspiceLeftBracket := CNode.Text
    else
      Project.hspiceLeftBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('hspiceRightBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.hspiceRightBracket := CNode.Text
    else
      Project.hspiceRightBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('hspiceCommand');
  if Assigned(CNode) then
    Project.hspiceCommand := CNode.Text;
  CNode := Node.ChildNodes.FindNode('hspiceCommandOptions');
  if Assigned(CNode) then
    Project.hspiceCommandOptions := CNode.Text;
  CNode := Node.ChildNodes.FindNode('hspiceViewer');
  if Assigned(CNode) then
    Project.hspiceViewer := CNode.Text;
  CNode := Node.ChildNodes.FindNode('hspiceViewerOptions');
  if Assigned(CNode) then
    Project.hspiceViewerOptions := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('APT');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('aptBipolarArea');
  if Assigned(CNode) then
    Project.aptBipolarArea := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptBipolarWL');
  if Assigned(CNode) then
    Project.aptBipolarWL := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptGND');
  if Assigned(CNode) then
    Project.aptGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptXGNDX');
  if Assigned(CNode) then
    Project.aptXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptOmitPrefix');
  if Assigned(CNode) then
    Project.aptOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptShrink');
  if Assigned(CNode) then
    Project.aptShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptSubCircuit');
  if Assigned(CNode) then
    Project.aptSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('aptLeftBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.aptLeftBracket := CNode.Text
    else
      Project.aptLeftBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('aptRightBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.aptRightBracket := CNode.Text
    else
      Project.aptRightBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('aptShort');
  if Assigned(CNode) then
    Project.aptShort := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('Assura');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('assuraBipolarArea');
  if Assigned(CNode) then
    Project.assuraBipolarArea := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraBipolarWL');
  if Assigned(CNode) then
    Project.assuraBipolarWL := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraGND');
  if Assigned(CNode) then
    Project.assuraGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraXGNDX');
  if Assigned(CNode) then
    Project.assuraXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraOmitPrefix');
  if Assigned(CNode) then
    Project.assuraOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraShrink');
  if Assigned(CNode) then
    Project.assuraShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraSubCircuit');
  if Assigned(CNode) then
    Project.assuraSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('assuraLeftBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.assuraLeftBracket := CNode.Text
    else
      Project.assuraLeftBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('assuraRightBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.assuraRightBracket := CNode.Text
    else
      Project.assuraRightBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('assuraShort');
  if Assigned(CNode) then
    Project.assuraShort := CNode.Text;

  Node := XDoc.DocumentElement.ChildNodes.FindNode('Dracula');
  if Assigned(Node) then
    CNode := Node.ChildNodes.FindNode('draculaBipolarArea');
  if Assigned(CNode) then
    Project.draculaBipolarArea := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaBipolarWL');
  if Assigned(CNode) then
    Project.draculaBipolarWL := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaGND');
  if Assigned(CNode) then
    Project.draculaGND := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaXGNDX');
  if Assigned(CNode) then
    Project.draculaXGNDX := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaOmitPrefix');
  if Assigned(CNode) then
    Project.draculaOmitPrefix := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaShrink');
  if Assigned(CNode) then
    Project.draculaShrink := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaSubCircuit');
  if Assigned(CNode) then
    Project.draculaSubCircuit := CNode.NodeValue;
  CNode := Node.ChildNodes.FindNode('draculaLeftBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.draculaLeftBracket := CNode.Text
    else
      Project.draculaLeftBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('draculaRightBracket');
  if Assigned(CNode) then
  begin
    if (CNode.Text <> '') then
      Project.draculaRightBracket := CNode.Text
    else
      Project.draculaRightBracket := '_';
  end;
  CNode := Node.ChildNodes.FindNode('draculaShort');
  if Assigned(CNode) then
    Project.draculaShort := CNode.Text;
  { Read Schematics }
  Project.lSchematicsUsed.Clear;
  Node := XDoc.DocumentElement.ChildNodes.FindNode('Schematics');
  for I := 0 to (Node.ChildNodes.Count - 1) do
  begin
    CNode := Node.ChildNodes[I];
    Project.lSchematicsUsed.Add(CNode.Text)
  end;

  { Read Stimulus }
  Project.lStimulusUsed.Clear;
  Node := XDoc.DocumentElement.ChildNodes.FindNode('Stimulus');
  for I := 0 to (Node.ChildNodes.Count - 1) do
  begin
    CNode := Node.ChildNodes[I];
    Project.lStimulusUsed.Add(CNode.Text)
  end;
  XDoc.Active := False;
  XDoc := nil;

  CodeSite.ExitMethod(Self, 'ReadXMLFile71');
end;

procedure TMainForm.ReadXMLFileSetup6;
Var
  XDoc: IXMLDocument;
  RootNode, Node, CNode: IXMLNode;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'ReadXMLFileSetup6');

  XDoc := TXMLDocument.Create(nil);
  XDoc.Active := true;
  XDoc := LoadXMLDocument(Project.XMLSetupFile6);

  RootNode := XDoc.DocumentElement.ChildNodes.FindNode('Project', '');
  Node := RootNode.ChildNodes.FindNode('eProjectName', '');
  if Assigned(Node) then
    Project.Name := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eProjectRev', '');
  if Assigned(Node) then
    Project.Rev := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('cbIgnoreCase', '');
  if Assigned(Node) then
    Project.ignoreCase := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterNetlist', '');
  if Assigned(Node) then
    cbFilterAfterNetlist.checked := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterSchematics', '');
  if Assigned(Node) then
    cbFilterAfterSchematics.checked := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbFilterAfterSimulation', '');
  if Assigned(Node) then
    cbFilterAfterSimulation.checked := Node.ChildNodes['Checked'].NodeValue;

  Node := RootNode.ChildNodes.FindNode('eProcessName', '');
  if Assigned(Node) then
    Process.Name := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eProcessRev', '');
  if Assigned(Node) then
    Process.Rev := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eGenericVer', '');
  if Assigned(Node) then
    Process.GenericRev := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption1', '');
  if Assigned(Node) then
    Process.option1 := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption1Code', '');
  if Assigned(Node) then
    Process.option1Code := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption1Name', '');
  if Assigned(Node) then
    Process.option1Name := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption2', '');
  if Assigned(Node) then
    Process.option2 := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption2Code', '');
  if Assigned(Node) then
    Process.option2Code := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eOption2Name', '');
  if Assigned(Node) then
    Process.option2Name := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('ePromis', '');
  if Assigned(Node) then
    Process.Promis := Node.ChildNodes['Text'].Text;

  Node := RootNode.ChildNodes.FindNode('cbLTspiceGND', '');
  if Assigned(Node) then
    Project.ltspiceGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbLTspiceOmitPrefix', '');
  if Assigned(Node) then
    Project.ltspiceOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbLTspiceSchematics', '');
  if Assigned(Node) then
    Project.ltspiceschematics := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbLTspiceShrink', '');
  if Assigned(Node) then
    Project.ltspiceShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbLTspiceSubcircuit', '');
  if Assigned(Node) then
    Project.ltspiceSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbLTspiceXGNDX', '');
  if Assigned(Node) then
    Project.ltspiceXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('eLTCSpiceFileName', '');
  if Assigned(Node) then
    Project.ltspiceCommand := Node.ChildNodes['Filename'].Text;
  Node := RootNode.ChildNodes.FindNode('eLTCSpiceOptions', '');
  if Assigned(Node) then
    Project.ltspiceCommandOptions := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eLTspiceBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.ltspiceLeftBracket := '_'
    else
      Project.ltspiceLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eLTspiceBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.ltspiceRightBracket := '_'
    else
      Project.ltspiceRightBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('cbPSpiceMixedSignal', '');
  if Assigned(Node) then
    Project.pspiceAD := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbPSspiceGND', '');
  if Assigned(Node) then
    Project.pspiceGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbPSspiceOmitPrefix', '');
  if Assigned(Node) then
    Project.pspiceOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbPSspiceShrink', '');
  if Assigned(Node) then
    Project.pspiceShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbPSspiceSubcircuit', '');
  if Assigned(Node) then
    Project.pspiceSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbPSspiceXGNDX', '');
  if Assigned(Node) then
    Project.pspiceXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('ePSpiceBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.pspiceLeftBracket := '_'
    else
      Project.pspiceLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('ePSpiceBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.pspiceRightBracket := '_'
    else
      Project.pspiceRightBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('ePspiceFileName', '');
  if Assigned(Node) then
    Project.pspiceCommand := Node.ChildNodes['Filename'].Text;
  Node := RootNode.ChildNodes.FindNode('ePspiceOptions', '');
  if Assigned(Node) then
    Project.pspiceCommandOptions := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('ePspiceWaveformTool', '');
  if Assigned(Node) then
    Project.pspiceViewer := Node.ChildNodes['Filename'].Text;

  Node := RootNode.ChildNodes.FindNode('cbHSpiceGND', '');
  if Assigned(Node) then
    Project.hspiceGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbHSpiceOmitPrefix', '');
  if Assigned(Node) then
    Project.hspiceOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbHSpiceShrink', '');
  if Assigned(Node) then
    Project.hspiceShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbHSpiceSubcircuit', '');
  if Assigned(Node) then
    Project.hspiceSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbHSpiceVerilogA', '');
  if Assigned(Node) then
    Project.hspiceVerilogA := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbHSpiceXGNDX', '');
  if Assigned(Node) then
    Project.hspiceXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('eHSpiceBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.hspiceLeftBracket := '_'
    else
      Project.hspiceLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eHSpiceBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.hspiceRightBracket := '_'
    else
      Project.hspiceRightBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eHSpiceFileName', '');
  if Assigned(Node) then
    Project.hspiceCommand := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eHSpiceOptions', '');
  if Assigned(Node) then
    Project.hspiceCommandOptions := Node.ChildNodes['FileName'].Text;
  Node := RootNode.ChildNodes.FindNode('eSpiceViewerCommand', '');
  if Assigned(Node) then
    Project.hspiceViewer := Node.ChildNodes['Text'].Text;
  Node := RootNode.ChildNodes.FindNode('eSpiceViewerOptions', '');
  if Assigned(Node) then
    Project.hspiceViewerOptions := Node.ChildNodes['Text'].Text;

  Node := RootNode.ChildNodes.FindNode('cbAPTBipolarArea', '');
  if Assigned(Node) then
    Project.aptBipolarArea := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTBipolarWL', '');
  if Assigned(Node) then
    Project.aptBipolarWL := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTGND', '');
  if Assigned(Node) then
    Project.aptGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTOmitPrefix', '');
  if Assigned(Node) then
    Project.aptOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTShrink', '');
  if Assigned(Node) then
    Project.aptShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTSubcircuit', '');
  if Assigned(Node) then
    Project.aptSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAPTXGNDX', '');
  if Assigned(Node) then
    Project.aptXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('eAPTBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.aptLeftBracket := '_'
    else
      Project.aptLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eAPTBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.aptRightBracket := '_'
    else
      Project.aptRightBracket := Node.ChildNodes['Text'].Text;
  end;

  Node := RootNode.ChildNodes.FindNode('cbAssuraBipolarArea', '');
  if Assigned(Node) then
    Project.assuraBipolarArea := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraBipolarWL', '');
  if Assigned(Node) then
    Project.assuraBipolarWL := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraGND', '');
  if Assigned(Node) then
    Project.assuraGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraOmitPrefix', '');
  if Assigned(Node) then
    Project.assuraOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraShrink', '');
  if Assigned(Node) then
    Project.assuraShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraSubcircuit', '');
  if Assigned(Node) then
    Project.assuraSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbAssuraXGNDX', '');
  if Assigned(Node) then
    Project.assuraXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('eAssuraBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.assuraLeftBracket := '_'
    else
      Project.assuraLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eAssuraBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.assuraRightBracket := '_'
    else
      Project.assuraRightBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eAssuraLVS_Short', '');
  if Assigned(Node) then
    Project.assuraShort := Node.ChildNodes['Text'].Text;

  Node := RootNode.ChildNodes.FindNode('cbDraculaBipolarArea', '');
  if Assigned(Node) then
    Project.draculaBipolarArea := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaBipolarWL', '');
  if Assigned(Node) then
    Project.draculaBipolarWL := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaGND', '');
  if Assigned(Node) then
    Project.draculaGND := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaOmitPrefix', '');
  if Assigned(Node) then
    Project.draculaOmitPrefix := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaShrink', '');
  if Assigned(Node) then
    Project.draculaShrink := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaSubcircuit', '');
  if Assigned(Node) then
    Project.draculaSubCircuit := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('cbDraculaXGNDX', '');
  if Assigned(Node) then
    Project.draculaXGNDX := Node.ChildNodes['Checked'].NodeValue;
  Node := RootNode.ChildNodes.FindNode('eDraculaBracketSubstitutionLeft', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.draculaLeftBracket := '_'
    else
      Project.draculaLeftBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eDraculaBracketSubstitutionRight', '');
  if Assigned(Node) then
  begin
    if (Node.ChildNodes['Text'].Text = '') then
      Project.draculaRightBracket := '_'
    else
      Project.draculaRightBracket := Node.ChildNodes['Text'].Text;
  end;
  Node := RootNode.ChildNodes.FindNode('eDraculaLVS_Short', '');
  if Assigned(Node) then
    Project.draculaShort := Node.ChildNodes['Text'].Text;

  { Read cbSchematics }
  Node := RootNode.ChildNodes.FindNode('cbSchematics', '');
  CNode := Node.ChildNodes['Items.Strings'];
  for I := 0 to (CNode.ChildNodes.Count - 1) do
  begin
    Project.lSchematicsUsed.Add(CNode.ChildNodes[I].Text);
  end;
  CNode := Node.ChildNodes.FindNode('Text', '');
  if Assigned(CNode) then
    Project.currentSchematics := CNode.Text;

  Node := RootNode.ChildNodes.FindNode('cbStim', '');
  CNode := Node.ChildNodes['Items.Strings'];
  for I := 0 to (CNode.ChildNodes.Count - 1) do
  begin
    Project.lStimulusUsed.Add(CNode.ChildNodes[I].Text);
  end;
  CNode := Node.ChildNodes.FindNode('Text', '');
  if Assigned(CNode) then
    Project.currentStimulus := CNode.Text;

  XDoc.Active := False;
  XDoc := nil;

  CodeSite.ExitMethod(Self, 'ReadXMLFileSetup6');
end;

procedure TMainForm.runEdifNetlist(bView: bool; sSchematicsFile: string);
var
  sCommand, sOptions, sArgument: string;
  sWindowTitle: string;
  TheWindow: HWnd;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: tProcessInformation;
begin
      { TMainForm.runVerilogNetlist }
  CodeSite.EnterMethod(Self, 'runEdifNetlist');

  FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
  with StartUpInfo do
  begin
    cb := SizeOf(TStartUpInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOWNORMAL
  end { with StartUpInfo };
  sWindowTitle := 'Hierarchy Navigator';
  TheWindow := FindWindow(PChar(sWindowTitle), nil);
  if (TheWindow <> 0) then
  begin
    SendMessage(TheWindow, WM_CLOSE, 0, 0)
  end { (TheWindow<>0) };
  sArgument := ' ' + IncludeTrailingPathDelimiter(Project.NetlistDir) +
    sSchematicsFile + '.sch';
  if (bView) then
  begin
    sOptions := ' -n'
  end { (bView) }
  else
  begin
    sOptions := ''
  end { not ((bView)) };
  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'edifnet.exe';
  sArgument := ' ' + sOptions + sArgument;
  sCommand := sCommand + sArgument;
  CreateProcess(nil, PChar(sCommand), nil, nil, true, NORMAL_PRIORITY_CLASS,
    nil, PChar(Project.NetlistDir), StartUpInfo, ProcessInfo);
  WaitForInputIdle(ProcessInfo.hProcess, infinite);

  CodeSite.ExitMethod(Self, 'runEdifNetlist');
end;

procedure TMainForm.runHSpice(sSimulationFile: string);
var
  sWindowTitle: string;
  TheWindow: HWnd;
  sInputFile, sOutputFile, sCommand, sWorkingDir, sArgument: string;
begin
  CodeSite.EnterMethod(Self, 'runHSpice');

  sWindowTitle := 'HSPUI';
  TheWindow := FindWindow(PChar(sWindowTitle), nil);
  if (TheWindow <> 0) then
  begin
    SendMessage(TheWindow, WM_CLOSE, 0, 0)
  end;
  sCommand := Trim(eHSpiceFileName.FileName);
  if FileExists(sCommand) then
  begin
    if FileExists(sSimulationFile) then
    begin
      sWorkingDir := ExtractFileDir(sSimulationFile);
      sInputFile := ExtractFileName(sSimulationFile);
      sOutputFile := ChangeFileExt(sInputFile, '.lis');
      sArgument := ' -i ' + sInputFile + ' -o ' + sOutputFile;
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
    end
    else
      MessageDlg(Format('File %s not found!', [sSimulationFile]), mtError,
        [mbOK], 0)
  end
  else
    MessageDlg(Format('File %s not found!', [sCommand]), mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'runHSpice');
end;

procedure TMainForm.runLTCSimNetlist(sSchematicsFile: string; bDisplay,
    bSimulate: Boolean);
var
  sHeaderFile, sLibraryHeaderFile: string;
  sWindowTitle: string;
  TheWindow: HWnd;
  bContinue: Boolean;
  sTemp: string;
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;
begin
  CodeSite.EnterMethod(Self, 'runLTCSimNetlist');

  SaveActiveProjectInformation;
  if not(cbLTspiceSchematics.checked) then
  begin
    bContinue := False;
    ParamString := ' -p=' + Project.XMLSetupFile71;
    ParamString := ParamString + ' ' + sSchematicsFile;
    sWindowTitle := 'Hierarchy Navigator';
    TheWindow := FindWindow(PChar(sWindowTitle), nil);
    if (TheWindow <> 0) then
      SendMessage(TheWindow, WM_CLOSE, 0, 0);
    if FileExists(sSchematicsFile) then
    begin
      case ToolInUse of
        LTspice:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            if bDisplay and not bSimulate then
              ParamString := ' -view ' + ParamString;
            if bSimulate then
              ParamString := ' -sim ' + ParamString;
            bContinue := true;
          end; { LTspice }
        HSpice:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            if bDisplay and not bSimulate then
              ParamString := ' -view ' + ParamString;
            if bSimulate then
              ParamString := ' -sim ' + ParamString;
            bContinue := true;
          end; { HSpice }
        PSpice:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            if bDisplay and not bSimulate then
              ParamString := ' -view ' + ParamString;
            if bSimulate then
              ParamString := ' -sim ' + ParamString;
            bContinue := true;
          end; { PSpice }
        Verilog:
          begin
            MessageDlg('You need to run this command from the Navigator.',
              mtInformation, [mbOK], 0);
            NavigateSchematics(sSchematicsFile);
            bContinue := False;
          end; { Verilog }
        Edif:
          begin
            MessageDlg('You need to run this command from the Navigator.',
              mtInformation, [mbOK], 0);
            NavigateSchematics(sSchematicsFile);
            bContinue := False;
          end; { Edif }
        APT:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            if bDisplay then
              ParamString := ' -view ' + ParamString;
            bContinue := true;
          end; { APT }
        Assura:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            sHeaderFile := ChangeFileExt(sSchematicsFile, '.alvh');
            sLibraryHeaderFile := IncludeTrailingPathDelimiter(Project.LibDir) +
              IncludeTrailingPathDelimiter('assura') + Process.Name + '.alvh';
            if (FileExists(sHeaderFile)) then
            begin
              bContinue := true;
            end
            else
            begin
              if (not(FileExists(sLibraryHeaderFile))) then
              begin
                MessageDlg(Format('File %s can not be found!',
                  [sLibraryHeaderFile]), mtError, [mbOK], 0);
              end
              else
              begin
                CopyFile(PChar(sLibraryHeaderFile), PChar(sHeaderFile), true);
                bContinue := true;
              end;
            end;
            if bDisplay then
              ParamString := ' -view ' + ParamString;
          end; { Assura }
        Dracula:
          begin
            ExecuteFile := IncludeTrailingPathDelimiter(LTCSim.Dir) +
              'LTCSimNetlist.exe';
            sHeaderFile := ChangeFileExt(sSchematicsFile, '.lvh');
            sLibraryHeaderFile := IncludeTrailingPathDelimiter(Project.LibDir) +
              IncludeTrailingPathDelimiter('dracula') + Process.Name + '.lvh';
            if (FileExists(sHeaderFile)) then
            begin
              bContinue := true;
            end
            else
            begin
              if (not(FileExists(sLibraryHeaderFile))) then
              begin
                MessageDlg(Format('File %s can not be found!',
                  [sLibraryHeaderFile]), mtError, [mbOK], 0);
              end
              else
              begin
                CopyFile(PChar(sLibraryHeaderFile), PChar(sHeaderFile), true);
                bContinue := true;
              end;
            end;
            if bDisplay then
              ParamString := ' -view ' + ParamString;
          end { Dracula }
      end; { case }
      if bContinue then
      begin
        StartInString := ExtractFileDir(sSchematicsFile);
        FillChar(SEInfo, SizeOf(SEInfo), 0);
        SEInfo.cbSize := SizeOf(TShellExecuteInfo);
        with SEInfo do
        begin
          fMask := SEE_MASK_NOCLOSEPROCESS;
          Wnd := Application.Handle;
          lpFile := PChar(ExecuteFile);
          lpParameters := PChar(ParamString);
          lpDirectory := PChar(StartInString);
          nShow := SW_SHOWNORMAL;
        end;
        if ShellExecuteEx(@SEInfo) then
        begin
          repeat
            Application.ProcessMessages;
            GetExitCodeProcess(SEInfo.hProcess, ExitCode);
          until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
          // ShowMessage('Netlist terminated') ;
          // Display netlist
        end
        else
          ShowMessage('Error starting Netlist!');
        if (cbFilterAfterNetlist.checked) then
        begin
          sTemp := ExtractFileName(sSchematicsFile);
          sTemp := ChangeFileExt(sTemp, '.*');
          JamShellListMain.Filter := sTemp;
          JamShellListMain.Update
        end
      end; { if bContinue }
    end { If schematics exist }
    else
    begin
      MessageDlg(Format('Schematics %s not found!', [sSchematicsFile]), mtError,
        [mbOK], 0)
    end
  end
  else
  begin
    if not(FileExists(sSchematicsFile)) then
      sSchematicsFile := ChangeFileExt(sSchematicsFile, '.sch');
    runLTspiceNetlist(sSchematicsFile)
  end;

  CodeSite.ExitMethod(Self, 'runLTCSimNetlist');
end;

procedure TMainForm.runLTspice(sSimulationFile: string);
var
  sCommand, sOptions, sWorkingDir, sArgument: string;
begin
  CodeSite.EnterMethod(Self, 'runLTspice');

  sCommand := Trim(eLTCSpiceFileName.FileName);
  sOptions := ' -LTCSim ' + eLTCSpiceOptions.Text + ' ';
  sWorkingDir := ExtractFileDir(sSimulationFile);
  sArgument := sOptions + ExtractFileName(sSimulationFile);
  if FileExists(sCommand) then
  begin
    if FileExists(sSimulationFile) then
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
    else
      MessageDlg(Format('File %s not found!',
        [IncludeTrailingPathDelimiter(sWorkingDir) + sSimulationFile]), mtError,
        [mbOK], 0)
  end
  else
    MessageDlg(Format('File %s not found!', [sCommand]), mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'runLTspice');
end;

procedure TMainForm.runLTspiceNetlist(sSchematics: string);
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  ExecuteFile, ParamString, StartInString: string;
  ExpectedFile: string;
begin
  CodeSite.EnterMethod(Self, 'runLTspiceNetlist');

  ExecuteFile := eLTCSpiceFileName.FileName;

  if FileExists(ExecuteFile) then
  begin
    if FileExists(sSchematics) then
    begin
      StartInString := ExtractFileDir(sSchematics);
      case ToolInUse of
        LTspice:
          ParamString := ' -LTCsim -netlist ' + ExtractFileName(sSchematics);
        PSpice:
          ParamString := ' -LTCsim -netlist ' + ExtractFileName(sSchematics);
        Dracula:
          ParamString := ' -LTCsim -LVS ' + ExtractFileName(sSchematics);
        Assura:
          ParamString := ' -LTCsim -Assura ' + ExtractFileName(sSchematics);
        APT:
          ParamString := ' -LTCsim -APT ' + ExtractFileName(sSchematics);
      end;
      FillChar(SEInfo, SizeOf(SEInfo), 0);
      SEInfo.cbSize := SizeOf(TShellExecuteInfo);
      with SEInfo do
      begin
        fMask := SEE_MASK_NOCLOSEPROCESS;
        Wnd := Application.Handle;
        lpFile := PChar(ExecuteFile);
        lpParameters := PChar(ParamString);
        lpDirectory := PChar(StartInString);
        nShow := SW_SHOWNORMAL;
      end;
      if ShellExecuteEx(@SEInfo) then
      begin
        repeat
          Application.ProcessMessages;
          GetExitCodeProcess(SEInfo.hProcess, ExitCode);
        until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
        case ToolInUse of
          LTspice:
            begin
              ExpectedFile := ChangeFileExt(sSchematics, '.net');
              if FileExists(ExpectedFile) then
                EditFile(ExpectedFile)
              else
                MessageDlg('File ' + ExpectedFile + ' not found', mtError,
                  [mbOK], 0);
            end;
          PSpice:
            begin
              ExpectedFile := ChangeFileExt(sSchematics, '.net');
              if FileExists(ExpectedFile) then
                EditFile(ExpectedFile)
              else
                MessageDlg('File ' + ExpectedFile + ' not found', mtError,
                  [mbOK], 0);
            end;
          Dracula:
            begin
              ExpectedFile := ChangeFileExt(sSchematics, '.lvs');
              if FileExists(ExpectedFile) then
                EditFile(ExpectedFile)
              else
                MessageDlg('File ' + ExpectedFile + ' not found', mtError,
                  [mbOK], 0);
            end;
          Assura:
            begin
              ExpectedFile := ChangeFileExt(sSchematics, '.lvs');
              if FileExists(ExpectedFile) then
                EditFile(ExpectedFile)
              else
                MessageDlg('File ' + ExpectedFile + ' not found', mtError,
                  [mbOK], 0);
            end;
          APT:
            begin
              ExpectedFile := ChangeFileExt(sSchematics, '.apt');
              if FileExists(ExpectedFile) then
                EditFile(ExpectedFile)
              else
                MessageDlg('File ' + ExpectedFile + ' not found', mtError,
                  [mbOK], 0);
            end;
        end;
      end
      else
        ShowMessage('Error starting Netlist!');
    end
    else
      MessageDlg('File ' + sSchematics + ' not found!', mtError, [mbOK], 0);
  end
  else
    MessageDlg('File ' + ExecuteFile + ' not found', mtError, [mbOK], 0);
  JamShellListMain.Update();

  CodeSite.ExitMethod(Self, 'runLTspiceNetlist');
end;

procedure TMainForm.runPSpice(sSimulationFile: string);
var
  sCommand, sOptions, sWorkingDir, sArgument: string;
begin
  CodeSite.EnterMethod(Self, 'runPSpice');

  sCommand := Trim(ePspiceFileName.FileName);
  sOptions := ePspiceOptions.Text + ' ';
  sWorkingDir := ExtractFileDir(sSimulationFile);
  sArgument := sOptions + ExtractFileName(sSimulationFile);
  if FileExists(sCommand) then
  begin
    if FileExists(sSimulationFile) then
      ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
        PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
    else
      MessageDlg(Format('File %s not found!',
        [IncludeTrailingPathDelimiter(sWorkingDir) + sSimulationFile]), mtError,
        [mbOK], 0)
  end
  else
    MessageDlg(Format('File %s not found!', [sCommand]), mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'runPSpice');
end;

procedure TMainForm.runSCSNavigator(sSchematicFile: string);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'runSCSNavigator');

  if (Pos(UpperCase(Project.Dir), UpperCase(ExtractFileDir(sSchematicFile))) > 0)
  then
  begin
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'hiernav.exe';
    sArgument := sSchematicFile;
    sWorkingDir := ExtractFileDir(sSchematicFile);
    ShellExecute(MainForm.Handle, 'open', PChar(sCommand), PChar(sArgument),
      PChar(sWorkingDir), SW_SHOWNORMAL);
  end
  else
  begin
    MessageDlg
      ('Schematics from a directory who does not belong to the project!',
      mtError, [mbOK], 0);
    Abort
  end;

  CodeSite.ExitMethod(Self, 'runSCSNavigator');
end;

procedure TMainForm.runSCSSchEditor(sSchematicFile: string);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'runSCSSchEditor');

  {
    if (StrStPosS(UpperCase(ExtractFileDir(sSchematicFile)),
    UpperCase(Project.Dir), iPos)) then
  }
  if (Pos(UpperCase(Project.Dir), UpperCase(ExtractFileDir(sSchematicFile))) > 0)
  then
  begin
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'schem.exe';
    sArgument := sSchematicFile;
    sWorkingDir := ExtractFileDir(sSchematicFile);
    ShellExecute(0, 'open', PChar(sCommand), PChar(sArgument),
      PChar(sWorkingDir), SW_SHOW)
  end
  else
  begin
    MessageDlg
      ('Schematics from a directory who does not belong to the project!',
      mtError, [mbOK], 0);
    Abort
  end;

  CodeSite.ExitMethod(Self, 'runSCSSchEditor');
end;

procedure TMainForm.runSCSSymEditor(sSchematicFile: string);
var
  sSchTempFile: string;
  sCommand, sArgument, sWorkingDir: string;
begin
      { TMainForm.runSCSSchEditor }
  CodeSite.EnterMethod(Self, 'runSCSSymEditor');

  {
    if StrStPosS(UpperCase(ExtractFileDir(sSchematicFile)),
    UpperCase(Project.Dir), iPos) then
  }
  if (Pos(UpperCase(Project.Dir), UpperCase(ExtractFileDir(sSchematicFile))) > 0)
  then
  begin
    sSchTempFile := IncludeTrailingPathDelimiter
      (ExtractFileDir(sSchematicFile)) +
    {
      JustNameS(sSchematicFile) + '._SY';
    }
      ChangeFileExt(sSchematicFile, '._SY');
    if FileExists(sSchTempFile) then
    begin
      if (MessageDlg
        ('Symbol already open or need to recover. Do you want to continue?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
      begin
        Abort;
      end
    end;
    sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'sym.exe';
    sArgument := sSchematicFile;
    sWorkingDir := ExtractFileDir(sSchematicFile);
    ShellExecute(MainForm.Handle, 'open', PChar(sCommand), PChar(sArgument),
      PChar(sWorkingDir), SW_SHOWNORMAL);
  end
  else
  begin
    MessageDlg('Symbol from a directory who does not belong to the project!',
      mtError, [mbOK], 0);
    Abort
  end;

  CodeSite.ExitMethod(Self, 'runSCSSymEditor');
end;

procedure TMainForm.runSimulation(sSimulationFile: string);
var
  sTemp: string;
begin
  CodeSite.EnterMethod(Self, 'runSimulation');

  SaveActiveProjectInformation;
  case ToolInUse of
    LTspice:
      runLTspice(sSimulationFile);
    PSpice:
      runPSpice(sSimulationFile);
    HSpice:
      runHSpice(sSimulationFile);
  end;
  if (cbFilterAfterNetlist.checked) then
  begin
    sTemp := ExtractFileName(sSimulationFile);
    JamShellListMain.Filter := ChangeFileExt(sTemp, '.*');
    JamShellListMain.Update
  end;

  CodeSite.ExitMethod(Self, 'runSimulation');
end;

procedure TMainForm.SaveActiveProjectInformation;
var
  sTemp: String;
begin
  CodeSite.EnterMethod(Self, 'SaveActiveProjectInformation');

  if ValidProject then
  begin
    sTemp := cbStim.Text;
    if (sTemp.StartsWith('\')) then
    begin
      sTemp := sTemp.Substring(1);
    end;
    sTemp := ExcludeTrailingPathDelimiter
      (ExtractFilePath(IncludeTrailingPathDelimiter(Project.SchemDir) + sTemp));
    Project.xmlSimulationDir :=
      RightStr(sTemp, (Length(sTemp) - Length(Project.SchemDir) - 1));
    SaveXMLFile71;
    SaveLTspiceIniFile;
    SaveActiveProjectToReg;
  end
  else
    MessageDlg('You need to have a valid project loaded!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'SaveActiveProjectInformation');
end;

procedure TMainForm.SaveActiveProjectToReg;
var
  RegActiveProject: TRegIniFile;
  sTemp: string;
begin
  CodeSite.EnterMethod(Self, 'SaveActiveProjectToReg');

  if ValidProject then
  begin
    RegActiveProject := TRegIniFile.Create('Software\LTC\LTCSim');
    try
      RegActiveProject.RootKey := HKEY_CURRENT_USER;
      with RegActiveProject do
      begin
        WriteString('ActiveProject', 'Directory', LTCSim.localProjectsDir);
        WriteString('ActiveProject', 'Project', Project.Name);
        WriteString('ActiveProject', 'Rev', Project.Rev);
        WriteString('ActiveProject', 'LTCSimDir', LTCSim.Dir);
        WriteString('ActiveProject', 'Process', Process.Name);
        WriteString('ActiveProject', 'netlistDir', Project.NetlistDir);
        WriteString('ActiveProject', 'ProjectIniFile', Project.IniFileName);
        WriteBool('ActiveProject', 'netlistSim', bNetlistSim);
        WriteBool('ActiveProject', 'LTCSimPrimitiveReport',
          cbPrimitiveReport.checked);
        WriteBool('ActiveProject', 'LTCSimIgnoreCase', cbIgnoreCase.checked);
        case ToolInUse of
          LTspice:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'LTspice');
              if (RadioGroupLTspiceSyntax.ItemIndex = 0) then
                WriteString('ActiveProject', 'Tool', '6')
              else
                WriteString('ActiveProject', 'Tool', '1');
            end;
          PSpice:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'PSpice');
              WriteString('ActiveProject', 'Tool', '0')
            end;
          HSpice:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'HSpice');
              WriteString('ActiveProject', 'Tool', '1')
            end;
          Dracula:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'Dracula');
              WriteString('ActiveProject', 'Tool', '2')
            end;
          Assura:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'Assura');
              WriteString('ActiveProject', 'Tool', '8')
            end;
          APT:
            begin
              WriteString('ActiveProject', 'ToolInUse', 'APT');
              WriteString('ActiveProject', 'Tool', '7')
            end;
          Verilog:
            begin
              WriteString('ActiveProject', 'Tool', '3')
            end;
          Edif:
            begin
              WriteString('ActiveProject', 'Tool', '4')
            end;
        end;
        WriteString('ActiveProject', 'SchemInUse',
          IncludeTrailingPathDelimiter(Project.SchemDir) + cbSchematics.Text);
        sTemp := IncludeTrailingPathDelimiter(Project.SchemDir) + cbStim.Text;
        Project.SimulationDir := ExtractFilePath(sTemp);
        WriteString('ActiveProject', 'simulationDir', Project.SimulationDir);
        WriteString('ActiveProject', 'StimInUse', ExtractFileName(sTemp));

        // LTspice
        WriteString('ActiveProject', 'LTspiceFileName',
          eLTCSpiceFileName.FileName);
        WriteString('ActiveProject', 'LTspiceOptions', eLTCSpiceOptions.Text);
        WriteBool('ActiveProject', 'LTspiceXGNDXTo0', cbLTspiceXGNDX.checked);
        WriteBool('ActiveProject', 'XGNDXTo0', cbLTspiceXGNDX.checked);
        WriteBool('ActiveProject', 'LTspiceGNDTo0', cbLTspiceGND.checked);
        WriteBool('ActiveProject', 'GNDTo0', cbLTspiceGND.checked);
        WriteBool('ActiveProject', 'LTspiceSubcircuit',
          cbLTspiceSubcircuit.checked);
        WriteBool('ActiveProject', 'Subcircuit', cbLTspiceSubcircuit.checked);
        WriteBool('ActiveProject', 'LTspiceOmitPrefix',
          cbLTspiceOmitPrefix.checked);
        WriteBool('ActiveProject', 'FilterPrefix', cbLTspiceOmitPrefix.checked);
        WriteBool('ActiveProject', 'LTspiceShrink', cbLTspiceShrink.checked);
        WriteBool('ActiveProject', 'Shrunk', cbLTspiceShrink.checked);
        if (eLTspiceBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'LTspiceBracketSubstitutionLeft',
            eLTspiceBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'LTspiceBracketSubstitutionLeft', '_');
        if (eLTspiceBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'LTspiceBracketSubstitutionRight',
            eLTspiceBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'LTspiceBracketSubstitutionRight', '_');
        WriteInteger('ActiveProject', 'LTspiceNetlistSyntax',
          RadioGroupLTspiceSyntax.ItemIndex);
        // PSpice
        WriteString('ActiveProject', 'PSpiceFileName',
          ePspiceFileName.FileName);
        WriteString('ActiveProject', 'PSpiceWaveformTool',
          ePspiceWaveformTool.FileName);
        WriteString('ActiveProject', 'PSpiceOptions', ePspiceOptions.Text);
        WriteBool('ActiveProject', 'PSpiceXGNDXTo0', cbPSspiceXGNDX.checked);
        WriteBool('ActiveProject', 'PSpiceGNDTo0', cbPSspiceGND.checked);
        WriteBool('ActiveProject', 'PSpiceSubcircuit',
          cbPSspiceSubcircuit.checked);
        WriteBool('ActiveProject', 'PSpiceMixedSignal',
          cbPSpiceMixedSignal.checked);
        WriteBool('ActiveProject', 'PSspiceOmitPrefix',
          cbPSspiceOmitPrefix.checked);
        WriteBool('ActiveProject', 'PSspiceShrink', cbPSspiceShrink.checked);
        if (ePSpiceBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'PSpiceBracketSubstitutionLeft',
            ePSpiceBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'PSpiceBracketSubstitutionLeft', '_');
        if (ePSpiceBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'PSpiceBracketSubstitutionRight',
            ePSpiceBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'PSpiceBracketSubstitutionRight', '_');

        // HSpice
        WriteString('ActiveProject', 'HSpiceFileName',
          eHSpiceFileName.FileName);
        WriteString('ActiveProject', 'HSpiceOptions', eHSpiceOptions.Text);
        WriteString('ActiveProject', 'SpiceViewerCommand',
          eHSpiceViewerCommand.FileName);
        WriteString('ActiveProject', 'SpiceViewerOptions',
          eHSpiceViewerOptions.Text);
        WriteBool('ActiveProject', 'HSpiceXGNDXTo0', cbHSpiceXGNDX.checked);
        WriteBool('ActiveProject', 'HSpiceGNDTo0', cbHSpiceGND.checked);
        WriteBool('ActiveProject', 'HSpiceSubcircuit',
          cbHSpiceSubcircuit.checked);
        WriteBool('ActiveProject', 'HSpiceVerilogA', cbHSpiceVerilogA.checked);
        WriteBool('ActiveProject', 'HSpiceOmitPrefix',
          cbHSpiceOmitPrefix.checked);
        WriteBool('ActiveProject', 'HSpiceShrink', cbHSpiceShrink.checked);
        if (eHSpiceBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'HSpiceBracketSubstitutionLeft',
            eHSpiceBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'HSpiceBracketSubstitutionLeft', '_');
        if (eHSpiceBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'HSpiceBracketSubstitutionRight',
            eHSpiceBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'HSpiceBracketSubstitutionRight', '_');

        // APT
        WriteBool('ActiveProject', 'APTXGNDXTo0', cbAPTXGNDX.checked);
        WriteBool('ActiveProject', 'APTGNDTo0', cbAPTGND.checked);
        WriteBool('ActiveProject', 'APTSubcircuit', cbAPTSubcircuit.checked);
        WriteBool('ActiveProject', 'APTOmitPrefix', cbAPTOmitPrefix.checked);
        WriteBool('ActiveProject', 'APTBipolarWL', cbAPTBipolarWL.checked);
        WriteBool('ActiveProject', 'APTBipolarArea', cbAPTBipolarArea.checked);
        WriteBool('ActiveProject', 'APTShrink', cbAPTShrink.checked);
        if (eAPTBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'APTBracketSubstitutionLeft',
            eAPTBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'APTBracketSubstitutionLeft', '_');
        if (eAPTBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'APTBracketSubstitutionRight',
            eAPTBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'APTBracketSubstitutionRight', '_');

        // Assura
        WriteBool('ActiveProject', 'AssuraXGNDXTo0', cbAssuraXGNDX.checked);
        WriteBool('ActiveProject', 'AssuraGNDTo0', cbAssuraGND.checked);
        WriteBool('ActiveProject', 'AssuraSubcircuit',
          cbAssuraSubcircuit.checked);
        WriteBool('ActiveProject', 'AssuraOmitPrefix',
          cbAssuraOmitPrefix.checked);
        WriteBool('ActiveProject', 'AssuraBipolarWL',
          cbAssuraBipolarWL.checked);
        WriteBool('ActiveProject', 'AssuraBipolarArea',
          cbAssuraBipolarArea.checked);
        WriteBool('ActiveProject', 'AssuraShrink', cbAssuraShrink.checked);
        if (eAssuraBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'AssuraBracketSubstitutionLeft',
            eAssuraBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'AssuraBracketSubstitutionLeft', '_');
        if (eAssuraBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'AssuraBracketSubstitutionRight',
            eAssuraBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'AssuraBracketSubstitutionRight', '_');
        if (eAssuraLVS_Short.Text <> '') then
          WriteString('ActiveProject', 'AssuraLVSShort', eAssuraLVS_Short.Text)
        else
          WriteString('ActiveProject', 'AssuraLVSShort', '0.01');
        // Dracula
        WriteBool('ActiveProject', 'DraculaXGNDXTo0', cbDraculaXGNDX.checked);
        WriteBool('ActiveProject', 'DraculaGNDTo0', cbDraculaGND.checked);
        WriteBool('ActiveProject', 'DraculaSubcircuit',
          cbDraculaSubcircuit.checked);
        WriteBool('ActiveProject', 'DraculaOmitPrefix',
          cbDraculaOmitPrefix.checked);
        WriteBool('ActiveProject', 'DraculaBipolarWL',
          cbDraculaBipolarWL.checked);
        WriteBool('ActiveProject', 'DraculaBipolarArea',
          cbDraculaBipolarArea.checked);
        WriteBool('ActiveProject', 'DraculaShrink', cbDraculaShrink.checked);
        if (eDraculaBracketSubstitutionLeft.Text <> '') then
          WriteString('ActiveProject', 'DraculaBracketSubstitutionLeft',
            eDraculaBracketSubstitutionLeft.Text)
        else
          WriteString('ActiveProject', 'DraculaBracketSubstitutionLeft', '_');
        if (eDraculaBracketSubstitutionRight.Text <> '') then
          WriteString('ActiveProject', 'DraculaBracketSubstitutionRight',
            eDraculaBracketSubstitutionRight.Text)
        else
          WriteString('ActiveProject', 'DraculaBracketSubstitutionRight', '_');
        if (eDraculaLVS_Short.Text <> '') then
          WriteString('ActiveProject', 'DraculaLVSShort',
            eDraculaLVS_Short.Text)
        else
          WriteString('ActiveProject', 'DraculaLVSShort', '0.01');
      end
    finally
      RegActiveProject.Free;
    end;
  end
  else
    MessageDlg('You need to have a valid project loaded!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'SaveActiveProjectToReg');
end;

procedure TMainForm.SaveLTCSimOptions(sLTCSimOptionsFile: String);
var
  XDoc: IXMLDocument;
  RootNode, Node: IXMLNode;

begin
  CodeSite.EnterMethod(Self, 'SaveLTCSimOptions');

  XDoc := TXMLDocument.Create(nil);
  XDoc.Active := true;
  XDoc := LoadXMLDocument(sLTCSimOptionsFile);
  cbFilterAfterNetlist.checked := cbFilterAfterNetlist.checked;
  cbFilterAfterSimulation.checked := cbFilterAfterSimulation.checked;
  LTCSim.ArchiveNetlistIndex := rgArchiveNetlist.ItemIndex;
  cbLocation.Text := cbLocation.Text;
  try
    XDoc.Active := true;
    RootNode := XDoc.DocumentElement;

    Node := RootNode.ChildNodes.FindNode('tbTextEditorExe');
    Node.Text := eTextEditor.Path;
    Node := RootNode.ChildNodes.FindNode('localProjectsDir');
    Node.Text := LTCSim.localProjectsDir;
    Node := RootNode.ChildNodes.FindNode('rbAssuraToLayout');
    Node.NodeValue := LTCSim.AssuraToLayout;
    Node := RootNode.ChildNodes.FindNode('cbCaseSensitive');
    Node.NodeValue := cbIgnoreCase.checked;
    Node := RootNode.ChildNodes.FindNode('cbFilterAfterNetlist');
    Node.NodeValue := cbFilterAfterNetlist.checked;
    Node := RootNode.ChildNodes.FindNode('cbFilterAfterSimulation');
    Node.NodeValue := cbFilterAfterSimulation.checked;
    Node := RootNode.ChildNodes.FindNode('cbFilterAfterSchematics');
    Node.NodeValue := cbFilterAfterSchematics.checked;
    Node := RootNode.ChildNodes.FindNode('userName');
    Node.Text := eUserName.Text;
    Node := RootNode.ChildNodes.FindNode('userPassword');
    Node.Text := eUserPassword.Text;
    Node := RootNode.ChildNodes.FindNode('computeServer');
    Node.Text := eComputeServer.Text;
    Node := RootNode.ChildNodes.FindNode('location');
    Node.Text := cbLocation.Text;

    XDoc.SaveToFile(sLTCSimOptionsFile);
    XDoc.Active := False;
  finally
    XDoc := nil;
  end;

  CodeSite.ExitMethod(Self, 'SaveLTCSimOptions');
end;

procedure TMainForm.SaveLTspiceIniFile;
var
  ProjectLTspiceIniFile: TIniFile;
begin
      { TMainForm.CreateLTspiceIniFile }
  CodeSite.EnterMethod(Self, 'SaveLTspiceIniFile');

  ProjectLTspiceIniFile := TIniFile.Create(Project.LTspiceIniFileName);
  try
    with ProjectLTspiceIniFile do
    begin
      WriteBool('Project', 'LTspiceXGNDXTo0', Project.ltspiceXGNDX);
      WriteBool('Project', 'LTspiceGNDTo0', Project.ltspiceGND);
      WriteBool('Project', 'LTspiceShrink', Project.ltspiceShrink);
      WriteBool('Project', 'AssuraBipolarArea', Project.assuraBipolarArea);
      WriteBool('Project', 'AssuraBipolarWL', Project.assuraBipolarWL);
      WriteBool('Project', 'DraculaBipolarArea', Project.draculaBipolarArea);
      WriteBool('Project', 'DraculaBipolarWL', Project.draculaBipolarWL);
    end;
  finally
    ProjectLTspiceIniFile.Free;
  end;

  CodeSite.ExitMethod(Self, 'SaveLTspiceIniFile');
end;

procedure TMainForm.SaveXMLFile71;
var
  XDoc: IXMLDocument;
  RootNode, Node, CNode: IXMLNode;
  I: Integer;

begin
  CodeSite.EnterMethod(Self, 'SaveXMLFile71');

  XDoc := TXMLDocument.Create(nil);
  try
    XDoc.Active := true;
    XDoc.Options := [doNodeAutoIndent];
    XDoc.Version := '1.0';

    UpdateProjectVariables;
    RootNode := XDoc.AddChild('LTCSimProject');
    Node := RootNode.AddChild('Project');
    CNode := Node.AddChild('name');
    CNode.Text := Project.Name;
    CNode := Node.AddChild('rev');
    CNode.Text := Project.Rev;;
    CNode := Node.AddChild('ignoreCase');
    CNode.NodeValue := Project.ignoreCase;
    CNode := Node.AddChild('currentSchematics');
    CNode.NodeValue := cbSchematics.Text;
    CNode := Node.AddChild('currentStimulus');
    CNode.NodeValue := cbStim.Text;
    CNode := Node.AddChild('currentTool');
    CNode.NodeValue := cbTool.Text;
    CNode := Node.AddChild('schemDir');
    CNode.NodeValue := Project.SchemDir;
    CNode := Node.AddChild('relSimDir');
    CNode.NodeValue := Project.SimulationDir;
    CNode := Node.AddChild('primReport');
    CNode.NodeValue := Project.primitiveReport;

    Node := RootNode.AddChild('Process');
    CNode := Node.AddChild('name');
    CNode.Text := Process.Name;
    CNode := Node.AddChild('rev');
    CNode.Text := Process.Rev;
    CNode := Node.AddChild('promis');
    CNode.Text := Process.Promis;
    CNode := Node.AddChild('option1');
    CNode.Text := Process.option1;
    CNode := Node.AddChild('option1Code');
    CNode.Text := Process.option1Code;
    CNode := Node.AddChild('option1Name');
    CNode.Text := Process.option1Name;
    CNode := Node.AddChild('option2');
    CNode.Text := Process.option2;
    CNode := Node.AddChild('option2Code');
    CNode.Text := Process.option2Code;
    CNode := Node.AddChild('option2Name');
    CNode.Text := Process.option2Name;
    CNode := Node.AddChild('genericRev');
    CNode.Text := Process.GenericRev;

    Node := RootNode.AddChild('LTspice');
    CNode := Node.AddChild('ltspiceGND');
    CNode.NodeValue := Project.ltspiceGND;
    CNode := Node.AddChild('ltspiceXGNDX');
    CNode.NodeValue := Project.ltspiceXGNDX;
    CNode := Node.AddChild('ltspiceOmitPrefix');
    CNode.NodeValue := Project.ltspiceOmitPrefix;
    CNode := Node.AddChild('ltspiceShrink');
    CNode.NodeValue := Project.ltspiceShrink;
    CNode := Node.AddChild('ltspiceSubCircuit');
    CNode.NodeValue := Project.ltspiceSubCircuit;
    CNode := Node.AddChild('ltspiceschematics');
    CNode.NodeValue := Project.ltspiceschematics;
    CNode := Node.AddChild('ltspiceLeftBracket');
    CNode.Text := Project.ltspiceLeftBracket;
    CNode := Node.AddChild('ltspiceRightBracket');
    CNode.Text := Project.ltspiceRightBracket;
    CNode := Node.AddChild('ltspiceCommand');
    CNode.Text := Project.ltspiceCommand;
    CNode := Node.AddChild('ltspiceCommandOptions');
    CNode.Text := Project.ltspiceCommandOptions;
    CNode := Node.AddChild('ltspiceSyntax');
    CNode.NodeValue := Project.ltspiceSyntax;

    Node := RootNode.AddChild('PSpice');
    CNode := Node.AddChild('pspiceGND');
    CNode.NodeValue := Project.pspiceGND;
    CNode := Node.AddChild('pspiceXGNDX');
    CNode.NodeValue := Project.pspiceXGNDX;
    CNode := Node.AddChild('pspiceOmitPrefix');
    CNode.NodeValue := Project.pspiceOmitPrefix;
    CNode := Node.AddChild('pspiceShrink');
    CNode.NodeValue := Project.pspiceShrink;
    CNode := Node.AddChild('pspiceSubCircuit');
    CNode.NodeValue := Project.pspiceSubCircuit;
    CNode := Node.AddChild('pspiceAD');
    CNode.NodeValue := Project.pspiceAD;
    CNode := Node.AddChild('pspiceLeftBracket');
    CNode.Text := Project.pspiceLeftBracket;
    CNode := Node.AddChild('pspiceRightBracket');
    CNode.Text := Project.pspiceRightBracket;
    CNode := Node.AddChild('pspiceCommand');
    CNode.Text := Project.pspiceCommand;
    CNode := Node.AddChild('pspiceCommandOptions');
    CNode.Text := Project.pspiceCommandOptions;
    CNode := Node.AddChild('pspiceViewer');
    CNode.Text := Project.pspiceViewer;
    CNode := Node.AddChild('pspiceViewerOptions');
    CNode.Text := Project.pspiceViewerOptions;

    Node := RootNode.AddChild('HSpice');
    CNode := Node.AddChild('hspiceGND');
    CNode.NodeValue := Project.hspiceGND;
    CNode := Node.AddChild('hspiceXGNDX');
    CNode.NodeValue := Project.hspiceXGNDX;
    CNode := Node.AddChild('hspiceOmitPrefix');
    CNode.NodeValue := Project.hspiceOmitPrefix;
    CNode := Node.AddChild('hspiceShrink');
    CNode.NodeValue := Project.hspiceShrink;
    CNode := Node.AddChild('hspiceSubCircuit');
    CNode.NodeValue := Project.hspiceSubCircuit;
    CNode := Node.AddChild('hspiceVerilogA');
    CNode.NodeValue := Project.hspiceVerilogA;
    CNode := Node.AddChild('hspiceLeftBracket');
    CNode.Text := Project.hspiceLeftBracket;
    CNode := Node.AddChild('hspiceRightBracket');
    CNode.Text := Project.hspiceRightBracket;
    CNode := Node.AddChild('hspiceCommand');
    CNode.Text := Project.hspiceCommand;
    CNode := Node.AddChild('hspiceCommandOptions');
    CNode.Text := Project.hspiceCommandOptions;
    CNode := Node.AddChild('hspiceViewer');
    CNode.Text := Project.hspiceViewer;
    CNode := Node.AddChild('hspiceViewerOptions');
    CNode.Text := Project.hspiceViewerOptions;

    Node := RootNode.AddChild('APT');
    CNode := Node.AddChild('aptBipolarArea');
    CNode.NodeValue := Project.aptBipolarArea;
    CNode := Node.AddChild('aptBipolarWL');
    CNode.NodeValue := Project.aptBipolarWL;
    CNode := Node.AddChild('aptGND');
    CNode.NodeValue := Project.aptGND;
    CNode := Node.AddChild('aptXGNDX');
    CNode.NodeValue := Project.aptXGNDX;
    CNode := Node.AddChild('aptOmitPrefix');
    CNode.NodeValue := Project.aptOmitPrefix;
    CNode := Node.AddChild('aptShrink');
    CNode.NodeValue := Project.aptShrink;
    CNode := Node.AddChild('aptSubCircuit');
    CNode.NodeValue := Project.aptSubCircuit;
    CNode := Node.AddChild('aptLeftBracket');
    CNode.Text := Project.aptLeftBracket;
    CNode := Node.AddChild('aptRightBracket');
    CNode.Text := Project.aptRightBracket;
    CNode := Node.AddChild('aptShort');
    CNode.Text := Project.aptShort;

    Node := RootNode.AddChild('Assura');
    CNode := Node.AddChild('assuraBipolarArea');
    CNode.NodeValue := Project.assuraBipolarArea;
    CNode := Node.AddChild('assuraBipolarWL');
    CNode.NodeValue := Project.assuraBipolarWL;
    CNode := Node.AddChild('assuraGND');
    CNode.NodeValue := Project.assuraGND;
    CNode := Node.AddChild('assuraXGNDX');
    CNode.NodeValue := Project.assuraXGNDX;
    CNode := Node.AddChild('assuraOmitPrefix');
    CNode.NodeValue := Project.assuraOmitPrefix;
    CNode := Node.AddChild('assuraShrink');
    CNode.NodeValue := Project.assuraShrink;
    CNode := Node.AddChild('assuraSubCircuit');
    CNode.NodeValue := Project.assuraSubCircuit;
    CNode := Node.AddChild('assuraLeftBracket');
    CNode.Text := Project.assuraLeftBracket;
    CNode := Node.AddChild('assuraRightBracket');
    CNode.Text := Project.assuraRightBracket;
    CNode := Node.AddChild('assuraShort');
    CNode.Text := Project.assuraShort;

    Node := RootNode.AddChild('Dracula');
    CNode := Node.AddChild('draculaBipolarArea');
    CNode.NodeValue := Project.draculaBipolarArea;
    CNode := Node.AddChild('draculaBipolarWL');
    CNode.NodeValue := Project.draculaBipolarWL;
    CNode := Node.AddChild('draculaGND');
    CNode.NodeValue := Project.draculaGND;
    CNode := Node.AddChild('draculaXGNDX');
    CNode.NodeValue := Project.draculaXGNDX;
    CNode := Node.AddChild('draculaOmitPrefix');
    CNode.NodeValue := Project.draculaOmitPrefix;
    CNode := Node.AddChild('draculaShrink');
    CNode.NodeValue := Project.draculaShrink;
    CNode := Node.AddChild('draculaSubCircuit');
    CNode.NodeValue := Project.draculaSubCircuit;
    CNode := Node.AddChild('draculaLeftBracket');
    CNode.Text := Project.draculaLeftBracket;
    CNode := Node.AddChild('draculaRightBracket');
    CNode.Text := Project.draculaRightBracket;
    CNode := Node.AddChild('draculaShort');
    CNode.Text := Project.draculaShort;

    { Save cbSchematics }
    Node := RootNode.AddChild('Schematics');
    for I := 0 to (cbSchematics.Items.Count - 1) do
    begin
      Node.AddChild('Text').Text := cbSchematics.Items.Strings[I];
    end;

    { Save cbStim }
    Node := RootNode.AddChild('Stimulus');
    for I := 0 to (cbSchematics.Items.Count - 1) do
    begin
      Node.AddChild('Text').Text := cbStim.Items.Strings[I];
    end;

    XDoc.SaveToFile(Project.XMLSetupFile71);
    XDoc.Active := False;
  finally
    XDoc := nil;
  end;

  CodeSite.ExitMethod(Self, 'SaveXMLFile71');
end;

procedure TMainForm.SetDirectoryBrowsers(Directory: string);
begin
  CodeSite.EnterMethod(Self, 'SetDirectoryBrowsers');

  JamShellListMain.Path := Directory;
  // JamShellTreeMain.TopItem. := Directory;
  // LMDShellTree.Folder.ChDir(Directory);

  CodeSite.ExitMethod(Self, 'SetDirectoryBrowsers');
end;

procedure TMainForm.SimulateClick(Sender: TObject);
var
  sSimulationFile: string;
begin
  CodeSite.EnterMethod(Self, 'SimulateClick');

  sSimulationFile := cbStim.Text;
  if (sSimulationFile <> '') then
  begin
    sSimulationFile := IncludeTrailingPathDelimiter(Project.SchemDir) +
      sSimulationFile;
    if FileExists(sSimulationFile) then
      runSimulation(sSimulationFile)
    else
      MessageDlg(sSimulationFile + ' not found!.', mtError, [mbOK], 0)
  end
  else
    MessageDlg('Stimulus/Simulation file missing!.', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'SimulateClick');
end;

procedure TMainForm.Start1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Start1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-start';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Start1Click');
end;

procedure TMainForm.StartECSIniEditor;
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'StartECSIniEditor');

  sCommand := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'iniedit.exe';
  sArgument := Project.IniFileName;
  sWorkingDir := Project.SchemDir;
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_SHOWNORMAL);

  CodeSite.ExitMethod(Self, 'StartECSIniEditor');
end;

procedure TMainForm.StartListMenu(Sender: TObject);
var
  sFileName: string;
  sFileExtension: string;
begin
  CodeSite.EnterMethod(Self, 'StartListMenu');

  if (JamShellListMain.SelCount > 1) then
    MessageDlg('You need to select just one file!', mtError, [mbOK], 0)
  else
  begin
    sFileName := JamShellListMain.Path + JamShellListMain.SelectedFiles[0];
    sFileExtension := ExtractFileExt(sFileName);
    with Sender as TMenuItem do
    begin
      case tag of
        1:
          begin
            if ((sFileExtension = '.txt') or (sFileExtension = '.spi') or
              (sFileExtension = '.lvh') or (sFileExtension = '.lvs') or
              (sFileExtension = '.alvh') or (sFileExtension = '.net') or
              (sFileExtension = '.apt') or (sFileExtension = '.alvs') or
              (sFileExtension = '.a') or (sFileExtension = '.l') or
              (sFileExtension = '.p') or (sFileExtension = '.h') or
              (sFileExtension = '.cir') or (sFileExtension = '.v') or
              (sFileExtension = '.edf') or (sFileExtension = '.list') or
              (sFileExtension = '.sp')) then
              EditFile(sFileName);
            if ((sFileExtension = '.sch') or (sFileExtension = '.asc')) then
              EditSchematics(sFileName);
            if (sFileExtension = '.sym') then
              EditSymbol(sFileName);
          end;
        2:
          begin
            if ((sFileExtension = '.sch') or (sFileExtension = '.tre')) then
              NavigateSchematics(sFileName)
            else
              MessageDlg('File can not be used with Navigator!', mtError,
                [mbOK], 0);
          end;
        3:
          if (sFileExtension = '.sch') then
            runLTCSimNetlist(sFileName, true, False)
          else
            MessageDlg('File can not be used for netlisting!', mtError,
              [mbOK], 0);
        4:
          if ((sFileExtension = '.cir') or (sFileExtension = '.sp')) then
            runSimulation(sFileName)
          else
            MessageDlg('File can not be used for simulation!', mtError,
              [mbOK], 0);
      end
    end
  end;

  CodeSite.ExitMethod(Self, 'StartListMenu');
end;

procedure TMainForm.StartSCSShell;
var
  sWindowTitle: string;
  sWorkingDir: string;
  TheWindow: HWnd;
begin
  CodeSite.EnterMethod(Self, 'StartSCSShell');

  sWindowTitle := 'Silicon Canvas - AMS Designer';
  TheWindow := FindWindow(nil, PChar(sWindowTitle));
  if (TheWindow <> 0) then
  begin
    SendMessage(TheWindow, WM_CLOSE, 0, 0);
    TimeDelay(500);
    TheWindow := FindWindow(nil, PChar(sWindowTitle));
    if (TheWindow <> 0) then
      ShowMessage
        ('License manager could not be stopped. Close it manually (HDSShell.exe task)');
  end;
  with AppIcons.IconModule.LMDStarterShell do
  begin
    Command := IncludeTrailingPathDelimiter(LTCSim.Dir) + 'HDSShell.exe';
    DefaultDir := Project.SchemDir;
    Parameters := ' -ini ' + Project.IniFileName + ' -startdir ' + sWorkingDir;
    Execute;
    HDSShellHandle := Process;
  end;
  LTCSim.shellLicenseStarted := true;

  CodeSite.ExitMethod(Self, 'StartSCSShell');
end;

procedure TMainForm.Stop1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Stop1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-stop';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Stop1Click');
end;

procedure TMainForm.StopSCSShell;
var
  sWindowTitle: string;
  TheWindow: HWnd;
begin
  CodeSite.EnterMethod(Self, 'StopSCSShell');

  { Checking for Schematic Editor }
  sWindowTitle := 'Schematic Editor';
  TheWindow := FindWindow(PChar(sWindowTitle), nil);
  if (TheWindow <> 0) then
  begin
    ShowMessage
      ('You need to close all schematic windows before you exit LTCSim.');
    Abort;
  end;
  TimeDelay(200);
  { Checking for Hierarchy Navigator }
  sWindowTitle := 'Hierarchy Navigator';
  TheWindow := FindWindow(PChar(sWindowTitle), nil);
  if (TheWindow <> 0) then
  begin
    SendMessage(TheWindow, WM_CLOSE, 0, 0);
    TimeDelay(500);
    TheWindow := FindWindow(nil, PChar(sWindowTitle));
    if (TheWindow <> 0) then
      ShowMessage
        ('Hierarchy Navigator could not be stopped. Close it manually.');
  end;
  TimeDelay(200);
  with AppIcons.IconModule.LMDStarterShell do
    TerminateProcess;

  CodeSite.ExitMethod(Self, 'StopSCSShell');
end;

function TMainForm.TimeDelay(seconds: DWORD): Boolean;
var
  StartTick: DWORD;
  Running: Boolean;
begin
  CodeSite.EnterMethod(Self, 'TimeDelay');

  Running := true;
  StartTick := GetTickCount;
  while Running do
  begin
    if ((GetTickCount - StartTick) > seconds) then
    begin
      Running := False
    end;
    Application.ProcessMessages;
  end;
  Result := true;

  CodeSite.ExitMethod(Self, 'TimeDelay');
end;

procedure TMainForm.ToolButtonBckClick(Sender: TObject);
var
  sCommand, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'ToolButtonBckClick');

  sCommand := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\Utilities\LTCBackAnnotate.exe';
  sWorkingDir := Project.SchemDir;
  if (FileExists(sCommand)) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand), nil,
      PChar(sWorkingDir), SW_NORMAL)
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ToolButtonBckClick');
end;

procedure TMainForm.ToolButtonTopFormClick(Sender: TObject);
var
  sSchematics: string;
  sStimulus: string;
  sFileExtension: string;
begin
  CodeSite.EnterMethod(Self, 'ToolButtonTopFormClick');

  if ValidProject() then
  begin
    if not cbLTspiceSchematics.checked then
      sFileExtension := '.sch'
    else
      sFileExtension := '.asc';
    sSchematics := IncludeTrailingPathDelimiter(Project.SchemDir) +
      cbSchematics.Text + sFileExtension;
    sStimulus := IncludeTrailingPathDelimiter(Project.SchemDir) + cbStim.Text;
    Project.SimulationDir := ExtractFilePath(sStimulus);
    with Sender as TLMDSpeedButton do
    begin
      case tag of
        1:
          EditSchematics(sSchematics);
        2:
          NavigateSchematics(sSchematics);
        3:
          EditStimulus;
        5:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runLTCSimNetlist(sSchematics, true, False)
          end;
        6:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runSimulation(sStimulus)
          end;
        7:
          begin
            if (cbTool.Text = '') then
            begin
              MessageDlg('You need to select the tool to use!', mtError,
                [mbOK], 0);
              Exit;
            end
            else
              runLTCSimNetlist(sSchematics, true, true)
          end;
      end
    end
  end
  else
    MessageDlg('You need a valid project loaded first!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'ToolButtonTopFormClick');
end;

procedure TMainForm.TransferAndBuildFiles(sIniFile, DirectoryDest: string);
var
  IniFile: TIniFile;
  DirectorySource: string;
  filesToTransfer, filesToBuild, modelFiles: TStringList;
  sModelFile: string;
  I, j: Integer;
begin
  CodeSite.EnterMethod(Self, 'TransferAndBuildFiles');

  DirectorySource := ExtractFileDir(sIniFile);
  IniFile := TIniFile.Create(sIniFile);
  { Models to Transfer }
  filesToTransfer := TStringList.Create;
  IniFile.ReadSection('files_to_transfer', filesToTransfer);
  if (filesToTransfer.Count > 0) then
    TransferFileList(filesToTransfer, DirectorySource, DirectoryDest);
  { Build model files }
  filesToBuild := TStringList.Create;
  modelFiles := TStringList.Create;
  IniFile.ReadSection('files_to_build', filesToBuild);
  if (filesToBuild.Count > 0) then
  begin
    for I := 0 to (filesToBuild.Count - 1) do
    begin
      modelFiles.Clear;
      IniFile.ReadSection(filesToBuild[I], modelFiles);
      sModelFile := IncludeTrailingPathDelimiter(DirectoryDest) +
        filesToBuild[I];
      for j := 0 to (modelFiles.Count - 1) do
        modelFiles[j] := '.lib ' + IncludeTrailingPathDelimiter(DirectoryDest) +
          modelFiles[j];
      modelFiles.SaveToFile(sModelFile);
    end;
  end;
  IniFile.Free;
  filesToTransfer.Free;
  filesToBuild.Free;
  modelFiles.Free;

  CodeSite.ExitMethod(Self, 'TransferAndBuildFiles');
end;

function TMainForm.TransferFileList(StringOfFiles: TStringList; DirectorySource,
    DirectoryDest: string): Integer;
var
  sSource, sDest: string;
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'TransferFileList');

  AppIcons.IconModule.JamFileOperation.Options :=
    [soFilesOnly, soNoConfirmation];
  AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
  AppIcons.IconModule.JamFileOperation.Operation := otCopy;
  AppIcons.IconModule.JamFileOperation.Destination := DirectoryDest;
  sSource := '';
  sDest := '';
  for I := 0 to (StringOfFiles.Count - 1) do
    AppIcons.IconModule.JamFileOperation.SourceFiles.Add
      (IncludeTrailingPathDelimiter(DirectorySource) +
      StringOfFiles.Strings[I]);
  if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
    MessageDlg('Error transferring files from ' + DirectorySource + ' to ' +
      DirectoryDest + '.', mtError, [mbOK], 0);
  Result := 0;

  CodeSite.ExitMethod(Self, 'TransferFileList');
end;

procedure TMainForm.TransferSymbols;
var
  sLine, sTemp, sDevice, sName: string;
  sMainSpiceModelFileName, sOption1SpiceModelFileName,
    sOption2SpiceModelFileName, sSpiceModelDirectoryName,
    sSpiceLocalModelFileName: string;
  slTemp: TStringList;
  sFileList: string;
  sDestination: string;
  FLibraryModelFile, FOption1, FOption2, FModelFile: TextFile;
  sDirectoryOfSourceFiles: string;
  sIniFile: string;
  lDetail: TStringList;
begin
  CodeSite.EnterMethod(Self, 'TransferSymbols');

  // Transfer analog primitive symbols, analog symbols with schematics,
  // and analog symbols with netlist. Exclude symbols with Gate atribute }
  lDetail := TStringList.Create;
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT name FROM dev');
    SQL.Add('WHERE NOT optional');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    SQL.Add('ORDER BY name');
    Prepare;
    Open;
    if (RecordCount > 0) then
    begin
      sTemp := '';
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
        IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\analog\symbols';
      AppIcons.IconModule.JamFileOperation.Destination := sDestination;
      while not Eof do
      begin
        sDevice := Trim(FieldByName('name').AsString);
        sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\symbols\' +
          sDevice + '.sym';
        AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring analog symbols.', mtError, [mbOK], 0);
    end;
    Close;
  end;
  // Transfer optional analog primitive symbols, analog symbols with schematics
  // and analog symbols with netlist. Excludes symbols with Gate attribute }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      sTemp := '';
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
        IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\analog\symbols';
      AppIcons.IconModule.JamFileOperation.Destination := sDestination;
      while not LibraryDatabase.UniQuery.Eof do
      begin
        sDevice := Trim(FieldByName('name').AsString);
        sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\symbols\' +
          sDevice + '.sym';
        AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring optional analog symbols.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer schematics for analog symbols with subcircuit }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM dev');
    SQL.Add('WHERE (not optional)');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND subcircuit');
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      sTemp := '';
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
        IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\analog\schematics';
      AppIcons.IconModule.JamFileOperation.Destination := sDestination;
      while not LibraryDatabase.UniQuery.Eof do
      begin
        sDevice := Trim(FieldByName('name').AsString);
        sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\schematics\' +
          sDevice + '.sch';
        AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring optional analog schematics.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer optional schematics for analog symbols with subcircuit }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND subcircuit');
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      sTemp := '';
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
        IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\analog\schematics';
      AppIcons.IconModule.JamFileOperation.Destination := sDestination;
      while not LibraryDatabase.UniQuery.Eof do
      begin
        sDevice := Trim(FieldByName('name').AsString);
        sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\schematics\' +
          sDevice + '.sch';
        AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring optional analog schematics.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer netlists for analog symbols }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Clear;
    SQL.Add('SELECT * FROM dev');
    SQL.Add('WHERE NOT optional');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    SQL.Add('AND netlist');
    Open;
    if (RecordCount > 0) then
    begin
      { Transfer PSpice netlists }
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\analog\netlists';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\netlists\' +
          Trim(FieldByName('name').AsString);
        if FileExists(sName + '.p') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.p');
        if FileExists(sName + '.h') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.h');
        if FileExists(sName + '.l') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.l');
        if FileExists(sName + '.a') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.a');
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring netlists for analog symbols.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer optional netlists for analog symbols }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND NOT category = ' + QuotedStr('Gate'));
    SQL.Add('AND netlist');
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\analog\netlists';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\analog\netlists\' +
          Trim(FieldByName('name').AsString);
        if FileExists(sName + '.p') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.p');
        if FileExists(sName + '.h') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.h');
        if FileExists(sName + '.l') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.l');
        if FileExists(sName + '.a') then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName + '.a');
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring optional analog netlists.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer gate symbols }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM dev');
    SQL.Add('WHERE NOT optional');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\symbols';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\symbols\' +
          Trim(FieldByName('name').AsString) + '.sym';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring gate symbols.', mtError, [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer optional gate symbols }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\symbols';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\symbols\' +
          Trim(FieldByName('name').AsString) + '.sym';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring optional gate symbols.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer gate schematics }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM dev');
    SQL.Add('WHERE not optional');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\schematics';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\schematics\'
          + Trim(FieldByName('name').AsString) + '.sch';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring gate schematics.', mtError, [mbOK], 0);
    end;
    Close;
  end; { with }

  { Transfer optional gate schematics }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\schematics';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\schematics\'
          + Trim(FieldByName('name').AsString) + '.sch';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring gate schematics.', mtError, [mbOK], 0);
    end;
    Close;
  end;
  { Transfer digital netlist files }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM dev');
    SQL.Add('WHERE NOT optional');
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    SQL.Add('AND digitalfile = ' + QuotedStr('Y'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\netlists';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\netlists\' +
          Trim(FieldByName('name').AsString) + '.pd';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring digital netlist files.', mtError,
          [mbOK], 0);
    end;
    Close;
  end; { with }
  { Transfer optional digital files }
  with LibraryDatabase.UniQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM opt');
    SQL.Add('WHERE prom_name = ' + QuotedStr(Process.Promis));
    SQL.Add('AND processname = ' + QuotedStr(Process.Name));
    SQL.Add('AND version = ' + Process.Rev);
    SQL.Add('AND category = ' + QuotedStr('Gate'));
    SQL.Add('AND digitalfile = ' + QuotedStr('Y'));
    Open;
    if (RecordCount > 0) then
    begin
      First;
      AppIcons.IconModule.JamFileOperation.Options :=
        [soFilesOnly, soNoConfirmation];
      AppIcons.IconModule.JamFileOperation.Operation := otCopy;
      AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
      AppIcons.IconModule.JamFileOperation.Destination :=
        IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
        (Project.Rev) + 'lib\ecs\digital\netlists';
      while not Eof do
      begin
        sName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
          IncludeTrailingPathDelimiter(Process.Name) +
          IncludeTrailingPathDelimiter(Process.Rev) + 'ecs\digital\netlists\' +
          Trim(FieldByName('name').AsString) + '.pd';
        if FileExists(sName) then
          AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sName);
        Next;
      end;
      if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
        MessageDlg('Error transferring digital files.', mtError, [mbOK], 0);
    end;
    Close;
  end;
  { Transfer LTspice models }
  sSpiceModelDirectoryName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ltspice';
  sMainSpiceModelFileName := IncludeTrailingPathDelimiter
    (sSpiceModelDirectoryName) + Process.Name + '.lib';
  sFileList := IncludeTrailingPathDelimiter(sSpiceModelDirectoryName) +
    'Files.list';
  sSpiceLocalModelFileName := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ltspice\' +
    Process.Name + '.lib';
  if FileExists(sMainSpiceModelFileName) then
  begin
    AssignFile(FLibraryModelFile, sMainSpiceModelFileName);
    { Main LTspice file }
    AssignFile(FModelFile, sSpiceLocalModelFileName); { Local LTSpice file }
    FileMode := 0;
    Rewrite(FModelFile);
    Reset(FLibraryModelFile);
    while not(Eof(FLibraryModelFile)) do
    begin
      Readln(FLibraryModelFile, sLine);
      Writeln(FModelFile, sLine);
    end;
    if Process.option1 <> 'N/A' then
    begin
      lDetail.Clear;
      sOption1SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option1Code +
        Process.option1 + '.lib';
      if FileExists(sOption1SpiceModelFileName) then
      begin
        AssignFile(FOption1, sOption1SpiceModelFileName);
        { Option1 for PSpice file }
        Reset(FOption1);
        while not(Eof(FOption1)) do
        begin
          Readln(FOption1, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption1);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption1SpiceModelFileName]), mtError, [mbOK], 0);
    end;
    if Process.option2 <> 'N/A' then
    begin
      sOption2SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option2Code +
        Process.option2 + '.lib';
      if FileExists(sOption2SpiceModelFileName) then
      begin
        AssignFile(FOption2, sOption2SpiceModelFileName);
        { Option2 for PSpice file }
        Reset(FOption2);
        while not(Eof(FOption2)) do
        begin
          Readln(FOption2, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption2);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption2SpiceModelFileName]), mtError, [mbOK], 0)
    end;
    CloseFile(FLibraryModelFile);
    CloseFile(FModelFile);
  end;
  { Additional PSpice model files }
  if (FileExists(sFileList)) then
  begin
    slTemp := TStringList.Create;
    slTemp.LoadFromFile(sFileList);
    sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
      IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ltspice';
    TransferFileList(slTemp, sSpiceModelDirectoryName, sDestination);
    slTemp.Free;
  end;
  { PSpice files using files.ini }
  sDirectoryOfSourceFiles := sSpiceModelDirectoryName;
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ltspice';
  if (FileExists(sIniFile)) then
  begin
    TransferAndBuildFiles(sIniFile, sDestination);
  end;

  { Transfer PSpice models }
  sSpiceModelDirectoryName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'pspice';
  sMainSpiceModelFileName := IncludeTrailingPathDelimiter
    (sSpiceModelDirectoryName) + Process.Name + '.lib';
  sFileList := IncludeTrailingPathDelimiter(sSpiceModelDirectoryName) +
    'Files.list';
  sSpiceLocalModelFileName := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\pspice\' +
    Process.Name + '.lib';
  if FileExists(sMainSpiceModelFileName) then
  begin
    lDetail.Clear;
    AssignFile(FLibraryModelFile, sMainSpiceModelFileName);
    { Main PSpice file }
    AssignFile(FModelFile, sSpiceLocalModelFileName); { Local PSpice file }
    FileMode := 0;
    Rewrite(FModelFile);
    Reset(FLibraryModelFile);
    while not(Eof(FLibraryModelFile)) do
    begin
      Readln(FLibraryModelFile, sLine);
      Writeln(FModelFile, sLine);
    end;
    if Process.option1 <> 'N/A' then
    begin
      sOption1SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option1Code +
        Process.option1 + '.lib';
      if FileExists(sOption1SpiceModelFileName) then
      begin
        AssignFile(FOption1, sOption1SpiceModelFileName);
        { Option1 for PSpice file }
        Reset(FOption1);
        while not(Eof(FOption1)) do
        begin
          Readln(FOption1, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption1);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption1SpiceModelFileName]), mtError, [mbOK], 0);
    end;
    if Process.option2 <> 'N/A' then
    begin
      sOption2SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option2Code +
        Process.option2 + '.lib';
      if FileExists(sOption2SpiceModelFileName) then
      begin
        AssignFile(FOption2, sOption2SpiceModelFileName);
        { Option2 for PSpice file }
        Reset(FOption2);
        while not(Eof(FOption2)) do
        begin
          Readln(FOption2, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption2);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption2SpiceModelFileName]), mtError, [mbOK], 0)
    end;
    CloseFile(FLibraryModelFile);
    CloseFile(FModelFile);
  end;
  { Additional PSpice model files }
  if (FileExists(sFileList)) then
  begin
    slTemp := TStringList.Create;
    slTemp.LoadFromFile(sFileList);
    sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
      IncludeTrailingPathDelimiter(Project.Rev) + 'lib\pspice';
    TransferFileList(slTemp, sSpiceModelDirectoryName, sDestination);
    slTemp.Free;
  end;
  { PSpice files using files.ini }
  sDirectoryOfSourceFiles := sSpiceModelDirectoryName;
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\pspice';
  if (FileExists(sIniFile)) then
  begin
    TransferAndBuildFiles(sIniFile, sDestination);
  end;

  { Transfer HSpice models }
  sSpiceModelDirectoryName := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'hspice';
  sMainSpiceModelFileName := IncludeTrailingPathDelimiter
    (sSpiceModelDirectoryName) + Process.Name + '.lib';
  sFileList := IncludeTrailingPathDelimiter(sSpiceModelDirectoryName) +
    'Files.list';
  sSpiceLocalModelFileName := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\hspice\' +
    Process.Name + '.lib';
  if FileExists(sMainSpiceModelFileName) then
  begin
    AssignFile(FLibraryModelFile, sMainSpiceModelFileName);
    { Main PSpice file }
    AssignFile(FModelFile, sSpiceLocalModelFileName); { Local PSpice file }
    FileMode := 0;
    Rewrite(FModelFile);
    Reset(FLibraryModelFile);
    while not(Eof(FLibraryModelFile)) do
    begin
      Readln(FLibraryModelFile, sLine);
      Writeln(FModelFile, sLine);
    end;
    if Process.option1 <> 'N/A' then
    begin
      sOption1SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option1Code +
        Process.option1 + '.lib';
      if FileExists(sOption1SpiceModelFileName) then
      begin
        AssignFile(FOption1, sOption1SpiceModelFileName);
        { Option1 for HSpice file }
        Reset(FOption1);
        while not(Eof(FOption1)) do
        begin
          Readln(FOption1, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption1);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption1SpiceModelFileName]), mtError, [mbOK], 0);
    end;
    if Process.option2 <> 'N/A' then
    begin
      sOption2SpiceModelFileName := IncludeTrailingPathDelimiter
        (sSpiceModelDirectoryName) + Process.option2Code +
        Process.option2 + '.lib';
      if FileExists(sOption2SpiceModelFileName) then
      begin
        AssignFile(FOption2, sOption2SpiceModelFileName);
        { Option2 for HSpice file }
        Reset(FOption2);
        while not(Eof(FOption2)) do
        begin
          Readln(FOption2, sLine);
          Writeln(FModelFile, sLine);
        end;
        CloseFile(FOption2);
      end
      else
        MessageDlg(Format('Error: file %s not found. Get CAD support!',
          [sOption2SpiceModelFileName]), mtError, [mbOK], 0)
    end;
    CloseFile(FLibraryModelFile);
    CloseFile(FModelFile);
  end;
  { Additional HSpice model files }
  if (FileExists(sFileList)) then
  begin
    slTemp := TStringList.Create;
    slTemp.LoadFromFile(sFileList);
    sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
      IncludeTrailingPathDelimiter(Project.Rev) + 'lib\hspice';
    TransferFileList(slTemp, sSpiceModelDirectoryName, sDestination);
    slTemp.Free;
  end;
  { HSpice files using files.ini }
  sDirectoryOfSourceFiles := sSpiceModelDirectoryName;
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\hspice';
  if (FileExists(sIniFile)) then
  begin
    TransferAndBuildFiles(sIniFile, sDestination);
  end;

  { Transfer generic symbols with files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    'generic\' + IncludeTrailingPathDelimiter(Process.GenericRev) +
    'ecs\generic\symbols';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\generic\symbols';
  if (FileExists(sIniFile)) then
  begin
    TransferAndBuildFiles(sIniFile, sDestination);
  end;

  { Tanner files }
  sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ledit\' + Process.Name + '.tdb';
  if FileExists(sTemp) then
  begin
    AppIcons.IconModule.JamFileOperation.Options :=
      [soFilesOnly, soNoConfirmation];
    AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
    AppIcons.IconModule.JamFileOperation.Operation := otCopy;
    AppIcons.IconModule.JamFileOperation.Destination :=
      IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
      (Project.Rev) + 'lib\ledit';
    AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
    if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
      MessageDlg('Error transferring generic symbols.', mtError, [mbOK], 0);
  end;
  { Tanner files using files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ledit';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ledit';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer package symbols using files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\package\symbols';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\package\symbols';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer package schematics using files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\package\schematics';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\package\schematics';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer package netlists files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\package\netlists';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\package\netlists';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer ideal symbols with files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\ideal\symbols';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\ideal\symbols';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer ideal schematics with files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\ideal\schematics';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\ideal\schematics';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer ideal netlists with files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'ecs\ideal\netlists';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\ecs\ideal\netlists';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { Transfer verilog models using files.ini }
  sDirectoryOfSourceFiles := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'verilog';
  sIniFile := IncludeTrailingPathDelimiter(sDirectoryOfSourceFiles) +
    'files.ini';
  sDestination := IncludeTrailingPathDelimiter(Project.Dir) +
    IncludeTrailingPathDelimiter(Project.Rev) + 'lib\verilog';
  if (FileExists(sIniFile)) then
    TransferAndBuildFiles(sIniFile, sDestination);

  { dracula header file }
  sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'dracula\' + Process.Name + '.lvh';
  if (not(FileExists(sTemp))) then
    sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
      IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
      (Process.Rev) + 'drac\' + Process.Name + '.lvh';
  if FileExists(sTemp) then
  begin
    AppIcons.IconModule.JamFileOperation.Options :=
      [soFilesOnly, soNoConfirmation];
    AppIcons.IconModule.JamFileOperation.Operation := otCopy;
    AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
    AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
    AppIcons.IconModule.JamFileOperation.Destination :=
      IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
      (Project.Rev) + 'lib\dracula';
    if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
      MessageDlg('Error transferring dracula header file.', mtError, [mbOK], 0);
  end;

  { assura header file }
  sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'assura\' + Process.Name + '.alvh';
  if FileExists(sTemp) then
  begin
    AppIcons.IconModule.JamFileOperation.Options :=
      [soFilesOnly, soNoConfirmation];
    AppIcons.IconModule.JamFileOperation.Operation := otCopy;
    AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
    AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
    AppIcons.IconModule.JamFileOperation.Destination :=
      IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
      (Project.Rev) + 'lib\assura';
    if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
      MessageDlg('Error transferring assura header file.', mtError, [mbOK], 0);
  end;

  { Documentation file }
  sTemp := IncludeTrailingPathDelimiter(LTCSim.libraryDir) +
    IncludeTrailingPathDelimiter(Process.Name) + IncludeTrailingPathDelimiter
    (Process.Rev) + 'doc\' + Process.Name + '.pdf';
  if FileExists(sTemp) then
  begin
    AppIcons.IconModule.JamFileOperation.Operation := otCopy;
    AppIcons.IconModule.JamFileOperation.Options :=
      [soFilesOnly, soNoConfirmation];
    AppIcons.IconModule.JamFileOperation.SourceFiles.Clear;
    AppIcons.IconModule.JamFileOperation.SourceFiles.Add(sTemp);
    AppIcons.IconModule.JamFileOperation.Destination :=
      IncludeTrailingPathDelimiter(Project.Dir) + IncludeTrailingPathDelimiter
      (Project.Rev) + 'lib\doc';
    if (not(AppIcons.IconModule.JamFileOperation.Execute)) then
      MessageDlg('Error transferring documentation file.', mtError, [mbOK], 0);
  end;

  CodeSite.ExitMethod(Self, 'TransferSymbols');
end;

procedure TMainForm.Uninstall1Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Uninstall1Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'tvnserver.exe';
  sArgument := '-remove';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Uninstall1Click');
end;

procedure TMainForm.UpdateFormComponents;
var
  I: Integer;
begin
  CodeSite.EnterMethod(Self, 'UpdateFormComponents');

  cbIgnoreCase.checked := Project.ignoreCase;
  cbFilterAfterSchematics.checked := cbFilterAfterSchematics.checked;
  cbFilterAfterSimulation.checked := cbFilterAfterSimulation.checked;
  cbFilterAfterNetlist.checked := cbFilterAfterNetlist.checked;
  cbSchematics.Text := Project.currentSchematics;
  cbStim.Text := Project.currentStimulus;
  cbTool.Text := Project.currentTool;
  for I := 0 to (Project.lSchematicsUsed.Count - 1) do
  begin
    cbSchematics.Items.Add(Project.lSchematicsUsed.Strings[I]);
  end;

  for I := 0 to (Project.lStimulusUsed.Count - 1) do
  begin
    cbStim.Items.Add(Project.lStimulusUsed.Strings[I]);
  end;

  eProcessName.Text := Process.Name;
  eProcessRev.Text := Process.Rev;
  ePromis.Text := Process.Promis;
  eOption1Name.Text := Process.option1Name;
  eOption1.Text := Process.option1;
  eOption1Code.Text := Process.option1Code;
  eOption2Name.Text := Process.option2Name;
  eOption2.Text := Process.option2;
  eOption2Code.Text := Process.option2Code;

  cbLTspiceGND.checked := Project.ltspiceGND;
  cbLTspiceXGNDX.checked := Project.ltspiceXGNDX;
  cbLTspiceOmitPrefix.checked := Project.ltspiceOmitPrefix;
  cbLTspiceShrink.checked := Project.ltspiceShrink;
  cbLTspiceSubcircuit.checked := Project.ltspiceSubCircuit;
  cbLTspiceSchematics.checked := Project.ltspiceschematics;
  eLTspiceBracketSubstitutionLeft.Text := Project.ltspiceLeftBracket;
  eLTspiceBracketSubstitutionRight.Text := Project.ltspiceRightBracket;
  eLTCSpiceFileName.FileName := Project.ltspiceCommand;
  eLTCSpiceOptions.Text := Project.ltspiceCommandOptions;
  RadioGroupLTspiceSyntax.ItemIndex := Project.ltspiceSyntax;

  cbPSspiceGND.checked := Project.pspiceGND;
  cbPSspiceXGNDX.checked := Project.pspiceXGNDX;
  cbPSspiceOmitPrefix.checked := Project.pspiceOmitPrefix;
  cbPSspiceShrink.checked := Project.pspiceShrink;
  cbPSspiceSubcircuit.checked := Project.pspiceSubCircuit;
  cbPSpiceMixedSignal.checked := Project.pspiceAD;
  ePSpiceBracketSubstitutionLeft.Text := Project.pspiceLeftBracket;
  ePSpiceBracketSubstitutionRight.Text := Project.pspiceRightBracket;
  ePspiceFileName.FileName := Project.pspiceCommand;
  ePspiceOptions.Text := Project.pspiceCommandOptions;
  ePspiceWaveformTool.FileName := Project.pspiceViewer;

  cbHSpiceGND.checked := Project.hspiceGND;
  cbHSpiceXGNDX.checked := Project.hspiceXGNDX;
  cbHSpiceOmitPrefix.checked := Project.hspiceOmitPrefix;
  cbHSpiceShrink.checked := Project.hspiceShrink;
  cbHSpiceSubcircuit.checked := Project.hspiceSubCircuit;
  cbHSpiceVerilogA.checked := Project.hspiceVerilogA;
  eHSpiceBracketSubstitutionLeft.Text := Project.hspiceLeftBracket;
  eHSpiceBracketSubstitutionRight.Text := Project.hspiceRightBracket;
  eHSpiceFileName.FileName := Project.hspiceCommand;
  eHSpiceOptions.Text := Project.hspiceCommandOptions;
  eHSpiceViewerCommand.FileName := Project.hspiceViewer;
  eHSpiceViewerOptions.Text := Project.hspiceViewerOptions;

  cbAPTBipolarArea.checked := Project.aptBipolarArea;
  cbAPTBipolarWL.checked := Project.aptBipolarWL;
  cbAPTGND.checked := Project.aptGND;
  cbAPTXGNDX.checked := Project.aptXGNDX;
  cbAPTOmitPrefix.checked := Project.aptOmitPrefix;
  cbAPTShrink.checked := Project.aptShrink;
  cbAPTSubcircuit.checked := Project.aptSubCircuit;
  eAPTBracketSubstitutionLeft.Text := Project.aptLeftBracket;
  eAPTBracketSubstitutionRight.Text := Project.aptRightBracket;
  eAPTLVS_Short.Text := Project.aptShort;

  cbAssuraBipolarArea.checked := Project.assuraBipolarArea;
  cbAssuraBipolarWL.checked := Project.assuraBipolarWL;
  cbAssuraGND.checked := Project.assuraGND;
  cbAssuraXGNDX.checked := Project.assuraXGNDX;
  cbAssuraOmitPrefix.checked := Project.assuraOmitPrefix;
  cbAssuraShrink.checked := Project.assuraShrink;
  cbAssuraSubcircuit.checked := Project.assuraSubCircuit;
  eAssuraBracketSubstitutionLeft.Text := Project.assuraLeftBracket;
  eAssuraBracketSubstitutionRight.Text := Project.assuraRightBracket;
  eAssuraLVS_Short.Text := Project.assuraShort;

  cbDraculaBipolarArea.checked := Project.draculaBipolarArea;
  cbDraculaBipolarWL.checked := Project.draculaBipolarWL;
  cbDraculaGND.checked := Project.draculaGND;
  cbDraculaXGNDX.checked := Project.draculaXGNDX;
  cbDraculaOmitPrefix.checked := Project.draculaOmitPrefix;
  cbDraculaShrink.checked := Project.draculaShrink;
  cbDraculaSubcircuit.checked := Project.draculaSubCircuit;
  eDraculaBracketSubstitutionLeft.Text := Project.draculaLeftBracket;
  eDraculaBracketSubstitutionRight.Text := Project.draculaRightBracket;
  eDraculaLVS_Short.Text := Project.draculaShort;

  eProcessName.Text := Process.Name;
  eProcessRev.Text := Process.Rev;
  ePromis.Text := Process.Promis;
  eOption1.Text := Process.option1;
  eOption1Name.Text := Process.option1Name;
  eOption1Code.Text := Process.option1Code;
  eOption2.Text := Process.option2;
  eOption2Name.Text := Process.option2Name;
  eOption2Code.Text := Process.option2Code;
  eGenericVer.Text := Process.GenericRev;

  CodeSite.ExitMethod(Self, 'UpdateFormComponents');
end;

procedure TMainForm.UpdateProjectVariables;
begin
  CodeSite.EnterMethod(Self, 'UpdateProjectVariables');

  { Updating global variables }
  sSynarioDir := LTCSim.Dir;
  sLibraryDir := LTCSim.libraryDir;
  with Project do
  begin
    Dir := IncludeTrailingPathDelimiter(LTCSim.localProjectsDir) + Project.Name;
    RevDir := IncludeTrailingPathDelimiter(Project.Dir) + Project.Rev;
    LibDir := IncludeTrailingPathDelimiter(Project.RevDir) + 'lib';
    SetupFile := IncludeTrailingPathDelimiter(Project.RevDir) + 'setup.ini';
    Project.XMLSetupFile6 := IncludeTrailingPathDelimiter(Project.RevDir) +
      'project.xml';
    LTspiceIniFileName := IncludeTrailingPathDelimiter(Project.RevDir) +
      'ltspice.ini.';
    SchemDir := IncludeTrailingPathDelimiter(Project.RevDir) + 'schem';
    IniFileName := IncludeTrailingPathDelimiter(Project.SchemDir) +
      'project.ini';
    primitiveReport := cbPrimitiveReport.checked;

    eProcessName.Text := Process.Name;
    eProcessRev.Text := Process.Rev;
    eOption1.Text := Process.option1;
    eOption1.Text := Process.option1;
    eOption1Name.Text := Process.option1Name;
    eOption1Code.Text := Process.option1Code;
    eOption2.Text := Process.option2;
    eOption2Name.Text := Process.option2Name;
    eOption2Code.Text := Process.option2Code;
    eGenericVer.Text := Process.GenericRev;

    ltspiceGND := cbLTspiceGND.checked;
    ltspiceXGNDX := cbLTspiceXGNDX.checked;
    ltspiceOmitPrefix := cbLTspiceOmitPrefix.checked;
    ltspiceShrink := cbLTspiceShrink.checked;
    ltspiceSubCircuit := cbLTspiceSubcircuit.checked;
    ltspiceschematics := cbLTspiceSchematics.checked;
    ltspiceLeftBracket := eLTspiceBracketSubstitutionLeft.Text;
    ltspiceRightBracket := eLTspiceBracketSubstitutionRight.Text;
    ltspiceCommand := eLTCSpiceFileName.FileName;
    ltspiceCommandOptions := eLTCSpiceOptions.Text;
    ltspiceSyntax := RadioGroupLTspiceSyntax.ItemIndex;

    pspiceGND := cbPSspiceGND.checked;
    pspiceXGNDX := cbPSspiceXGNDX.checked;
    pspiceOmitPrefix := cbPSspiceOmitPrefix.checked;
    pspiceShrink := cbPSspiceShrink.checked;
    pspiceSubCircuit := cbPSspiceSubcircuit.checked;
    pspiceAD := cbPSpiceMixedSignal.checked;
    pspiceLeftBracket := ePSpiceBracketSubstitutionLeft.Text;
    pspiceRightBracket := ePSpiceBracketSubstitutionRight.Text;
    pspiceCommand := ePspiceFileName.FileName;
    pspiceCommandOptions := ePspiceOptions.Text;
    pspiceViewer := ePspiceWaveformTool.FileName;

    hspiceGND := cbHSpiceGND.checked;
    hspiceXGNDX := cbHSpiceXGNDX.checked;
    hspiceOmitPrefix := cbHSpiceOmitPrefix.checked;
    hspiceShrink := cbHSpiceShrink.checked;
    hspiceSubCircuit := cbHSpiceSubcircuit.checked;
    hspiceVerilogA := cbHSpiceVerilogA.checked;
    hspiceLeftBracket := eHSpiceBracketSubstitutionLeft.Text;
    hspiceRightBracket := eHSpiceBracketSubstitutionRight.Text;
    hspiceCommand := eHSpiceFileName.FileName;
    hspiceCommandOptions := eHSpiceOptions.Text;
    hspiceViewer := eHSpiceViewerCommand.FileName;
    hspiceViewerOptions := eHSpiceViewerOptions.Text;

    aptBipolarArea := cbAPTBipolarArea.checked;
    aptBipolarWL := cbAPTBipolarWL.checked;
    aptGND := cbAPTGND.checked;
    aptXGNDX := cbAPTXGNDX.checked;
    aptOmitPrefix := cbAPTOmitPrefix.checked;
    aptShrink := cbAPTShrink.checked;
    aptSubCircuit := cbAPTSubcircuit.checked;
    aptLeftBracket := eAPTBracketSubstitutionLeft.Text;
    aptRightBracket := eAPTBracketSubstitutionRight.Text;
    aptShort := eAPTLVS_Short.Text;

    assuraBipolarArea := cbAssuraBipolarArea.checked;
    assuraBipolarWL := cbAssuraBipolarWL.checked;
    assuraGND := cbAssuraGND.checked;
    assuraXGNDX := cbAssuraXGNDX.checked;
    assuraOmitPrefix := cbAssuraOmitPrefix.checked;
    assuraShrink := cbAssuraShrink.checked;
    assuraSubCircuit := cbAssuraSubcircuit.checked;
    assuraLeftBracket := eAssuraBracketSubstitutionLeft.Text;
    assuraRightBracket := eAssuraBracketSubstitutionRight.Text;
    assuraShort := eAssuraLVS_Short.Text;

    draculaBipolarArea := cbDraculaBipolarArea.checked;
    draculaBipolarWL := cbDraculaBipolarWL.checked;
    draculaGND := cbDraculaGND.checked;
    draculaXGNDX := cbDraculaXGNDX.checked;
    draculaOmitPrefix := cbDraculaOmitPrefix.checked;
    draculaShrink := cbDraculaShrink.checked;
    draculaSubCircuit := cbDraculaSubcircuit.checked;
    draculaLeftBracket := eDraculaBracketSubstitutionLeft.Text;
    draculaRightBracket := eDraculaBracketSubstitutionRight.Text;
    draculaShort := eDraculaLVS_Short.Text;
  end;

  with Process do
  begin
    Name := eProcessName.Text;
    Rev := eProcessRev.Text;
    Promis := ePromis.Text;
    option1Name := eOption1Name.Text;
    option1Code := eOption1Code.Text;
    option1 := eOption1.Text;
    option2Name := eOption2Name.Text;
    option2Code := eOption2Code.Text;
    option2 := eOption2.Text;
    GenericRev := eGenericVer.Text;
    ProcessInfoDir := IncludeTrailingPathDelimiter(Project.RevDir) + 'lib\doc';
    ProcessInfoFile := IncludeTrailingPathDelimiter(ProcessInfoDir) +
      Name + '.pdf';
  end;

  if cbTool.Text <> '' then
  begin
    if (cbTool.Text = 'LTspice') then
      ToolInUse := LTspice
    else if (cbTool.Text = 'HSpice') then
      ToolInUse := HSpice
    else if (cbTool.Text = 'PSpice') then
      ToolInUse := PSpice
    else if (cbTool.Text = 'Verilog') then
      ToolInUse := Verilog
    else if (cbTool.Text = 'Edif') then
      ToolInUse := Edif
    else if (cbTool.Text = 'APT') then
      ToolInUse := APT
    else if (cbTool.Text = 'Assura') then
      ToolInUse := Assura
    else if (cbTool.Text = 'Dracula') then
      ToolInUse := Dracula;
  end;

  CodeSite.ExitMethod(Self, 'UpdateProjectVariables');
end;

procedure TMainForm.UtilitiesRun(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir, sSchematics, sStimulus: string;
begin
  CodeSite.EnterMethod(Self, 'UtilitiesRun');

  with Sender as TMenuItem do
  begin
    case tag of
      1021:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir)
            + 'LTC\CT';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'CT.exe';
          sArgument := '';
        end;
      1022:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir)
            + 'LTC\CT';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'CT.pdf';
          sArgument := '';
        end;
      1031:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\LTCBackAnnotation';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'LTCBackAnnotate.exe';
          sSchematics := IncludeTrailingPathDelimiter(Project.SchemDir) +
            cbSchematics.Text + '.sch';
          sStimulus := IncludeTrailingPathDelimiter(Project.SchemDir) +
            cbStim.Text;
          case ToolInUse of
            LTspice:
              begin
                sArgument := 'ltspice ' + sSchematics + ' ' +
                  ChangeFileExt(sStimulus, '.log');
              end;
            PSpice:
              begin
                sArgument := 'pspice ' + sSchematics + ' ' +
                  ChangeFileExt(sStimulus, '.out');
              end;
          end
        end;
      1032:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\LTCBackAnnotation';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'LTCBackAnnotate.pdf';
          sArgument := '';
        end;
      1041:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\MigrateSymbols';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'MigrateSym.exe';
          sArgument := '';
        end;
      1042:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\MigrateSymbols';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'MigrateSym.pdf';
          sArgument := '';
        end;
      1051:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\RenameSchSym';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'RenameSchSym.exe';
          sArgument := '';
        end;
      1052:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\RenameSchSym';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'RenameSchSym.pdf';
          sArgument := '';
        end;
      1061:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\FloatingGate';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'FloatingGateChecker.exe';
          sArgument := '';
        end;
      1071:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\LTSExplorer';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'LTSExplorer.exe';
          sArgument := '';
        end;
      1072:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\LTSExplorer';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'LTSExplorer.pdf';
          sArgument := '';
        end;
      1091:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\ASCIItoSchem';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'ASCIIToSchem.exe';
          sArgument := '';
        end;
      1101:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\ASCIItoSym';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'ASCIIToSym.exe';
          sArgument := '';
        end;
      1111:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\DeviceList';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'DeviceList.exe';
          sArgument := '';
        end;
      1112:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\DeviceList';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'DeviceList.pdf';
          sArgument := '';
        end;
      1121:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\ModifySchem';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'ModifySchem.exe';
          sArgument := '';
        end;
      1122:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\ModifySchem';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'ModifySchem.pdf';
          sArgument := '';
        end;
      1131:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\SchemToASCII';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'SchemToASCII.exe';
          sArgument := '';
        end;
      1141:
        begin
          sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
            'LTC\SymToASCII';
          sCommand := IncludeTrailingPathDelimiter(sWorkingDir) +
            'SymToASCII.exe';
          sArgument := '';
        end;
    end
  end;
  if (FileExists(sCommand)) then
    ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
      PChar(sArgument), PChar(sWorkingDir), SW_NORMAL)
  else
    MessageDlg('File ' + sCommand + ' not found!', mtError, [mbOK], 0);

  CodeSite.ExitMethod(Self, 'UtilitiesRun');
end;

function TMainForm.ValidateSearchPath: Boolean;
var
  ProjectIniFile: TIniFile;
  I: Integer;
  lInfo: TStringList;
  bValidSymbolPathVal: Boolean;
  bValidProjectsPathVal: Boolean;
  bValidModelPath: Boolean;
  sDirectoryPath: string;
  bVal: Boolean;
begin
  CodeSite.EnterMethod(Self, 'ValidateSearchPath');

  bValidSymbolPathVal := true;
  bValidProjectsPathVal := true;
  bValidModelPath := true;
  // Search ilegal directories in SymbolLibraries
  lInfo := TStringList.Create;
  ProjectIniFile := TIniFile.Create(Project.IniFileName);
  try
    ProjectIniFile.ReadSection('SymbolLibraries', lInfo);
    if (lInfo.Count > 0) then
    begin
      for I := 0 to (lInfo.Count - 1) do
      begin
        sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
        if (System.Pos('$(projects)', sDirectoryPath) > 0) then

        begin
          sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
            '$(projects)', LowerCase(LTCSim.localProjectsDir),
            [rfIgnoreCase, rfReplaceAll]);
        end;
        if (System.Pos(LowerCase(Project.RevDir), sDirectoryPath) = 0) then
        begin
          bValidSymbolPathVal := False;
        end
      end
    end;
    lInfo.Clear;
    ProjectIniFile.ReadSection('ProjectLibraries', lInfo);
    if (lInfo.Count > 0) then
    begin
      for I := 0 to (lInfo.Count - 1) do
      begin
        sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
        if (PosEx('$(projects)', sDirectoryPath, 1) = 1) then
        begin
          sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
            '$(projects)', LowerCase(LTCSim.localProjectsDir),
            [rfIgnoreCase, rfReplaceAll]);
        end;
        if (PosEx(LowerCase(Project.RevDir), sDirectoryPath, 1) = 0) then
          bValidProjectsPathVal := False;
      end;
    end;
    lInfo.Clear;
    ProjectIniFile.ReadSection('ModelLibraries', lInfo);
    if (lInfo.Count > 0) then
    begin
      for I := 0 to (lInfo.Count - 1) do
      begin
        sDirectoryPath := LowerCase(Trim(lInfo.Strings[I]));
        if (PosEx('$(projects)', sDirectoryPath, 1) = 1) then
        begin
          sDirectoryPath := SysUtils.StringReplace(sDirectoryPath,
            '$(projects)', LowerCase(LTCSim.localProjectsDir),
            [rfIgnoreCase, rfReplaceAll]);
        end;
        if (PosEx(LowerCase(Project.RevDir), sDirectoryPath, 1) = 0) then
          bValidModelPath := False;
      end;
    end;
  finally
    ProjectIniFile.Free;
    lInfo.Free;
  end;
  bVal := (bValidSymbolPathVal and bValidProjectsPathVal and bValidModelPath);
  Result := bVal;

  CodeSite.ExitMethod(Self, 'ValidateSearchPath');
end;

function TMainForm.ValidProject: Boolean;
begin
  CodeSite.EnterMethod(Self, 'ValidProject');

  if ((Project.Name <> '') and (Project.Rev <> '') and (Process.Name <> '') and
    (Process.Rev <> '') and (Process.Promis <> '') and
    (Process.option1Name <> '') and (Process.option1Code <> '') and
    (Process.option1 <> '') and (Process.option2Name <> '') and
    (Process.option2Code <> '') and (Process.option2 <> '') and
    (Process.GenericRev <> '')) then
    Result := true
  else
    Result := False;

  CodeSite.ExitMethod(Self, 'ValidProject');
end;

function TMainForm.ValidString(sCharacters: string): Boolean;
begin
  CodeSite.EnterMethod(Self, 'ValidString');

  {
    if (CharExistsS(Trim(sCharacters), ' ') or
    CharExistsS(Trim(sCharacters), '%') or
    CharExistsS(Trim(sCharacters), '$')) then
  }
  if ((Pos(' ', Trim(sCharacters)) > 0) or (Pos('%', Trim(sCharacters)) > 0) or
    (Pos('$', Trim(sCharacters)) > 0)) then
    Result := False
  else
    Result := true;

  CodeSite.ExitMethod(Self, 'ValidString');
end;

procedure TMainForm.Viewer2Click(Sender: TObject);
var
  sCommand, sArgument, sWorkingDir: string;
begin
  CodeSite.EnterMethod(Self, 'Viewer2Click');

  { VNC server configure }
  sWorkingDir := IncludeTrailingPathDelimiter(LTCSim.designer6Dir) +
    'LTC\TightVNC';
  sCommand := IncludeTrailingPathDelimiter(sWorkingDir) + 'vncviewer.exe';
  sArgument := '';
  ShellExecute(MainForm.Handle, PChar('open'), PChar(sCommand),
    PChar(sArgument), PChar(sWorkingDir), SW_NORMAL);

  CodeSite.ExitMethod(Self, 'Viewer2Click');
end;

function TMainForm.WindowsName(FileName: string): string;
begin
  CodeSite.EnterMethod(Self, 'WindowsName');

  if (StrPos(PChar(FileName), PChar(' ')) <> nil) then
    Result := '"' + FileName + '"'
  else
    Result := FileName;

  CodeSite.ExitMethod(Self, 'WindowsName');
end;

{ sc-----------------------------------------------------------------------
  Name:       TMainForm.ShowHint
  -----------------------------------------------------------------------sc }

{ TMainForm.EraseLibraryFiles }

{ sc-----------------------------------------------------------------------
  Name:       TMainForm.StopSCSShell
  -----------------------------------------------------------------------sc }

end.

