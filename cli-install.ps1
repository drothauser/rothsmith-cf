function Install-CLI
{
    $NCCT_Software_Bucket = "ncct-software";
    $AWSCLI_Installer_File = "AWSCLI64PY3.msi"
    $CIS_Directory = "c:\cis";
    $SetRegion ="us-gov-west-1";
    $SetLocation_AwsCLI = "$CIS_Directory\EC2-Software\AwsCLI";

    Set-Location $SetLocation_AwsCLI

    read-s3object `
        -BucketName $NCCT_Software_Bucket `
        -Key $AWSCLI_Installer_File `
        -File $SetLocation_AwsCLI\$AWSCLI_Installer_File `
        -Region $SetRegion

    start-process $SetLocation_AwsCLI\$AWSCLI_Installer_File /qn -Wait
    setx PATH "$env:Path;C:\PROGRA~1\Amazon\AWSCLI\bin" -m
    [Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION", $SetRegion, "Machine")
    
}

Install-CLI
