
function Install-CLI
{

    $NCCT_Software_Bucket = "ncct-software";
    $AWSCLI_Key = "AWSCLI64PY3.msi"
    $CIS_Directory = "c:\cis";
    $SetRegion ="us-gov-west-1";

    read-s3object `
        -BucketName $NCCT_Software_Bucket `
        -Key $AWSCLI_Key `
        -File $CIS_Directory\$AWSCLI_Key `
        -Region $SetRegion

    start-process $CIS_Directory\$AWSCLI_Key /qn -Wait
    setx PATH "$env:Path;C:\PROGRA~1\Amazon\AWSCLI\bin"
    setx AWS_DEFAULT_REGION $SetRegion
    
}

Install-CLI