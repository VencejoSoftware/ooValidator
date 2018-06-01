[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooValidator.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooValidator)

# ooValidator - Object pascal rule validator engine library
Code to define several validating logic rules as precondition to run something


### Example of rule object definition
```pascal
...
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

...

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
```

### Example of validator engine execution
```pascal
var
  PathValidator: IValidatorEngine;
begin
  PathValidator := TValidatorEngine.New(nil, nil);
  PathValidator.Add(TRulePath.New(ExtractFilePath(Application.ExeName)));
  PathValidator.Add(TRulePath.New('C:\'));
  if PathValidator.Execute then
    ShowMessage('All is ok!');
end;
```

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### Demo
Before all, run the batch "build_demo" to build proyect. Then go to the folder "demo\build\release\" and run the executable.

## Dependencies
* [ooGeneric](https://github.com/VencejoSoftware/ooGeneric.git) - Generic object oriented list

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*