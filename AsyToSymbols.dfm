object AsyToSymForm: TAsyToSymForm
  Left = 517
  Top = 104
  BorderStyle = bsDialog
  Caption = 'Asy to Symbols'
  ClientHeight = 426
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LMDStatusBar1: TLMDStatusBar
    Left = 0
    Top = 407
    Width = 452
    Height = 19
    Hint = ''
    ControlGap = 3
    Panels = <>
    ValidationPanelNumber = 0
    Bevel.Mode = bmCustom
    Align = alBottom
  end
  object JamFileListAsy: TJamFileList
    Left = 0
    Top = 0
    Width = 452
    Height = 407
    ParentFont = True
    UseSystemFont = False
    Align = alClient
    IconOptions.AutoArrange = True
    ShowContextMenuOnTop = False
    TabOrder = 1
    SearchOptions.MaxFileSize = -1
    SearchOptions.MinFileSize = 0
    SearchOptions.Filter = '*'
  end
  object MainMenu: TMainMenu
    Left = 104
    Top = 400
    object Symbols2: TMenuItem
      Caption = 'Symbols'
      OnClick = SelectAllASCIISymbolsFilesClick
      object SelectallASCIIsymbolsfilesasy1: TMenuItem
        Caption = 'Select all ASCII symbols files (asy)'
        OnClick = SelectAllASCIISymbolsFilesClick
      end
      object GenerateSymbols1: TMenuItem
        Caption = 'Generate Symbols'
        OnClick = ASCIIToSymbolsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = CloseClick
      end
    end
  end
end
