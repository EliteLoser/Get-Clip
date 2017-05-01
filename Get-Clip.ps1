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
