# <img src="/Docs/Logo/ct.png" alt="Logo" width="48" align="left"/> ColoredText

[![Powershellgallery Badge][psgallery-badge]][psgallery-status]

The cutting edge API for colored text formatting in PowerShell environment.

![example 02](/Docs/Screenshots/colored_text_example_02_1.png)

## Install

```powershell
PS> Install-Module ColoredText
```

Projects using `ColoredText`:
- [Parser](https://github.com/n8tb1t/Parser).
- [Debug](https://github.com/n8tb1t/Debug).
- [Logger](https://github.com/n8tb1t/Logger).


## Features:

 - Implemented with the latest powershell 5 features (Classes, Enums, etc.)
 - Fully adjustable.
 - Tab completion in ISE and Console.
 - Unlimited chaining.
 - Multithreading support with injectable host.
 - Lots of syntactic sugar.
 - Simplified syntax for rapid development.
 - Advanced API with strong typing, inheritance and extensibility.
 - Multiline support.

## Disclaimer:

In order to get the most out of color highlighted modules, and enjoy their full potential,<br>
it is highly recommended to use the [ConEmu console](https://conemu.github.io/) with the [Oceans16 theme](https://github.com/joonro/ConEmu-Color-Themes)!<br>
Also, check out the other numerous themes over there, maybe you'll find one you like even better!

## CLI - `cprint` (colored print)

**Smart Tab completion:**

![example 03](/Docs/Screenshots/colored_text_example_03_1.png)

**The Simplified syntax** is primarily intended for Console use, though can be easily used in the regular scripts  as well.

You can use each directive for a multiple times in a row to achieve the desired visual effect!<br>
The directives order doesn't matter, it could be:

```powershell
PS>"Hello World, Let's Rock".Split().Foreach{ cprint black on rainbow $_ lpad rpad print }
PS>-Split "Hello World, Let's Rock" | % { cprint persist white on next $_ print cr}
PS>cprint blue "Some text" on red print
PS>cprint "Some text" lpad rpad blue on red cr print
PS>cprint "Hello World" red print
PS>cprint "Hello World" black on blue print "More text" darkgreen print
```
Most of the directives are incremental.<br>
You can chain multiple text strings with lots of transformation in a single `cprint` sequence.

| Command   | Description |
| --------- | ----------- |
`cprint`    | Starts the chain.
`string`    | Some text string.
`lpad`      | Left padding.
`rpad`      |Right padding.
`nopad`     |Reset paddings.
`cr`        |Carriage return - ***Line break***
`print`     |Terminates the current chain, and outputs the text to console.
`reset`     |Zeroing out the sequence to default: "white on black".
`reverse`   | **IN DEVELOPMENT** Swaps background with foreground.
`persist`   |Retrieves the previous color settings.
`rainbow`   |Will use the next color from the previous print.
`next`      |Will use the next color from the current state.
`-PassThru` |Returns `ColoredText` object - useful for a mixed API usage.

**Notice that in console we don't need to escape the single words with quotes!**

```powershell
# Let's print some text
cprint white on darkgreen "hello" print

# Now if you want to print the next line with the same settings
# just use `persist`
cprint persist Hello print

# if you want to print each next word in a different color use `next`
cprint next "Hi there" print lpad next on rainbow "Let's highlight" print

# Try to enter this into console.
# The background would be different each time
cprint black on rainbow "Hello" print

# Should print "Hello World" on red background, but `reset` keyword
# will restore the last word colors to default white on black.
#
cprint black on red Hello print reset lpad World print
```
```powershell
$chain = cprint -PassThru black "Some text" on darkmagenta lpad lpad rpad rpad
$chain.paddingCharacter = [Char]0x003

$chain.print().cr()
```

![example 05](/Docs/Screenshots/colored_text_example_05.png)

## Escaping


- Double quote `"` enclosed in a **single quotes** could be escaped with `' "" '`
- Double quote `"` enclosed in a **double quotes** could be escaped with `" """" "`
- Double quote `"` enclosed in a **double quotes** could be escaped with grave-accent `"

![example 05](/Docs/Screenshots/colored_text_example_04_1.png)

## API

`ColoredText` Object Initialization!

```powershell
using module ColoredText

$title = {
    param ($text)

    [ColoredText]$text = (Get-Culture).textInfo.toTitleCase($text)

    [Void]$text.cr().black().on().darkyellow().lpad().rpad().print().cr().cr()
}

$title.invoke('the text would be title cased')

# The text string is optional you can add/change it at any moment in time!

# Initialization Option 1 Type Conversion
[ColoredText]$text = "Hello World"

# Initialization Option 2 Type Conversion
$text = [ColoredText]"Hello World"

# Initialization Option 3 Simple Assignment
$text = New-Object ColoredText "Hello World"

# Initialization Option 4 Hash table
$text = [ColoredText]@{__text="Hello World"}


# You don't have to assign variables
# the anonymous initialization is strongly recommended

([ColoredText]"Hello World")
(New-Object ColoredText "Hello World")
([ColoredText]@{__text="Hello World"})
([ColoredText]::New('Hello World'))

# Or just initialize empty object for the future text manipulations!

([ColoredText]@{})
(New-Object ColoredText)
([ColoredText]::New())
# etc.
```

After you have an object, initialized with any of the aforementioned methods.
This is where all the magic begins:

```powershell
[ColoredText]$text = "Hello World"

# Custom color
[Void]$text.color([ConsoleColor]::Red).print().cr()

# Color by number
[Void]$text.color(1).print().cr()

$text.lpad().rpad().black().on().darkblue().print().
text('More Text').black().on().darkyellow().print().reset().
text('Special @!#$ Characters').darkmagenta().print().
text('Line break - cr (carriage return)').darkred().nopad().print().cr()
```
![example 01](/Docs/Screenshots/colored_text_example_01.png)


[psgallery-badge]: https://img.shields.io/badge/PowerShell_Gallery-1.0.6-green.svg
[psgallery-status]: https://www.powershellgallery.com/packages/ColoredText/1.0.6
