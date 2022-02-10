# Get-Clip
A basic Get-ClipBoard function for pasting clipboard content into the console (or assign to variable, process in a foreach, Set-Content to a file, etc.).

It's compatible with PowerShell versions 2, 3 and 4 and up. In v5+ you have Get/Set-ClipBoard from the PowerShell team built in.

This Get-Clip function is for text only.

This is nice to put in your profile on earlier versions of Windows if you work on the computer a lot.

For other ways, see https://github.com/gangstanthony/PowerShell/blob/master/Get-Clipboard.ps1

If you need something for PSv1, copy this code block containing the first version I uploaded:

```powershell
function Get-Clip {
    param([Switch] $Raw)
    Add-Type -AssemblyName System.Windows.Forms
    $TextBox = New-Object -TypeName System.Windows.Forms.TextBox
    $TextBox.Multiline = $true
    $TextBox.Paste()
    if ($Raw) {
        $TextBox.Text
    }
    else {
        # Return array split on newlines.
        @($TextBox.Text -split '\r?\n')
    }
    $TextBox.Dispose()
}
```

Example use. You always get an array returned, unless you specify -Raw, sort of like Get-Content post-PSv2.

```
PS C:\> Get-Clip
Line1
Line2
Line3
Line4
Line5


PS C:\> (Get-Clip).Count
6

PS C:\> (Get-Clip | Where { $_ -match '\S' }).Count
5

PS C:\> Get-Clip | Where { $_ -match '\S' }
Line1
Line2
Line3
Line4
Line5

PS C:\>
```

With -Raw you get a single string back.

```powershell
> Get-Clip -Raw
Line1
Line2
Line3
Line4
Line5


> (Get-Clip -Raw).Count
1

> (Get-Clip -Raw).GetType().FullName
System.String

> (Get-Clip).Count
16

> (Get-Clip).GetType().FullName
System.Object[]
```

Below the behaviour of all the parameters is shown in examples. -RemoveEmpty, -RemoveWhitespaceOnly, -Quote and -QuoteChar. This is a bit more like an implementation I would want myself of a Get-ClipBoard cmdlet/function after some light consideration.


```powershell
PS C:\Dropbox\PowerShell> . .\Get-Clip.ps1

PS C:\Dropbox\PowerShell> Get-Clip
1
2
   
3
4
5

6
7


PS C:\Dropbox\PowerShell> (Get-Clip).GetType().FullName
System.Object[]

PS C:\Dropbox\PowerShell> Get-Clip -Raw
1
2
   
3
4
5

6
7


PS C:\Dropbox\PowerShell> (Get-Clip -Raw).GetType().FullName
System.String

PS C:\Dropbox\PowerShell> Get-Clip -Quote
"1"
"2"
"   "
"3"
"4"
"5"
""
"6"
"7"
""

PS C:\Dropbox\PowerShell> Get-Clip -RemoveEmpty
1
2
   
3
4
5
6
7

PS C:\Dropbox\PowerShell> Get-Clip -RemoveEmpty -Quote # -Quote is good for visual, manual inspection
"1"
"2"
"   "
"3"
"4"
"5"
"6"
"7"

PS C:\Dropbox\PowerShell> Get-Clip -RemoveWhitespaceOnly -Quote -QuoteChar "'"
'1'
'2'
'3'
'4'
'5'
'6'
'7'

PS C:\Dropbox\PowerShell> Get-Clip -RemoveWhitespaceOnly
1
2
3
4
5
6
7

PS C:\Dropbox\PowerShell> 
```
