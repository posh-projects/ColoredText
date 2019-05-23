#requires -Version 5.0

using namespace System.Management.Automation.Host
using namespace System.Management.Automation
using namespace System.Collections.Generic

using module .\Src\PublicMethods.psm1


class ColoredText
{
    [PSHost]$host = $global:host
    
    [String]$__text
    
    static [ConsoleColor]$DEFAULT_BACKGROUND = [ConsoleColor]::Black
    static [ConsoleColor]$DEFAULT_FOREGROUND = [ConsoleColor]::White
    static [ConsoleColor]$LAST_BACKGROUND = [ColoredText]::DEFAULT_BACKGROUND
    static [ConsoleColor]$LAST_FOREGROUND = [ColoredText]::DEFAULT_FOREGROUND
    
    [ConsoleColor]$background = [ColoredText]::DEFAULT_BACKGROUND
    [ConsoleColor]$foreground = [ColoredText]::DEFAULT_FOREGROUND
    
    [Boolean]$backgroundMode = $false
    [Boolean]$persistent = $false
    
    [Int]$leftPadding = 0
    [Int]$rightPadding = 0
    [Char]$paddingCharacter = 0x020
    
    [ColoredText]newInstance() { return New-Object ColoredText }
    
    ColoredText() { }
    
    ColoredText([String]$text) { $this.__text = $text }
    
    hidden [Void]setBackground([ConsoleColor]$color)
    {
        [ColoredText]::LAST_BACKGROUND = $this.background = $color
    }
    
    hidden [Void]setForeground([ConsoleColor]$color)
    {
        [ColoredText]::LAST_FOREGROUND = $this.foreground = $color
    }
    
    hidden [String]prepareText()
    {
        return '{0}{1}{2}' -f
        "".PadLeft($this.leftPadding, $this.paddingCharacter),
        $this.__text,
        "".PadRight($this.rightPadding, $this.paddingCharacter)
    }
    
    [ColoredText]text([String]$text)
    {
        $this.__text = $text
        return $this
    }
    
    [ColoredText]color([ConsoleColor]$color)
    {
        if ($this.backgroundMode)
        {
            $this.setBackground($color)
            $this.backgroundMode = $false
        }
        else
        {
            $this.setForeground($color)
        }
        
        return $this
    }
    
    [ColoredText]on()
    {
        $this.backgroundMode = $true
        return $this
    }
    
    [ColoredText]print()
    {
        $this.host.UI.Write($this.foreground, $this.background, $this.prepareText())
        return $this
    }
    
    [ColoredText]cr()
    {
        $this.host.UI.WriteLine()
        return $this
    }
    
    
    
    [ColoredText]reset()
    {
        $this.setBackground([ColoredText]::DEFAULT_BACKGROUND)
        $this.setForeground([ColoredText]::DEFAULT_FOREGROUND)
        return $this
    }
    
    [ColoredText]nopad()
    {
        $this.leftPadding = $this.rightPadding = 0
        return $this
    }
    
    [ColoredText]lpad()
    {
        $this.leftPadding++
        return $this
    }
    
    [ColoredText]rpad()
    {
        $this.rightPadding++
        return $this
    }
    
    [ColoredText]black() { return $this.color([ConsoleColor]::black) }
    [ColoredText]blue() { return $this.color([ConsoleColor]::blue) }
    [ColoredText]cyan() { return $this.color([ConsoleColor]::cyan) }
    [ColoredText]gray() { return $this.color([ConsoleColor]::gray) }
    [ColoredText]green() { return $this.color([ConsoleColor]::green) }
    [ColoredText]magenta() { return $this.color([ConsoleColor]::magenta) }
    [ColoredText]red() { return $this.color([ConsoleColor]::red) }
    [ColoredText]white() { return $this.color([ConsoleColor]::white) }
    [ColoredText]yellow() { return $this.color([ConsoleColor]::yellow) }
    [ColoredText]darkblue() { return $this.color([ConsoleColor]::darkblue) }
    [ColoredText]darkcyan() { return $this.color([ConsoleColor]::darkcyan) }
    [ColoredText]darkgray() { return $this.color([ConsoleColor]::darkgray) }
    [ColoredText]darkgreen() { return $this.color([ConsoleColor]::darkgreen) }
    [ColoredText]darkmagenta() { return $this.color([ConsoleColor]::darkmagenta) }
    [ColoredText]darkred() { return $this.color([ConsoleColor]::darkred) }
    [ColoredText]darkyellow() { return $this.color([ConsoleColor]::darkyellow) }
    
    [ColoredText]persist()
    {
        
        $this.setBackground([ColoredText]::LAST_BACKGROUND)
        $this.setForeground([ColoredText]::LAST_FOREGROUND)
        
        $this.persistent = $true
        return $this
    }
    
    [ColoredText]next()
    {
        [Int]$index = $true
        
        [Boolean]$bgMode = $this.backgroundMode
        
        [ConsoleColor]$bg, [ConsoleColor]$fg = $this.background, $this.foreground
        
        if ($this.persistent)
        {
            [int]$bg = ([ColoredText]::LAST_BACKGROUND)
            [int]$fg = ([ColoredText]::LAST_FOREGROUND)
        }
        
        [int]$index += switch ($bgMode) { True { $bg } False { $fg } }
        
        $isLastColor = { $index -eq [Enum]::GetNames([ConsoleColor]).Count }
        
        $color = switch (& $isLastColor)
        {
            True { [ConsoleColor]::black }
            False { [Enum]::GetNames([ConsoleColor])[$index] }
        }
        
        # Set the current color.
        $this.color($color)
        
        # The previous call resets the "backgroundMode"
        # so we restore it, in case there is a color collision
        # and we'll need to skip one more color.
        $this.backgroundMode = $bgMode
        
        # Needs more tests to ensure there is no infinite loop possibility!
        if ($this.foreground -eq $this.background) { $this.next() }
        
        return $this
    }
    
    [ColoredText]rainbow()
    {
        $this.persist()
        return $this.next()
    }
}


function Format-Color
{
    param (
    [switch]$Debug,
    [switch]$PassThru
    )
    
    process
    {
        [List[String]]$commands = $args
        
        [ColoredText]$text = [String]::Empty
        
        if ([Boolean]$_) { $commands.Insert(0, $_) }
        
        $isNotExposed = { [Enum]::GetNames([PublicMethods]) -notcontains $command }
        
        foreach ($command in $commands)
        {
            if (& $isNotExposed)
            {
                [Void]$text.text($command)
                continue
            }
            
            Invoke-Expression('$text.{0}()' -f $command) > $null
            
            if ($debug) { Write-Host $command }
        }
        
        if ($passThru) { return $text }
    }
}

New-Alias -Name cprint -Value Format-Color

Register-ArgumentCompleter -CommandName cprint -ScriptBlock {
    param (
    $wordToComplete,
    $commandAst,
    $cursorPosition
    )
    
    $methods = [Enum]::GetValues([PublicMethods])
    $matches = $methods | Where-Object { $_ -like "*$wordToComplete*" }
    
    $matches = switch ([Boolean]$matches.Count) { True { $matches } False { $methods } }
    
    $matches | Sort-Object | ForEach-Object { [CompletionResult]::new($_) }
}