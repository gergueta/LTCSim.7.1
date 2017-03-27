{ $HDR$ }
{
  $Header: D:\\CVSROOT/Delphi/Tool/LTCSim.dpr,v 1.1 2005/03/14 18:24:57 german Exp $
}
program LTCSim;

uses
  Forms,
  AboutDialog in 'AboutDialog.pas' {AboutBox},
  ProcessDialog in 'ProcessDialog.pas' {PagesDlg},
  StimDlg in 'StimDlg.pas' {DlgStim},
  UpdateWarning in 'UpdateWarning.pas' {UpdateWarningDlg},
  Main in 'Main.pas' {MainForm},
  AscciToSchem in 'AscciToSchem.pas' {ASCIIToSchemForm},
  SchemToAscii in 'SchemToAscii.pas' {SchemToAsciiForm},
  SymToAsy in 'SymToAsy.pas' {SymToAsyForm},
  AsyToSymbols in 'AsyToSymbols.pas' {AsyToSymForm},
  NewRevWithoutProcessCode in 'NewRevWithoutProcessCode.pas' {NewRevForm},
  UpdateSchematics in 'UpdateSchematics.pas' {UpdateSchemDlg},
  DisplayHideAttr in 'DisplayHideAttr.pas' {DisplayHideAttrDlg},
  LTCSimArchive in 'LTCSimArchive.pas' {LTCSimArchiveForm},
  AxNetwork_TLB in 'ActivExperts\AxNetwork_TLB.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  TStyleManager.TrySetStyle('Windows10 Blue');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  TStyleManager.TrySetStyle('Windows10');
  Application.HelpFile := 'LTCSim.hlp';
  Application.Title := 'LTCSim';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TPagesDlg, PagesDlg);
  Application.CreateForm(TDlgStim, DlgStim);
  Application.CreateForm(TUpdateWarningDlg, UpdateWarningDlg);
  Application.CreateForm(TASCIIToSchemForm, ASCIIToSchemForm);
  Application.CreateForm(TSchemToAsciiForm, SchemToAsciiForm);
  Application.CreateForm(TSymToAsyForm, SymToAsyForm);
  Application.CreateForm(TAsyToSymForm, AsyToSymForm);
  Application.CreateForm(TNewRevForm, NewRevForm);
  Application.CreateForm(TUpdateSchemDlg, UpdateSchemDlg);
  Application.CreateForm(TDisplayHideAttrDlg, DisplayHideAttrDlg);
  Application.CreateForm(TLTCSimArchiveForm, LTCSimArchiveForm);
  Application.Run

end.
