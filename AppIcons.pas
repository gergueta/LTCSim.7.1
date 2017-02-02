unit AppIcons;

interface

uses
  System.SysUtils, System.Classes,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  ShellBrowser, Vcl.ExtCtrls, LMDCustomComponent, LMDShBase, LMDStarter,
  Vcl.Dialogs, JAMDialogs, ShellLink, JamControls, LMDStorBase,
  LMDStorRegistryVault, LMDCustomIniComponent, LMDBaseMRUList, LMDMRUList,
  LMDDckSite;

type
  TIconModule = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IconModule: TIconModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
