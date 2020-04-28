codeunit 123456750 "ALDA Element Link"
{
    procedure ToggleIgnore(var ALDAElementLink: Record "ALDA Element Link")
    begin
        ALDAElementLink.Ignore := not ALDAElementLink.Ignore;
        ALDAElementLink.Modify();
    end;
}