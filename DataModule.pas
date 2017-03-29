unit DataModule;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs,
  // DBTables,
  DB,
  // ffdb, ffdbbase, ffllcomm, fflllgcy, ffllbase,
  // ffllcomp, fflleng, ffsrintm, ffclreng,
  ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TLibraryDatabase = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LibraryDatabase: TLibraryDatabase;

implementation

{$R *.DFM}

end.
