{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit RulePath;

interface

uses
  SysUtils,
  ValidatorRule;

type
  TRulePath = class sealed(TInterfacedObject, IValidationRule)
  private
    _Path: String;
    _IsEnabled: Boolean;
  public
    function Description: String;
    function FailMessage: String;
    function IsValid: Boolean;
    function IsEnabled: Boolean;
    constructor Create(const Path: String; const IsEnabled: Boolean);
    class function New(const Path: String; const IsEnabled: Boolean = True): IValidationRule;
  end;

implementation

function TRulePath.Description: String;
begin
  Result := Format('Validating path "%s"', [_Path]);
end;

function TRulePath.FailMessage: String;
begin
  Result := Format('The path: "%s" is invalid', [_Path]);
end;

function TRulePath.IsEnabled: Boolean;
begin
  Result := _IsEnabled;
end;

function TRulePath.IsValid: Boolean;
begin
  Result := DirectoryExists(_Path);
end;

constructor TRulePath.Create(const Path: String; const IsEnabled: Boolean);
begin
  _Path := Path;
  _IsEnabled := IsEnabled;
end;

class function TRulePath.New(const Path: String; const IsEnabled: Boolean): IValidationRule;
begin
  Result := TRulePath.Create(Path, IsEnabled);
end;

end.
