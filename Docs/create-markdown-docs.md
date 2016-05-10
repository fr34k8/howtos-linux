# Create markdown docs

## debian
    apt-get install pandoc

## examples

* [Yoga 3 Pro Doku auf github](https://raw.githubusercontent.com/longsleep/yoga3pro-linux/master/Yoga%203%20Linux%20HOWTO.md)
* [Pandoc: markdown Syntax](http://pandoc.org/README.html#pandocs-markdown)

## multiple files

    01_preface.md
    02_introduction.md
    03_why_markdown_is_useful.md
    04_limitations_of_markdown.md
    05_conclusions.md
    06_links.md

    pandoc -s -S --toc *.md -t html5 -o file.html

## from html to atx style markdown

    pandoc -s -S --atx-headers file.html -o file.md

# Links
* [stackoverflow: markdown](http://stackoverflow.com/questions/4779582/markdown-and-including-multiple-files)
* [github: markdown multiple file example](https://github.com/akmassey/markdown-multiple-files-example)
* [YAML Blocks](http://pandoc.org/README.html#metadata-blocks)
* [Mobile-Friendly Test](https://www.google.com/webmasters/tools/mobile-friendly/)
