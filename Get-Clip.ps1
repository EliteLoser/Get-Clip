#requires -version 2
function Get-Clip {
    [CmdletBinding(DefaultParameterSetName="Cooked?")]
    param(
        [Parameter(ParameterSetName="Raw")][Switch] $Raw,
        [Parameter(ParameterSetName="Cooked?")][Switch] $RemoveEmpty,
        [Parameter(ParameterSetName="Cooked?")][Switch] $RemoveWhitespaceOnly,
        [Parameter(ParameterSetName="Cooked?")][Switch] $Quote,
        [Parameter(ParameterSetName="Cooked?")][String] $QuoteChar = '"')
    Add-Type -AssemblyName System.Windows.Forms
    $TextBox = New-Object -TypeName System.Windows.Forms.TextBox
    $TextBox.Multiline = $true
    $TextBox.Paste()
    if ($Raw) {
        $TextBox.Text
    }
    else {
        # Return array split on newlines and filter if switches were passed.
        if ($RemoveEmpty) {
            @($TextBox.Text -split '\r?\n') | Where-Object { $_ } | ForEach-Object { if ($Quote) { $QuoteChar + $_ + $QuoteChar } else { $_ } }
        }
        elseif ($RemoveWhitespaceOnly) {
            @($TextBox.Text -split '\r?\n') | Where-Object { $_ -match '\S' } | ForEach-Object { if ($Quote) { $QuoteChar + $_ + $QuoteChar } else { $_ }  }
        }
        else {
            @($TextBox.Text -split '\r?\n') | ForEach-Object { if ($Quote) { $QuoteChar + $_ + $QuoteChar } else { $_ } }
        }
    }
    $TextBox.Dispose()
}
