unit DataModule;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs,
  // DBTables,
  DB,
  // ffdb, ffdbbase, ffllcomm, fflllgcy, ffllbase,
  // ffllcomp, fflleng, ffsrintm, ffclreng,
  ADODB, Uni, MemDS, DBAccess,
  UniProvider, PostgreSQLUniProvider;

type
  TLibraryDatabase = class(TDataModule)
    DataSource: TDataSource;
    UniConnectionLTCSim: TUniConnection;
    UniQueryNames: TUniQuery;
    UniQuery: TUniQuery;
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
