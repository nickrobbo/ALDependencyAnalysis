table 123456750 "ALDA Element Link"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ALDA Element Links";
    DrillDownPageId = "ALDA Element Links";

    fields
    {
        field(1; UID; Guid)
        {
            Caption = 'UID';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(1000; "Source Object Type"; Code[20])
        {
            Caption = 'Source Object Type';
            DataClassification = ToBeClassified;
        }

        field(1010; "Source Object ID"; Integer)
        {
            Caption = 'Source Object ID';
            DataClassification = ToBeClassified;
        }

        field(1020; "Source Element"; Text[250])
        {
            Caption = 'Source Element';
            DataClassification = ToBeClassified;
        }

        field(1030; "Source Module"; Text[20])
        {
            Caption = 'Source Module';
            DataClassification = ToBeClassified;
        }

        field(2000; "Target Object Type"; Code[20])
        {
            Caption = 'Target Object Type';
            DataClassification = ToBeClassified;
        }

        field(2010; "Target Object ID"; Integer)
        {
            Caption = 'Target Object ID';
            DataClassification = ToBeClassified;
        }

        field(2020; "Target Element"; Text[250])
        {
            Caption = 'Target Element';
            DataClassification = ToBeClassified;
        }

        field(2030; "Target Module"; Text[20])
        {
            Caption = 'Target Module';
            DataClassification = ToBeClassified;
        }

        field(50000; Modified; Boolean)
        {
            Caption = 'Modified';
            DataClassification = ToBeClassified;
        }

        field(50030; Ignore; Boolean)
        {
            Caption = 'Ignore';
            DataClassification = ToBeClassified;
        }

        field(50040; Remark; Text[200])
        {
            Caption = 'Remark';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "UID")
        {
            Clustered = true;
        }

        key(Module; "Source Module", "Target Module")
        {

        }

        key(SourceModule; "Source Module")
        {

        }

        key(TargetModule; "Target Module")
        {

        }

        key(SourceObject; "Source Object Type", "Source Object ID")
        {

        }

        key(TargetObject; "Target Object Type", "Target Object ID")
        {

        }
    }

    trigger OnInsert()
    begin
        SetModules();
        SetLink();
    end;

    trigger OnModify()
    begin
        Modified := true;
        SetLink();
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
        Error('Not allowed');
    end;

    procedure SetModules()
    var
        ALDAModelObject: Record "ALDA Model Object";
        ALDAModule: Record "ALDA Module";
    begin
        if "Source Module" = '' then begin
            ALDAModelObject.Reset();
            ALDAModelObject.SetRange("Object Type", "Source Object Type");
            ALDAModelObject.SetRange("Object ID", "Source Object ID");
            if ALDAModelObject.FindFirst() then
                if ALDAModule.Get(ALDAModelObject.Module) then begin
                    "Source Module" := ALDAModelObject.Module;
                    if ALDAModule.NA then
                        Ignore := true;
                end;
        end;

        if "Target Module" = '' then begin
            ALDAModelObject.Reset();
            ALDAModelObject.SetRange("Object Type", "Target Object Type");
            ALDAModelObject.SetRange("Object ID", "Target Object ID");
            if ALDAModelObject.FindFirst() then
                if ALDAModule.Get(ALDAModelObject.Module) then begin
                    "Target Module" := ALDAModelObject.Module;
                    if ALDAModule.NA then
                        Ignore := true;
                end;
        end;
    end;

    procedure SetLink()
    var
        ALDAModuleLink: Record "ALDA Module Link";
    begin
        if (("Source Module" = '') or ("Target Module" = '')) then
            exit;

        if (ALDAModuleLink.Get("Source Module", "Target Module")) then
            exit;

        clear(ALDAModuleLink);
        ALDAModuleLink."Source Module" := "Source Module";
        ALDAModuleLink."Target Module" := "Target Module";
        ALDAModuleLink.Ignore := Ignore;
        ALDAModuleLink.Insert();
    end;

    procedure ToggleIgnore()
    var
        ALDAElementLink: Codeunit "ALDA Element Link";
    begin
        ALDAElementLink.ToggleIgnore(Rec);
    end;
}