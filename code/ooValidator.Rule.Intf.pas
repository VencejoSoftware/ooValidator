{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooValidator.Rule.Intf;

interface

type
  IValidationRule = interface
    ['{068946B5-30D5-4F7A-B952-9FA68E46A2AC}']
    function IsValid: boolean;
    function InvalidMessage: String;
    function Description: String;
    function IsEnabled: boolean;
  end;

implementation

end.
