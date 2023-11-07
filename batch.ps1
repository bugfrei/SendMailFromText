param(
    $TextFile = "",
    $Subject,
    $Content = "",
    $Sender = "",
    $Attachment,
    $BatchSize = 10
)

if ($TextFile -eq "")
{
    $c = (Get-Clipboard)
}
$c = (Get-Content $TextFile -Raw)
$adrList = [regex]::Matches($c, "([@-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+)", [System.Text.RegularExpressions.RegexOptions]::Singleline).Value

$att = (Get-Item $Attachment).FullName

$senderScript = "set sender to `"$Sender`"`n"
if ($Sender -eq "")
{
    $senderScript = ""
}

$recs = @()
$r = ""
$names = ""
$anz = 0

foreach ($adr in $adrList)
{
    if ($anz -lt ($BatchSize) - 1)
    {
        $r += "            make new to recipient at end of to recipients with properties {address:`"$adr`"}`n"
        $names += "$adr`n"
        $anz++
    }
    else
    {
        $r += "            make new to recipient at end of to recipients with properties {address:`"$adr`"}`n"
        $names += "$adr`n"
        $anz++
        $recs += [PSCustomObject]@{
            Names  = $names
            Script = $r
        } 
        $r = ""
        $anz = 0
    }
}
if ($anz -gt 0)
{
    $recs += [PSCustomObject]@{
        Names  = $names
        Script = $r
    } 
}
Write-Host "Mail an:"
foreach ($r in $recs)
{
    $rr = ($r.Script | Join-String)
    $script = "tell application `"Mail`"
        tell (make new outgoing message)
            set subject to `"$Subject`"
            set content to `"$Content`"
            $senderScript
$rr
            try
                make new attachment with properties {file name:`"$att`"} at before the first paragraph
                set message_attachment to 0
            on error errmess -- oops
                set message_attachment to 1
            end try
            send
        end tell
    end tell
    "
    Set-Content -Path ~/mail.osa -Value $script -Force
    Write-Host "$($r.Names)"
    osascript ~/mail.osa
}

 