object SchemToAsciiForm: TSchemToAsciiForm
  Left = 244
  Top = 144
  Caption = 'Schematics to Ascii'
  ClientHeight = 422
  ClientWidth = 451
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
    Top = 403
    Width = 451
    Height = 19
    Hint = ''
    ControlGap = 3
    Panels = <>
    ValidationPanelNumber = 0
    Bevel.Mode = bmCustom
    Align = alBottom
    ExplicitTop = 407
    ExplicitWidth = 459
  end
  object JamFileListSch: TJamFileList
    Left = 0
    Top = 0
    Width = 451
    Height = 403
    ParentFont = True
    UseSystemFont = False
    Align = alClient
    IconOptions.AutoArrange = True
    ShowContextMenuOnTop = False
    TabOrder = 1
    SearchOptions.MaxFileSize = -1
    SearchOptions.MinFileSize = 0
    SearchOptions.Filter = '*'
    ExplicitWidth = 459
    ExplicitHeight = 407
  end
  object MainMenu: TMainMenu
    Left = 136
    Top = 376
    object Schematics3: TMenuItem
      Caption = 'Schematics'
      object Selectallschematicfiles1: TMenuItem
        Caption = 'Select all schematic files'
        OnClick = SelectAllClick
      end
      object GenerateASCIIfiles2: TMenuItem
        Caption = 'Generate ASCII files'
        OnClick = GenerateASCIIfilesClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit2: TMenuItem
        Caption = 'Exit'
        OnClick = CloseClick
      end
    end
  end
end
