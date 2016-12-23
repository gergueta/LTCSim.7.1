unit LTCSimUtilities; 

interface 

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


procedure CopyHierSchematics(sDirFrom, sDirTo: string); 
var 
  i: Longint; 
  Alist: TStringList; 
  fileOp: TStFileOperation; 
begin { CopyHierSchematics } { TUpdateSchem.FormActivate } 
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
    Options := [foNoErrorUI, foSilent, foNoConfirmation, foNoConfirmMkDir]; 
    Screen.Cursor := crHourGlass; 
    try 
      Execute; 
      if Error<>0 then 
        MessageDlg(ErrorString, mtError, [mbOk], 0) 
    finally 
      Screen.Cursor := crDefault; 
      Free 
    end { try } 
  end { with fileOp } for i := 0 to (Alist.Count - 1) do 
  begin 
    if (UpperCase(ExtractFileExt(Alist[i]))='.SCH') then 
    begin 
      ListSchematics.Items.Add(Alist[i]) 
    end { (UpperCase(ExtractFileExt(Alist[i]))='.SCH') } 
  end { for i }; 
  Screen.Cursor := crDefault 
end; { CopyHierSchematics } 


{ TUpdateSchem.FormActivate } 
end. 
 