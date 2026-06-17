object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'DrunkMouse'
  ClientHeight = 520
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    Left = 216
    Top = 16
    Width = 239
    Height = 54
    Caption = 'Drunk Mouse'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 226
    Top = 70
    Width = 244
    Height = 15
    Caption = 'Trening trafiania w uciekajacy, pijany kursor'
  end
  object LblCzulosc: TLabel
    Left = 32
    Top = 116
    Width = 112
    Height = 15
    Caption = 'Czulosc drgania: 35'
  end
  object Label4: TLabel
    Left = 32
    Top = 182
    Width = 53
    Height = 15
    Caption = 'spokojnie'
  end
  object Label5: TLabel
    Left = 630
    Top = 182
    Width = 34
    Height = 15
    Caption = 'chaos'
  end
  object LabelPoziom: TLabel
    Left = 40
    Top = 222
    Width = 95
    Height = 15
    Caption = 'Poziom trudnosci'
  end
  object LblStatus: TLabel
    Left = 232
    Top = 300
    Width = 76
    Height = 15
    Caption = 'Status: gotowy'
  end
  object LblWynik: TLabel
    Left = 232
    Top = 326
    Width = 78
    Height = 15
    Caption = 'Trafienia: 0 / 10'
  end
  object LblTryb: TLabel
    Left = 232
    Top = 352
    Width = 85
    Height = 15
    Caption = 'Tryb: Lekki stres'
  end
  object LblCzas: TLabel
    Left = 232
    Top = 378
    Width = 62
    Height = 15
    Caption = 'Czas: 00:00'
  end
  object LblHotkey: TLabel
    Left = 40
    Top = 434
    Width = 465
    Height = 15
    Caption = 'Zatrzymanie: przycisk Stop albo Alt+M. Po zatrzymaniu program nie rusza kursorem.'
  end
  object TrackBar1: TTrackBar
    Left = 32
    Top = 136
    Width = 636
    Height = 45
    Max = 150
    Position = 35
    TabOrder = 0
    OnChange = TrackBar1Change
  end
  object BtnStart: TButton
    Left = 40
    Top = 296
    Width = 150
    Height = 34
    Caption = 'Start treningu'
    TabOrder = 1
    OnClick = BtnStartClick
  end
  object CmbPoziom: TComboBox
    Left = 40
    Top = 242
    Width = 180
    Height = 23
    Style = csDropDownList
    ItemIndex = 1
    TabOrder = 2
    Text = 'Normalny'
    OnChange = CmbPoziomChange
    Items.Strings = (
      'Rozgrzewka'
      'Normalny'
      'Chaos'
      'Legenda')
  end
  object ChkKomunikaty: TCheckBox
    Left = 260
    Top = 244
    Width = 170
    Height = 17
    Caption = 'Komunikaty systemowe'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = ChkKomunikatyClick
  end
  object ChkZmieniajTryby: TCheckBox
    Left = 466
    Top = 244
    Width = 190
    Height = 17
    Caption = 'Losuj tryby co kilka sekund'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = ChkZmieniajTrybyClick
  end
  object Info: TButton
    Left = 548
    Top = 474
    Width = 120
    Height = 25
    Caption = 'O programie'
    TabOrder = 5
    OnClick = InfoClick
  end
  object TimerMyszka: TTimer
    Enabled = False
    Interval = 8
    OnTimer = TimerMyszkaTimer
    Left = 24
    Top = 472
  end
  object TimerKomunikaty: TTimer
    Enabled = False
    Interval = 45000
    OnTimer = TimerKomunikatyTimer
    Left = 112
    Top = 472
  end
  object TimerTryby: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerTrybyTimer
    Left = 208
    Top = 472
  end
  object TimerCzas: TTimer
    Enabled = False
    Interval = 1000
    OnTimer = TimerCzasTimer
    Left = 296
    Top = 472
  end
end
