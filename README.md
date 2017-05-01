# Get-Clip
A basic Get-ClipBoard function (paste clipboard into console) that's compatible with PowerShell version 2.

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

Example use. You always get an array returned, unless you specify -Raw, sort of like Get-Content post-PSv3.

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
> (Get-Clip -Raw).Count
1

> (Get-Clip -Raw).GetType().FullName
System.String

> (Get-Clip).Count
16

> (Get-Clip).GetType().FullName
System.Object[]
```
