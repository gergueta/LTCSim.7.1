object NewRevForm: TNewRevForm
  Left = 288
  Top = 275
  Caption = 'Creating new revision'
  ClientHeight = 739
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 329
    Width = 687
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 370
  end
  object LMDDlgButtonPanel1: TLMDDlgButtonPanel
    Left = 0
    Top = 699
    Width = 687
    Height = 40
    Hint = ''
    Align = alBottom
    Bevel.Mode = bmCustom
    TabOrder = 0
    BtnAlign = baRightBottom
    object btnOK1: TLMDButton
      Left = 567
      Top = 7
      Width = 50
      Height = 25
      Hint = ''
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel1: TLMDButton
      Left = 627
      Top = 7
      Width = 50
      Height = 25
      Hint = ''
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object ProgressBarCopyOldFiles: TProgressBar
      Left = 3
      Top = 5
      Width = 534
      Height = 32
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 687
    Height = 329
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 392
      Top = 13
      Width = 64
      Height = 13
      Caption = 'New revision:'
    end
    object LMDRadioGroupUpdateFromServer: TLMDRadioGroup
      Left = 0
      Top = 0
      Width = 153
      Height = 65
      Hint = ''
      Bevel.Mode = bmStandard
      Bevel.StandardStyle = lsFrameInset
      BtnAlignment.Alignment = agCenterLeft
      Caption = 'Update libraries from server?'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = []
      Items.Strings = (
        'Yes'
        'No')
      TabOrder = 0
      ItemIndex = 0
    end
    object EditNewRev: TEdit
      Left = 352
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object LMDCheckGroup: TLMDCheckGroup
      Left = 8
      Top = 71
      Width = 641
      Height = 242
      Hint = ''
      Bevel.Mode = bmStandard
      Bevel.StandardStyle = lsFrameInset
      BtnAlignment.Alignment = agCenterLeft
      Caption = 'Migrate:'
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Sans Serif'
      CaptionFont.Style = []
      Items.Strings = (
        'Schematics (*.sch)'
        'Symbols (*.sym)'
        'LTspice schematics (*.asc)'
        'LTspice symbols (*.asy)'
        'PSpice/HSpice netlists (*.spi)'
        'LVS netlists (*.net/*.lvh)'
        'PSpice stimulus (*.cir)'
        'HSpice stimulus (*.sp)'
        'All of the above ')
      TabOrder = 2
      OnChange = LMDCheckGroupChange
      Value = -1
    end
    object FilesSearch: TButton
      Left = 544
      Top = 30
      Width = 105
      Height = 25
      Caption = 'Search'
      TabOrder = 3
      OnClick = FilesSearchClick
    end
    object eOldRev: TLabeledEdit
      Left = 176
      Top = 32
      Width = 121
      Height = 21
      EditLabel.Width = 58
      EditLabel.Height = 13
      EditLabel.Caption = 'Old revision:'
      ReadOnly = True
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 332
    Width = 687
    Height = 367
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object SearchFileList: TJamFileList
      Left = 1
      Top = 1
      Width = 685
      Height = 365
      ParentFont = True
      UseSystemFont = False
      Align = alClient
      IconOptions.AutoArrange = True
      RowSelect = True
      ShowContextMenuOnTop = False
      TabOrder = 0
      SearchOptions.MaxFileSize = -1
      SearchOptions.MinFileSize = 0
      SearchOptions.Filter = '*'
    end
  end
end
