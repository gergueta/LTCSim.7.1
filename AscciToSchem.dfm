object ASCIIToSchemForm: TASCIIToSchemForm
  Left = 284
  Top = 163
  Caption = 'ASCII to Schematics'
  ClientHeight = 473
  ClientWidth = 501
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
    Top = 454
    Width = 501
    Height = 19
    Hint = ''
    ControlGap = 3
    Panels = <>
    ValidationPanelNumber = 0
    Bevel.Mode = bmCustom
    Align = alBottom
    ExplicitTop = 458
    ExplicitWidth = 509
  end
  object JamFileListAsc: TJamFileList
    Left = 0
    Top = 0
    Width = 501
    Height = 454
    ParentFont = True
    UseSystemFont = False
    Align = alClient
    IconOptions.AutoArrange = True
    ShowContextMenuOnTop = False
    TabOrder = 1
    SearchOptions.MaxFileSize = -1
    SearchOptions.MinFileSize = 0
    SearchOptions.Filter = '*'
    ExplicitWidth = 509
    ExplicitHeight = 458
  end
  object MainMenu: TMainMenu
    Left = 104
    Top = 448
    object Schematics2: TMenuItem
      Caption = 'Schematics'
      object SelectallASCIIfilesasc1: TMenuItem
        Caption = 'Select all ASCII files (asc)'
        OnClick = SelectAllClick
      end
      object Generateschematicssch1: TMenuItem
        Caption = 'Generate schematics (sch)'
        OnClick = GenerateSchematicsClick
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
