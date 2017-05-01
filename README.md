# Get-Clip
A basic Get-ClipBoard function for pasting clipboard content into the console (or assign to variable, process in a foreach, Set-Content to a file, etc.).

It's compatible with PowerShell version 1, 2, 3 and 4. In v5+ you have Get/Set-ClipBoard from the PowerShell team built in.

For text only.

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
