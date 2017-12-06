{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooValidator.Engine_test;

interface

uses
  Forms, SysUtils,
  ooValidator.Engine, ooRule.Path_Test,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TValidatorEngineTest = class(TTestCase)
  private
    _PathValidator: TValidatorEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestOk;
    procedure TestError;
    procedure TestDisabled;
  end;

implementation

procedure TValidatorEngineTest.SetUp;
begin
  inherited;
  _PathValidator := TValidatorEngine.Create(nil, nil);
end;

procedure TValidatorEngineTest.TearDown;
begin
  inherited;
  _PathValidator.Free;
end;

procedure TValidatorEngineTest.TestDisabled;
begin
  _PathValidator.Add(TRulePath.Create(ExtractFilePath(Application.ExeName)));
  _PathValidator.Add(TRulePath.Create('C:\'));
  _PathValidator.Add(TRulePath.Create('error path', False));
  CheckTrue(_PathValidator.Execute);
end;

procedure TValidatorEngineTest.TestError;
begin
  try
    _PathValidator.Add(TRulePath.Create('error path'));
  except
    on EValidatorEngine do
      CheckFalse(_PathValidator.Execute);
  end;
end;

procedure TValidatorEngineTest.TestOk;
begin
  _PathValidator.Add(TRulePath.Create(ExtractFilePath(Application.ExeName)));
  CheckTrue(_PathValidator.Execute);
end;

initialization

RegisterTest(TValidatorEngineTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
