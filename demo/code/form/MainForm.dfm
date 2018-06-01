object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Demo'
  ClientHeight = 106
  ClientWidth = 176
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 16
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 35
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 64
    Top = 69
    Width = 75
    Height = 25
    Caption = 'Validate'
    TabOrder = 2
    OnClick = Button1Click
  end
end
