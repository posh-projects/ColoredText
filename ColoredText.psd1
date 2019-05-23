@{
    RootModule = 'ColoredText.psm1'
    ModuleVersion = '1.0.6'
    GUID = '18a523c6-24f4-4ac2-920a-1d2214631b59'
    Author = 'n8tb1t'
    CompanyName = 'n8tb1t'
    Copyright = '(c) 2019 n8tb1t, licensed under MIT License.'
    Description = 'The cutting edge API for text coloring and highlighting in powershell.'
    PowerShellVersion = '5.0'
    HelpInfoURI = 'https://github.com/n8tb1t/ColoredText/blob/master/README.md'

    FunctionsToExport = 'Format-Color'
    AliasesToExport = 'cprint'

    PrivateData = @{
        PSData = @{
            Tags = @('terminal', 'console', 'color', 'colored', 'highlighting', 'colorful', 'logging')
            LicenseUri = 'https://github.com/n8tb1t/ColoredText/blob/master/LICENSE'
            ProjectUri = 'https://github.com/n8tb1t/ColoredText'
            IconUri = 'https://raw.githubusercontent.com/n8tb1t/ColoredText/master/Docs/Logo/ct.png'
            ReleaseNotes = '
Check out the project site for more information:
https://github.com/n8tb1t/ColoredText'
        }
    }
}
