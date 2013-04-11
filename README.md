# Presentation and Handout Generator

The idea of this little Shell / Python project is to allow me to write presentations in Markdown that get converted into a good looking HTML/CSS/JS presentation using [mdpress](https://github.com/egonSchiele/mdpress) and, using [Pandoc](http://johnmacfarlane.net/pandoc/README.html) that then gets turned into a beautiful PDF file as a handout.

Essentially, this is mostly a wrapper around three different components (mdpress, pandoc and pdflatex), and the programming challenge is minor. But besides listing the three components, a few things have to be addressed:

### Different starting options

+ Allowing the use of different styles via parameter (work, private etc)
+ Option to run through the manually changed generated files (modified md, tex)

### Pre-processing

+ Transform some metadata into a header for the handout and into the first slide
+ The transitions for mdpress should be added automatically
+ Some way to deal with longer lists - maybe dividing longer lists into two slides with identical headlines

### Post-processing

+ Special characters for other languages have to be changed in the LaTeX output of Pandoc
+ Change `\section{...}` to `\section*{...}`
+ At some later point: add FTP support to automatically put it on a website
