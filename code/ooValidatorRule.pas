{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Validation rule object
  @created(31/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooValidatorRule;

interface

type
{$REGION 'documentation'}
{
  @abstract(Validation rule interface)
  Defines a rule to validate with the validator engine
  @member(
    Description Rule description
    @return(String with description)
  )
  @member(
    FailMessage Message to show when rule fail
    @return(String with message)
  )
  @member(
    IsValid Checks if the rule is valid
    @return(@true is rule is ok, @false if fail)
  )
  @member(
    IsEnabled Checks if the rule is enabled to use
    @return(@true is rule is enabled, @false if not)
  )
}
{$ENDREGION}
  IValidationRule = interface
    ['{068946B5-30D5-4F7A-B952-9FA68E46A2AC}']
    function Description: String;
    function FailMessage: String;
    function IsValid: Boolean;
    function IsEnabled: Boolean;
  end;

implementation

end.
