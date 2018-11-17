{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ValidatorEngine_test;

interface

uses
  Forms, SysUtils,
  ValidatorEngine,
  ValidatorRule, RulePath,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TValidatorEngineTest = class sealed(TTestCase)
  published
    procedure ExecuteIsOk;
    procedure ExecuteFailedReturnMessage;
    procedure ExecuteWithDisabledRulesIsOk;
    procedure ExecuteWithBeforeCallback;
    procedure ExecuteWithAfterCallback;
  end;

implementation

procedure TValidatorEngineTest.ExecuteIsOk;
var
  PathValidator: IValidatorEngine;
begin
  PathValidator := TValidatorEngine.New(nil, nil);
  PathValidator.Add(TRulePath.New(ExtractFilePath(Application.ExeName)));
  CheckTrue(PathValidator.Execute);
end;

procedure TValidatorEngineTest.ExecuteFailedReturnMessage;
var
  PathValidator: IValidatorEngine;
  Failed: Boolean;
begin
  PathValidator := TValidatorEngine.New(nil, nil);
  Failed := False;
  try
    PathValidator.Add(TRulePath.New('error path'));
    PathValidator.Execute;
  except
    on E: EValidatorEngine do
    begin
      CheckEquals('The path: "error path" is invalid', E.Message);
      Failed := True;
    end;
  end;
  CheckTrue(Failed);
end;

procedure TValidatorEngineTest.ExecuteWithDisabledRulesIsOk;
var
  PathValidator: IValidatorEngine;
begin
  PathValidator := TValidatorEngine.New(nil, nil);
  PathValidator.Add(TRulePath.New(ExtractFilePath(Application.ExeName)));
  PathValidator.Add(TRulePath.New('C:\'));
  PathValidator.Add(TRulePath.New('error path', False));
  CheckTrue(PathValidator.Execute);
end;

procedure TValidatorEngineTest.ExecuteWithBeforeCallback;
var
  PathValidator: IValidatorEngine;
  i: Byte;
{$IFDEF FPC}
  procedure BeforeCallback(const Rule: IValidationRule);
  begin
    case i of
      0:
        CheckEquals('Validating path "' + ExtractFilePath(Application.ExeName) + '"', Rule.Description);
      1:
        CheckEquals('Validating path "C:\"', Rule.Description);
    end;
    Inc(i);
  end;
{$ELSE}
  BeforeCallback: TOnBeforeValidate;
{$ENDIF}
begin
  i := 0;
{$IFDEF FPC}
  PathValidator := TValidatorEngine.New(@BeforeCallback, nil);
{$ELSE}
  BeforeCallback := procedure(const Rule: IValidationRule)
    begin
      case i of
        0:
          CheckEquals('Validating path "' + ExtractFilePath(Application.ExeName) + '"', Rule.Description);
        1:
          CheckEquals('Validating path "C:\"', Rule.Description);
      end;
      Inc(i);
    end;
  PathValidator := TValidatorEngine.New(BeforeCallback, nil);
{$ENDIF}
  PathValidator.Add(TRulePath.New(ExtractFilePath(Application.ExeName)));
  PathValidator.Add(TRulePath.New('C:\'));
  CheckTrue(PathValidator.Execute);
end;

procedure TValidatorEngineTest.ExecuteWithAfterCallback;
var
  PathValidator: IValidatorEngine;
  i: Byte;
{$IFDEF FPC}
  procedure AfterCallback(const Rule: IValidationRule; const IsValid: Boolean);
  begin
    case i of
      0:
        begin
          CheckEquals('Validating path "' + ExtractFilePath(Application.ExeName) + '"', Rule.Description);
          CheckTrue(IsValid);
        end;
      1:
        begin
          CheckEquals('Validating path "C:\"', Rule.Description);
          CheckTrue(IsValid);
        end;
      2:
        begin
          CheckEquals('Validating path "error path"', Rule.Description);
          CheckFalse(IsValid);
        end;
    end;
    Inc(i);
  end;
{$ELSE}
  AfterCallback: TOnAfterValidate;
{$ENDIF}
begin
  i := 0;
{$IFDEF FPC}
  PathValidator := TValidatorEngine.New(nil, @AfterCallback);
{$ELSE}
  AfterCallback := procedure(const Rule: IValidationRule; const IsValid: Boolean)
    begin
      case i of
        0:
          begin
            CheckEquals('Validating path "' + ExtractFilePath(Application.ExeName) + '"', Rule.Description);
            CheckTrue(IsValid);
          end;
        1:
          begin
            CheckEquals('Validating path "C:\"', Rule.Description);
            CheckTrue(IsValid);
          end;
        2:
          begin
            CheckEquals('Validating path "error path"', Rule.Description);
            CheckFalse(IsValid);
          end;
      end;
      Inc(i);
    end;
  PathValidator := TValidatorEngine.New(nil, AfterCallback);
{$ENDIF}
  PathValidator.Add(TRulePath.New(ExtractFilePath(Application.ExeName)));
  PathValidator.Add(TRulePath.New('C:\'));
  PathValidator.Add(TRulePath.New('error path'));
  try
    PathValidator.Execute;
  except
    CheckTrue(True);
  end;
end;

initialization

RegisterTest(TValidatorEngineTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
