Function Touchpoints($tpfile)
{
    Add-Content $tpfile "Test Stuff"
}

if ($args.Length -eq 0)
{
    echo "Usage: Touchpoints <file>"
}
else
{
    Touchpoints($args[0])
}
