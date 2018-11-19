### Set Variable ###

$CIS_Directory = "c:\cis";
$Software_Directory = "c:\cis\EC2-Software";
$S3BucketName = "cisgov-ec2-software";
$S3KeyPrefixDirectory ="EC2-Software";
$SetRegion ="us-gov-west-1";
$SetLocation_Mcafee ="c:\cis\EC2-Software\McAfee";
$SetLocation_Splunk ="c:\cis\EC2-Software\Splunk";
$SetLocation_Nexpose = "C:\cis\EC2-Software\Nexpose\nexpose_agent_windows";
$SetLocation_wsus = "c:\cis\EC2-Software\WSUS";

function Invoke-Functions
{
    Copy-File
    Install-Mcafee
    Install-SplunkUF
    Install-Nexpose
    set-Registry
    clean-up
}

function Copy-File
{
    mkdir $CIS_Directory
    #set-location $CIS_Directory 

    read-s3object `
        -BucketName $S3BucketName `
        -KeyPrefix $S3KeyPrefixDirectory `
        -Folder $CIS_Directory\$S3KeyPrefixDirectory `
        -Region $SetRegion
}

function Install-Mcafee
{
    set-location $SetLocation_Mcafee
    start-process "FramePkg_WIN10.exe" -ArgumentList "/Install=Agent /Silent" -wait
}


function Install-SplunkUF
{
    set-location $SetLocation_Splunk
    start-process -filepath "msiexec.exe" -ArgumentList "-i splunkforwarder-6.6.3-e21ee54bc796-x64-release.msi DEPLOYMENT_SERVER=10.205.17.10:8089 AGREETOLICENSE=yes /quiet /L*v splunk_logfile.txt " -Wait 
}

function Install-Nexpose
{
Set-Location
Set-Location
Set-Locationuiet /qn " -Wait
Set-Location
}

function set-Registry
{
  set-location $SetLocation_Wsus
  start-process -filepath "regedit.exe" -ArgumentList "/s wsus.reg" -Wait
   # New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -value http://10.205.17.12:8530
   # New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -value http://10.205.17.12:8530
   # Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -value 00000000
   # Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -value 00000001

}

function clean-up
{
     Remove-Item $Software_Directory -Recurse -Force
}


Invoke-Functions
