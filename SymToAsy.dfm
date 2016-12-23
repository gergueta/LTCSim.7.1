object SymToAsyForm: TSymToAsyForm
  Left = 192
  Top = 108
  Caption = 'Symbol to Ascii'
  ClientHeight = 433
  ClientWidth = 413
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
    Top = 414
    Width = 413
    Height = 19
    Hint = ''
    ControlGap = 3
    Panels = <>
    ValidationPanelNumber = 0
    Bevel.Mode = bmCustom
    Align = alBottom
    ExplicitTop = 418
    ExplicitWidth = 421
  end
  object JamFileListSym: TJamFileList
    Left = 0
    Top = 0
    Width = 413
    Height = 414
    ParentFont = True
    UseSystemFont = False
    Align = alClient
    IconOptions.AutoArrange = True
    ShowContextMenuOnTop = False
    TabOrder = 1
    SearchOptions.MaxFileSize = -1
    SearchOptions.MinFileSize = 0
    SearchOptions.Filter = '*'
    ExplicitWidth = 421
    ExplicitHeight = 418
  end
  object MainMenu: TMainMenu
    Left = 144
    Top = 400
    object Symbols2: TMenuItem
      Caption = 'Symbols'
      object Selectallsymbolfiles2: TMenuItem
        Caption = 'Select all symbol files'
        OnClick = SelectAllSymbolFilesClick
      end
      object GenerateASCIIfilesasc1: TMenuItem
        Caption = 'Generate ASCII files (asc)'
        OnClick = SymbolsToASCIIClick
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
