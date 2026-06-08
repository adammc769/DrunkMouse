object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'DrunkMouse'
  ClientHeight = 441
  ClientWidth = 624
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
    Left = 168
    Top = 8
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
    Left = 120
    Top = 68
    Width = 162
    Height = 15
    Caption = 'Program do prankowania ludzi'
  end
  object Label3: TLabel
    Left = 224
    Top = 131
    Width = 126
    Height = 15
    Caption = 'Czu'#322'o'#347#263' drgania myszk'#261
  end
  object Label4: TLabel
    Left = 16
    Top = 192
    Width = 26
    Height = 15
    Caption = 'Ma'#322'a'
  end
  object Label5: TLabel
    Left = 590
    Top = 192
    Width = 26
    Height = 15
    Caption = 'Du'#380'a'
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 152
    Width = 617
    Height = 45
    Max = 150
    TabOrder = 0
  end
  object BtnStart: TButton
    Left = 24
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = BtnStartClick
  end
  object Info: TButton
    Left = 541
    Top = 408
    Width = 75
    Height = 25
    Caption = 'O programie'
    TabOrder = 2
    OnClick = InfoClick
  end
  object TimerMyszka: TTimer
    Enabled = False
    Interval = 1
    OnTimer = TimerMyszkaTimer
    Left = 24
    Top = 384
  end
  object TimerKomunikaty: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TimerKomunikatyTimer
    Left = 120
    Top = 384
  end
  object TimerTryby: TTimer
    Enabled = False
    Left = 208
    Top = 384
  end
end
