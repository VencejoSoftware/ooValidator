{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooValidator.Engine;

interface

uses
  SysUtils,
  Generics.Collections,
  ooValidator.Rule.Intf;

type
  EValidatorEngine = class(Exception)
  end;

  IValidatorEngine = interface
    ['{8A0BCA61-E3CC-44D3-BEF0-D1DC2A14DF44}']
    function Add(const Rule: IValidationRule): Integer;
    function Execute: Boolean;
  end;

  TOnBeforeValidateRule = procedure(const Rule: IValidationRule) of object;
  TOnAfterValidateRule = procedure(const Rule: IValidationRule; const aIsValid: Boolean) of object;

  TValidatorEngine = class sealed(TInterfacedObject, IValidatorEngine)
  strict private
  type
    _TRulesList = TList<IValidationRule>;
  strict private
    _List: _TRulesList;
    _OnBeforeValidate: TOnBeforeValidateRule;
    _OnAfterValidate: TOnAfterValidateRule;
  private
    procedure DoBeforeValidateRule(const Rule: IValidationRule);
    procedure DoAfterValidateRule(const Rule: IValidationRule; const aIsValid: Boolean);
  public
    function Add(const Rule: IValidationRule): Integer;
    function Execute: Boolean;
    constructor Create(const BeforeValidate: TOnBeforeValidateRule; const AfterValidate: TOnAfterValidateRule);
    destructor Destroy; override;
    class function New(const BeforeValidate: TOnBeforeValidateRule; const AfterValidate: TOnAfterValidateRule)
      : IValidatorEngine;
  end;

implementation

procedure TValidatorEngine.DoBeforeValidateRule(const Rule: IValidationRule);
begin
  if Assigned(_OnBeforeValidate) then
    _OnBeforeValidate(Rule);
end;

procedure TValidatorEngine.DoAfterValidateRule(const Rule: IValidationRule; const aIsValid: Boolean);
begin
  if Assigned(_OnAfterValidate) then
    _OnAfterValidate(Rule, aIsValid);
end;

function TValidatorEngine.Add(const Rule: IValidationRule): Integer;
begin
  Result := _List.Add(Rule);
end;

function TValidatorEngine.Execute: Boolean;
var
  Rule: IValidationRule;
begin
  Result := False;
  for Rule in _List do
  begin
    if Rule.IsEnabled then
    begin
      DoBeforeValidateRule(Rule);
      Result := Rule.IsValid;
      DoAfterValidateRule(Rule, Result);
      if not Result then
        raise EValidatorEngine.Create(Rule.InvalidMessage);
    end;
  end;
end;

constructor TValidatorEngine.Create(const BeforeValidate: TOnBeforeValidateRule;
  const AfterValidate: TOnAfterValidateRule);
begin
  _List := _TRulesList.Create;
  _OnBeforeValidate := BeforeValidate;
  _OnAfterValidate := AfterValidate;
end;

class function TValidatorEngine.New(const BeforeValidate: TOnBeforeValidateRule;
  const AfterValidate: TOnAfterValidateRule): IValidatorEngine;
begin
  Result := TValidatorEngine.Create(BeforeValidate, AfterValidate);
end;

destructor TValidatorEngine.Destroy;
begin
  _List.Free;
  inherited;
end;

end.
