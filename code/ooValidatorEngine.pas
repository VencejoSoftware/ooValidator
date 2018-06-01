{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Validator rule engine object
  @created(31/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooValidatorEngine;

interface

uses
  SysUtils,
  ooList, ooIterableList,
  ooValidatorRule;

type
{$REGION 'documentation'}
{
  Class for validator engin error object
}
{$ENDREGION}
  EValidatorEngine = class(Exception)
  end;

{$REGION 'documentation'}
{
  @abstract(Validator rule engine interface)
  Defines a engine which a list of rules to validate
  @member(
    Add Add a new rule to the engine
    @return(Index of the item in the list)
  )
  @member(
    Execute Run all enabled rules and stop if something fail
    @return(@true if all rules are valid, @false if fail)
  )
}
{$ENDREGION}

  IValidatorEngine = interface
    ['{8A0BCA61-E3CC-44D3-BEF0-D1DC2A14DF44}']
    function Add(const Rule: IValidationRule): TIntegerIndex;
    function Execute: Boolean;
  end;

{$REGION 'documentation'}
{
  @abstract(Before execute rule event callback)
  @param(Rule @link(IValidationRule Current rule in engine))
}
{$ENDREGION}
{$IFDEF FPC}

  TOnBeforeValidate = procedure(const Rule: IValidationRule);
  TOnBeforeValidateOfObject = procedure(const Rule: IValidationRule) of object;
{$ELSE}
  TOnBeforeValidate = reference to procedure(const Rule: IValidationRule);
{$ENDIF}
{$REGION 'documentation'}
{
  @abstract(After execute rule event callback)
  @param(Rule @link(IValidationRule Current rule in engine))
  @param(IsValid Rule validating return)
}
{$ENDREGION}
{$IFDEF FPC}
  TOnAfterValidate = procedure(const Rule: IValidationRule; const IsValid: Boolean);
  TOnAfterValidateOfObject = procedure(const Rule: IValidationRule; const IsValid: Boolean) of object;
{$ELSE}
  TOnAfterValidate = reference to procedure(const Rule: IValidationRule; const IsValid: Boolean);
{$ENDIF}
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IValidatorEngine))
  @member(Add @SeeAlso(IValidatorEngine.Add))
  @member(Execute @SeeAlso(IValidatorEngine.Execute))
  @member(
    DoBeforeValidateRule Try to raise before event callback
    @param(Rule @link(IValidationRule Current rule in engine))
  )
  @member(
    DoAfterValidateRule Try to raise after event callback
    @param(Rule @link(IValidationRule Current rule in engine))
    @param(IsValid Rule validating return)
  )
  @member(
    Create Object constructor
    @param(OnBefore Before execute rule event callback)
    @param(OnAfter After execute rule event callback)
  )
  @member(
    New Create a new @classname as interface
    @param(OnBefore Before execute rule event callback)
    @param(OnAfter After execute rule event callback)
  )
}
{$ENDREGION}

  TValidatorEngine = class sealed(TInterfacedObject, IValidatorEngine)
  strict private
    _List: IIterableList<IValidationRule>;
    _OnBefore: TOnBeforeValidate;
    _OnAfter: TOnAfterValidate;
{$IFDEF FPC}
    _OnBeforeOfObject: TOnBeforeValidateOfObject;
    _OnAfterOfObject: TOnAfterValidateOfObject;
{$ENDIF}
  private
    procedure DoBeforeValidateRule(const Rule: IValidationRule);
    procedure DoAfterValidateRule(const Rule: IValidationRule; const IsValid: Boolean);
  public
    function Add(const Rule: IValidationRule): TIntegerIndex;
    function Execute: Boolean;
    constructor Create(const OnBefore: TOnBeforeValidate; const OnAfter: TOnAfterValidate
{$IFDEF FPC}
      ; const OnBeforeOfObject: TOnBeforeValidateOfObject; const OnAfterOfObject: TOnAfterValidateOfObject
{$ENDIF}
      );
    class function New(const OnBefore: TOnBeforeValidate; const OnAfter: TOnAfterValidate): IValidatorEngine;
{$IFDEF FPC}
    class function NewOfObject(const OnBeforeOfObject: TOnBeforeValidateOfObject;
      const OnAfterOfObject: TOnAfterValidateOfObject): IValidatorEngine;
{$ENDIF}
  end;

implementation

procedure TValidatorEngine.DoBeforeValidateRule(const Rule: IValidationRule);
begin
  if Assigned(_OnBefore) then
    _OnBefore(Rule);
{$IFDEF FPC}
  if Assigned(_OnBeforeOfObject) then
    _OnBeforeOfObject(Rule);
{$ENDIF}
end;

procedure TValidatorEngine.DoAfterValidateRule(const Rule: IValidationRule; const IsValid: Boolean);
begin
  if Assigned(_OnAfter) then
    _OnAfter(Rule, IsValid);
{$IFDEF FPC}
  if Assigned(_OnAfterOfObject) then
    _OnAfterOfObject(Rule, IsValid);
{$ENDIF}
end;

function TValidatorEngine.Add(const Rule: IValidationRule): TIntegerIndex;
begin
  Result := _List.Add(Rule);
end;

function TValidatorEngine.Execute: Boolean;
var
  Rule: IValidationRule;
begin
  Result := False;
  for Rule in _List do
    if Rule.IsEnabled then
    begin
      DoBeforeValidateRule(Rule);
      Result := Rule.IsValid;
      DoAfterValidateRule(Rule, Result);
      if not Result then
        raise EValidatorEngine.Create(Rule.FailMessage);
    end;
end;

constructor TValidatorEngine.Create(const OnBefore: TOnBeforeValidate; const OnAfter: TOnAfterValidate
{$IFDEF FPC}
  ; const OnBeforeOfObject: TOnBeforeValidateOfObject; const OnAfterOfObject: TOnAfterValidateOfObject
{$ENDIF});
begin
  _List := TIterableList<IValidationRule>.New;
  _OnBefore := OnBefore;
  _OnAfter := OnAfter;
{$IFDEF FPC}
  _OnBeforeOfObject := OnBeforeOfObject;
  _OnAfterOfObject := OnAfterOfObject;
{$ENDIF}
end;

class function TValidatorEngine.New(const OnBefore: TOnBeforeValidate; const OnAfter: TOnAfterValidate)
  : IValidatorEngine;
begin
  Result := TValidatorEngine.Create(OnBefore, OnAfter{$IFDEF FPC}, nil, nil{$ENDIF});
end;

{$IFDEF FPC}

class function TValidatorEngine.NewOfObject(const OnBeforeOfObject: TOnBeforeValidateOfObject;
  const OnAfterOfObject: TOnAfterValidateOfObject): IValidatorEngine;
begin
  Result := TValidatorEngine.Create(nil, nil, OnBeforeOfObject, OnAfterOfObject);
end;
{$ENDIF}

end.
