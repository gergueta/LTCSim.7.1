object LTCSimArchiveForm: TLTCSimArchiveForm
  Left = 1043
  Top = 216
  BorderStyle = bsDialog
  Caption = 'LTCSim archive utility'
  ClientHeight = 161
  ClientWidth = 606
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFileArchiving: TLabel
    Left = 16
    Top = 88
    Width = 3
    Height = 13
  end
  object CancelBtn: TButton
    Left = 515
    Top = 114
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 122
    Width = 385
    Height = 17
    TabOrder = 1
  end
  object LMDLabeledFileOpenEditTopSchematics: TLMDLabeledFileOpenEdit
    Left = 8
    Top = 24
    Width = 582
    Height = 21
    Hint = ''
    Bevel.Mode = bmWindows
    Caret.BlinkRate = 530
    TabOrder = 2
    CustomButtons = <
      item
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000E0000000D0000000100
          0400000000006800000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D00000000DDD
          DD000033333330DDDD000B033333330DDD000FB033333330DD000BFB03333333
          0D000FBFB000000000000BFBFBFBF0DDDD000FBFBFBFB0DDDD000BFB000000DD
          DD00D000DDDDDD000D00DDDDDDDDDDD00D00DDDDDDD0DD0D0D00DDDDDDDD00DD
          DD00}
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Index = 0
        DisplayName = 'TLMDSpecialButton'
        ImageIndex = 0
        ListIndex = 0
        UsePngGlyph = False
      end>
    CustomButtonWidth = 18
    Filter = 'Schematics|*.sch'
    DefaultExt = 'net'
    FilenameOnly = True
    EditLabel.Width = 79
    EditLabel.Height = 15
    EditLabel.Caption = 'Top schematics:'
  end
  object LMDButton1: TLMDButton
    Left = 410
    Top = 114
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Archive'
    TabOrder = 3
    OnClick = LMDButton1Click
  end
  object LMDDockManagerArchive: TLMDDockManager
    Left = 564
    Top = 56
  end
  object ZipForgeArchive: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clFastest
    CompressionMode = 1
    CurrentVersion = '6.80 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = False
    SpanningOptions.FirstVolumeSize = 0
    SpanningOptions.VolumeSize = vsAutoDetect
    SpanningOptions.CustomVolumeSize = 65536
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    OnFileProgress = ZipForgeArchiveFileProgress
    OnOverallProgress = ZipForgeArchiveOverallProgress
    Zip64Mode = zmDisabled
    UnicodeFilenames = False
    EncryptionMethod = caPkzipClassic
    Left = 460
    Top = 56
  end
  object LMDFileOpenDialogArchive: TLMDFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    FileTypeIndex = 0
    Options = []
    Left = 380
    Top = 56
  end
end
