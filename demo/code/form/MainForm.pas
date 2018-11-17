{
  Copyright (c) 2018 Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ValidatorEngine,
  ValidatorRule;

type
  TMainForm = class(TForm)
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    Validator: IValidatorEngine;
  end;

var
  NewMainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

type
  TRuleEditNotEmpty = class sealed(TInterfacedObject, IValidationRule)
  private
    _Edit: TEdit;
  public
    function Description: String;
    function FailMessage: String;
    function IsValid: Boolean;
    function IsEnabled: Boolean;
    constructor Create(const Edit: TEdit);
    class function New(const Edit: TEdit): IValidationRule;
  end;

  TRuleCheckBoxTrue = class sealed(TInterfacedObject, IValidationRule)
  private
    _CheckBox: TCheckBox;
  public
    function Description: String;
    function FailMessage: String;
    function IsValid: Boolean;
    function IsEnabled: Boolean;
    constructor Create(const CheckBox: TCheckBox);
    class function New(const CheckBox: TCheckBox): IValidationRule;
  end;

{ TRuleEditNotEmpty }

function TRuleEditNotEmpty.Description: String;
begin
  Result := Format('Validating control "%s"', [_Edit.Name]);
end;

function TRuleEditNotEmpty.FailMessage: String;
begin
  Result := Format('"%s" can not be empty', [_Edit.Name]);
  _Edit.Color := clRed;
  _Edit.SetFocus;
end;

function TRuleEditNotEmpty.IsEnabled: Boolean;
begin
  Result := True;
end;

function TRuleEditNotEmpty.IsValid: Boolean;
begin
  Result := Length(Trim(_Edit.Text)) > 0;
end;

constructor TRuleEditNotEmpty.Create(const Edit: TEdit);
begin
  _Edit := Edit;
end;

class function TRuleEditNotEmpty.New(const Edit: TEdit): IValidationRule;
begin
  Result := TRuleEditNotEmpty.Create(Edit);
end;

{ TRuleCheckBoxTrue }

function TRuleCheckBoxTrue.Description: String;
begin
  Result := Format('Validating control "%s"', [_CheckBox.Name]);
end;

function TRuleCheckBoxTrue.FailMessage: String;
begin
  Result := Format('"%s" must be checked', [_CheckBox.Name]);
  _CheckBox.SetFocus;
end;

function TRuleCheckBoxTrue.IsEnabled: Boolean;
begin
  Result := True;
end;

function TRuleCheckBoxTrue.IsValid: Boolean;
begin
  Result := _CheckBox.Checked;
end;

constructor TRuleCheckBoxTrue.Create(const CheckBox: TCheckBox);
begin
  _CheckBox := CheckBox;
end;

class function TRuleCheckBoxTrue.New(const CheckBox: TCheckBox): IValidationRule;
begin
  Result := TRuleCheckBoxTrue.Create(CheckBox);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  try
    if Validator.Execute then
      ShowMessage('Validate is ok');
  except
    on E: EValidatorEngine do
      ShowMessage(E.Message);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Validator := TValidatorEngine.New(nil, nil);
  Validator.Add(TRuleEditNotEmpty.New(Edit1));
  Validator.Add(TRuleCheckBoxTrue.New(CheckBox1));
end;

end.
