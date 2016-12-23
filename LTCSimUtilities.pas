{ $HDR$}
{**********************************************************************}
{LTCSim is Copyright 1999 by Linear technology Corp.      }
{*********************************************************************}
{}
{ $Log:
{
{   Rev 1.1    5/4/2001 3:48:50 AM      Version: 5.0.0.4
}
{
{   Rev 1.1    5/2/2001 6:00:06 PM      Version: 5.0.0.2
}
{
{   Rev 1.1    4/26/2001 8:26:50 AM  
{ From 4.5
}
{
{   Rev 1.0    4/12/2001 9:53:30 PM  
{ Initial copy from 4.1.0.31
}
{
{   Rev 1.0    4/11/2001 10:08:07 PM  german_e    Version: 5.0.0.1
{ Starting with 4.0
}
{}
unit LTCSimUtilities;

interface

uses
  SysUtils, StUtils, StStrS, StFileOp, Classes;

function SchFilesOnly(const SR: TSearchRec; ForInclusion: Boolean) : Boolean;
  far;
procedure CopyHierSchematics(sDirFrom, sDirTo: string);

implementation
function SchFilesOnly(const SR: TSearchRec; ForInclusion: Boolean) : Boolean;
  far;
var
  S: string;
begin { SchFilesOnly }
  if ForInclusion then
  begin
    result := False;
    S := SR.Name;
    if (UpperCase(ExtractFileExt(S))='.SCH')
        or
       ((SR.attr
          and
         faDirectory)>0) then
    begin
      result := True
    end { (UpperCase(ExtractFileExt(S))='.SCH')  }
  end { ForInclusion }
  else
  begin
    result := True
  end { not (ForInclusion) }
end; { SchFilesOnly }

procedure CopyHierFiles(sDirFrom, sDirTo: string);
var
  i: Longint;
  Alist: TStringList;
  fileOp: TStFileOperation;
begin { TUpdateSchem.FormActivate }
  Alist := TStringList.Create;
  Alist.Clear;
  EnumerateFiles(sDirFrom, Alist, True, SchFilesOnly);
          fileOp := TStFileOperation.Create(Self);
          with fileOp do
          begin
            Operation := fopCopy;
            SourceFiles.Clear;
            SourceFiles = Alist;
            Destination := sNewRevDir + '\schem';
            Options := [foNoErrorUI, foSilent, foNoConfirmation,
              foNoConfirmMkDir];
            Screen.Cursor := crHourGlass;
            try
              Execute;
              if Error<>0 then
                MessageDlg(ErrorString, mtError, [mbOk], 0)
            finally
              Screen.Cursor := crDefault;
              Free
            end { try }
          end { with fileOp }
  for i := 0 to (Alist.Count - 1) do
  begin
    if (UpperCase(ExtractFileExt(Alist[i]))='.SCH') then
    begin
      ListSchematics.Items.Add(Alist[i])
    end { (UpperCase(ExtractFileExt(Alist[i]))='.SCH') }
  end { for i };
  Screen.Cursor := crDefault
end; { TUpdateSchem.FormActivate }

end.
