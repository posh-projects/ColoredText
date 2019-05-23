using module ColoredText


foreach ($color in [Enum]::GetNames([ConsoleColor]))
{
    cprint ('{0,-12}' -f $color) black on $color lpad print cr
}

[ColoredText]$text = "Hello World"

[Void]$text.cr().lpad().rpad().black().on().darkblue().print().
text('More Text').black().on().darkyellow().print().reset().
text('Special @!#$ Characters').darkmagenta().print().
text('Line break - cr (carriage return)').darkred().nopad().print().cr()
