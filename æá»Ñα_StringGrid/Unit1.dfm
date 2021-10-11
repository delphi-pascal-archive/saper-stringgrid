object Form3: TForm3
  Left = 278
  Top = 128
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1057#1072#1087#1077#1088' StringGrid'
  ClientHeight = 266
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 115
    Height = 16
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1080#1085':'
  end
  object Pole: TDrawGrid
    Left = 8
    Top = 40
    Width = 257
    Height = 217
    ColCount = 10
    DefaultColWidth = 16
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    GridLineWidth = 0
    TabOrder = 0
    OnDrawCell = PoleDrawCell
    OnMouseDown = PoleMouseDown
  end
  object Button1: TButton
    Left = 168
    Top = 8
    Width = 97
    Height = 25
    Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 128
    Top = 8
    Width = 33
    Height = 25
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    MaxLength = 2
    ParentFont = False
    TabOrder = 2
    Text = '10'
    OnKeyPress = Edit1KeyPress
  end
end
