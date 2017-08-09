# Get-Clip
A basic Get-ClipBoard function for pasting clipboard content into the console (or assign to variable, process in a foreach, Set-Content to a file, etc.).

It's compatible with PowerShell version 1, 2, 3 and 4. In v5+ you have Get/Set-ClipBoard from the PowerShell team built in.

For text only.

This is nice to put in your profile on earlier versions of Windows if you work on the computer a lot.

For other ways, see https://github.com/gangstanthony/PowerShell/blob/master/Get-Clipboard.ps1

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

PowerShell celebrities like Don Jones endorse "a tool does one thing", which is fine for many purposes, but honestly I think I currently disagree in a shitload of cases.

A lot of the time it just causes people to cumbersomely have to possibly research on the web, and in any case write often tedious, repetitive-task-like, "boring" code and also accidentally reinvent the wheel a billion times per month, and often poorly if it's a beginner. A handy parameter that takes care of some dirty work and saves you a Where-Object and ForEach-Object chain, or whatever, is useful, in my opinion.

If the toolset is complete, Don's mindset works, but it is far from it, and will remain this way for my lifetime, possibly eternally (have to give that some more thought, and the answer is likely hidden behind infinity or a paradox, depending on math/human language). 

In isolated, smaller (small can be large - heh) systems the design with "a tool does one thing" can be implemented as Don wishes, and I agree it's probably a good tactic in projects. There is always a balance, though. It is a valid argument Don makes, but I think it is disproportionately portrayed in the free PowerShell book text I read parts of some months ago (and have not re-read now, pardon any  potential misconception). When someone googles a tool to do something, if it also has bells and whistles that are simple to understand and use, I do not see that as a bad thing. Again I mention the balance - don't overdo it.

Just my nickle on that at this time of writing. Letting it out on GitHub in the Get-Clip doc for lack of a better place. lol

So that thinking is why I have now added these fabulous, horrific parameters for the new Get-Clip I uploaded. It's simply sometimes less typing, meaning less work then and there. I don't mean to "start a fight", by the way. :)

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
