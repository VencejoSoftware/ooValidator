{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooRule.Path_Test;

interface

uses
  SysUtils,
  ooValidator.Rule.Intf;

type
  TRulePath = class sealed(TInterfacedObject, IValidationRule)
  private
    _Path: String;
    _IsEnabled: Boolean;
  public
    function IsValid: Boolean;
    function InvalidMessage: String;
    function Description: String;
    function IsEnabled: Boolean;

    constructor Create(const Path: String; const IsEnabled: Boolean = True);
  end;

implementation

function TRulePath.Description: String;
begin
  Result := 'Validating path';
end;

function TRulePath.InvalidMessage: String;
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

constructor TRulePath.Create(const Path: String; const IsEnabled: Boolean = True);
begin
  _Path := Path;
  _IsEnabled := IsEnabled;
end;

end.
