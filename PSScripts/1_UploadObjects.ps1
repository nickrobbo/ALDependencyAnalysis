
#Load Functions
function New-ALDAModelObject() {
    param
    (
        [string] $ObjectType,
        [int] $ObjectID,
        [string] $ObjectName,
        [string] $NumberRange,
        [string] $Module
    )

    $UID = [Guid]::NewGuid()
    Invoke-RestMethod -Method Post `
        -Uri "$($Url)//companies($($Companies.value[0].id))/alDAModelObjects" `
        -Credential $Credential `
        -ContentType "application/json" `
        -Body (@{ 
            "uid"         = $UID; 
            "objectType"  = $ObjectType;
            "objectID"    = $ObjectID;
            "objectName"  = $ObjectName;
            "numberRange" = $NumberRange;
            "module"      = $Module;
        } | ConvertTo-Json -Depth 100)  
}

#Add them to the database
foreach ($ModelObject in $model.NAVObjects) {
    try {
        $Module = $ModelObject.ParentObjectName.Split(" ")[0].Split("-")[0]   
    }
    catch {
        $Module = '';
    }
    
    New-ALDAModelObject -ObjectType $ModelObject.ParentObjectType `
        -ObjectID $ModelObject.ParentObjectID `
        -ObjectName $ModelObject.ParentObjectName `
        -NumberRange "" `
        -Module $Module
}