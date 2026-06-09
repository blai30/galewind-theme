<#
.SYNOPSIS
    PowerShell sample for syntax highlighting.
.DESCRIPTION
    Builds a small report of theme variants and their accent colors.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Rose', 'Sky')]
    [string]$Variant,

    [int]$Repeat = 1
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Accents = @{
    Rose = '#FB7185'
    Sky  = '#38BDF8'
}

function Get-AccentColor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Name
    )
    process {
        if ($Accents.ContainsKey($Name)) {
            return $Accents[$Name]
        }
        throw "Unknown variant: $Name"
    }
}

$accent = Get-AccentColor -Name $Variant
1..$Repeat | ForEach-Object {
    Write-Output "[$_] Galewind $Variant -> $accent"
}

$variants = $Accents.Keys |
    Where-Object { $_ -ne $Variant } |
    Sort-Object

Write-Verbose "Other variants: $($variants -join ', ')"
