object FormCel: TFormCel
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'DrunkMouse target'
  ClientHeight = 250
  ClientWidth = 430
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  TextHeight = 15
  object LabelCel: TLabel
    Left = 0
    Top = 0
    Width = 430
    Height = 250
    Alignment = taCenter
    AutoSize = False
    Caption = 'TRAFIENIA: 0 / 10'#13#10'Wejdz myszka w pole'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    Layout = tlCenter
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
end
