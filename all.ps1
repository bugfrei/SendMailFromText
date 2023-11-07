param(
    $TextFile = "",
    $Subject,
    $Content = "",
    $Sender = "",
    $Attachment
)

if ($TextFile -eq "")
{
    $c = (Get-Clipboard)
}
else
{
    $c = (Get-Content $TextFile -Raw)
}
$adrList = [regex]::Matches($c, "([@-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+)", [System.Text.RegularExpressions.RegexOptions]::Singleline).Value

$att = (Get-Item $Attachment).FullName

$senderScript = "set sender to `"$Sender`"`n"
if ($Sender -eq "")
{
    $senderScript = ""
}

foreach ($adr in $adrList)
{
    $script = "tell application `"Mail`"
        tell (make new outgoing message)
            set subject to `"$Subject`"
            set content to `"$Content`"
            $senderScript
            make new to recipient at end of to recipients with properties {address:`"$adr`"}
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
    Write-Host "Mail an $adr"
    osascript ~/mail.osa
}

