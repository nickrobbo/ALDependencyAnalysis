table 123456730 "ALDA Module"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ALDA Modules";
    DrillDownPageId = "ALDA Modules";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }

        field(20; NA; Boolean)
        {
            Caption = 'NA';
            DataClassification = ToBeClassified;
        }

        field(1000; Graph; Blob)
        {
            Caption = 'Graph';
            Subtype = Bitmap;
            ObsoleteState = Removed;
        }

        field(1010; GraphMedia; Media)
        {
            Caption = 'GraphMedia';
            ObsoleteState = Removed;
        }

        field(1020; GraphMediaSet; MediaSet)
        {
            Caption = 'GraphMediaSet';
        }

        field(50000; Modified; Boolean)
        {
            Caption = 'Modified';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(123456710; Objects; Integer)
        {
            Caption = 'Objects';
            FieldClass = FlowField;
            CalcFormula = count ("ALDA Model Object" where(Module = field(Code)));
            Editable = false;
        }

        field(123456760; Using; Integer)
        {
            Caption = 'Using';
            FieldClass = FlowField;
            CalcFormula = count ("ALDA Module Link" where("Source Module" = field(Code)));
            Editable = false;
        }

        field(123456761; UsedBy; Integer)
        {
            Caption = 'UsedBy';
            FieldClass = FlowField;
            CalcFormula = count ("ALDA Module Link" where("Target Module" = field(Code)));
            Editable = false;
        }

        field(123456762; Circular; Integer)
        {
            Caption = 'Circular';
            FieldClass = FlowField;
            CalcFormula = count ("ALDA Module Link" where("Source Module" = field(Code), Circular = const(true)));
            Editable = false;
        }
        field(123456763; MultiLevelCircular; Integer)
        {
            Caption = 'MultiLevel Circular';
            FieldClass = FlowField;
            CalcFormula = count ("ALDA Module Link" where("Source Module" = field(Code), MultiLevelCircularCount = filter('>0')));
            Editable = false;
        }

        field(123456770; App; Code[20])
        {
            Caption = 'App';
            DataClassification = ToBeClassified;
            TableRelation = "ALDA App".App;
            ValidateTableRelation = true;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }

        key(App; "App")
        {

        }
    }

    trigger OnModify()
    begin
        Modified := true;
    end;


    trigger OnRename()
    begin
        Error('Not allowed');
    end;

    // procedure MakeGraph()
    // var
    //     ALDAModule: Codeunit "ALDA Module";
    // begin
    //     ALDAModule.MakeGraph(Rec);
    // end;

    procedure MakeGraphText(): Text
    var
        ALDAModule: Codeunit "ALDA Module";
    begin
        exit(ALDAModule.MakeGraphText(Rec));
    end;

    procedure MakeFullGraphText(): Text
    var
        ALDAModule: Codeunit "ALDA Module";
    begin
        exit(ALDAModule.MakeFullGraphText());
    end;

    procedure ToggleIgnore()
    var
        ALDAModule: Codeunit "ALDA Module";
    begin
        ALDAModule.ToggleIgnore(rec);
    end;

    procedure IgnoreAllLinks()
    var
        ALDAModule: Codeunit "ALDA Module";
    begin
        ALDAModule.IgnoreAllLinks(rec);
    end;

}