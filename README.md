# Amicus Rhetoris

*A Presentation and Handout Generator*

The idea of this little Bash project is to allow me to write presentations in Markdown that get converted into a good looking HTML/CSS/JS presentation using [mdpress](https://github.com/egonSchiele/mdpress) and, using [Pandoc](http://johnmacfarlane.net/pandoc/README.html), into a .tex file that then gets turned into a beautiful PDF file as a handout.

## Issues

Currently the folder variables suck... The programme only works properly if called from its own folder. I hope to get around fixing that soon (or maybe someone with better Shell capabilities could help?)

## Features

Essentially, this is mostly a wrapper around three different components (mdpress, pandoc and pdflatex), and the programming challenge is minor. But besides listing the three components, a few things have to be addressed:

### Different starting options

+ Allowing the use of different styles via parameter (work, private etc)
+ Option to run through the manually changed generated files (modified md, tex) (still to do)

### Pre-processing

+ Transform metadata into a header for the handout and into the first slide
+ Take slide separator out of handout
+ The transitions for mdpress should be added automatically
+ Some way to deal with longer lists - maybe dividing longer lists into two slides with identical headlines (still to do)

### Post-processing

+ Special characters for other languages have to be changed in the LaTeX output of Pandoc
+ Change `\section{...}` to `\section*{...}`
+ At some later point: add FTP support to automatically put it on a website

## Requirements

The following applications have to be installed (the instructions are for Linux, as it is the only OS I am using):

+ mdpress: the easiest way is to use Ruby Gems: `sudo gem install mdpress`
+ Pandoc: Available through most package managers (see [the project website](http://johnmacfarlane.net/pandoc/installing.html)
+ PDFLaTeX: Available through the Texlive package in almost all distros

## Usage

`amr inputfile.md`

The document needs to have some formatting:

The document should contain the metadata for the presentation. After that, the presentation starts with normal markdown formatting.

    /title My little presentation
    /subtitle A short overview of something
    /author Tobias Kliem
    email Tobias.Kliem@example.com
    /institution My Corporation Inc
    /filename example01
    /style work

    # First slide
    
    + Information in markdown
    + More information

    ---

    # Second slide

Only the title is required. If no filename is specified the script will build it from the title. Style refers to the name of the .tex/.md file in the styles folder (which can be set up in the beginning of the script). If none is specified, default.tex will be used.

## Templates

There are two types of templates: for the tex file and for the presentation. If none are specified (or the specified one is not found), the application will take the default template. The folder that contains the templates needs to be specified in the script itself (right at the beginning).

The tex templates have to include the full preamble of a .tex document, including the `\begin{document}` and the custom title. Basically everything that needs to be in the text before the slides. The metadata from the input file can simply be included in double curly braces like this: `A presentation by \textbf{{{author}}} ({{email}})`. A tex template can include one (currently only one) picture - for example the logo of your institution. That needs to be included with the usual `\includegraphics{nameofthejpgfile}`, and needs to be in the styles folder with the templates.

The markdown template needs to include the first slide, again using the same placeholders for the metadata:

    # {{title}}
    # {{subtitle}}

    This is a presentation by {{author}} ({{email}})



