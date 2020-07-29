# Add nix-like touch command
function touch
{
    $file = $args[0]

    if($file -eq $null) 
    {
        throw "No filename supplied"
    }

    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        # UTF-16 LE
        # echo $null > $file

        # UTF-8 With BOM
        # $null | Out-File $file -Encoding "UTF8"
        
        # UTF-8 W/O BOM
        [IO.File]::WriteAllLines("$pwd\$file", "")
    }
}