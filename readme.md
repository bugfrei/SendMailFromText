# Send Mail from Mac with PowerShell and OSA Script

Two Scripts:

`all.ps1`: Sends Mails with one recipient per Mail

`batch.ps1`: Sends Mails with `n` recipient per Mail (-BatchSize Parameter = `n`) 

All Script has the same parameters, but `batch.ps1` has the `-BatchSize` Parameter to define the Count of recipient per Mail.

## Parameters

- `-TextFile`: File with E-Mail Adresses
- `-Subject`: Subject Line
- `-Content`: Mail-Content (Text); Optional
- `-Attachment`: File-Path to the Attachment (only one!)
- `-Sender`: Optional Parameter with the E-Mail Address of the sender
- `-BatchSize`: (only in batch.ps1), Count of recipient per Mail, default 10.

## Usage

`./batch.ps1 -TextFile ./mail -Subject SubjectLine -Content Hello -Attachment ./Test.pdf -Sender from@gmail.com -BatchSize 5`


`./all.ps1 -TextFile ./mail -Subject SubjectLine -Content Hello -Attachment ./Test.pdf -Sender from@gmail.com`
