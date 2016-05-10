# Create latex docs

## debian
	apt-get install \ 
	  texlive texlive-latex-extra texlive-lang-german \ 
	  tex4ht gnuhtml2latex 
 
## Compile Tex

	latex datei.tex 
 
## Tex 2 PDF

	pdflatex datei.tex 
 
## Tex 2 HTML

	htlatex datei.tex xhtml 
 
## HTML 2 Tex

	gnuhtml2latex datei.html 
