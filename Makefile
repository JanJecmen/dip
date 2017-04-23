
all: MT_Jecmen_Jan_2017.pdf

MT_Jecmen_Jan_2017.pdf: library.bib MT_Jecmen_Jan_2017.tex $(wildcard template/*) $(wildcard pdfs/*) $(wildcard *.tex)
	arara MT_Jecmen_Jan_2017

%.tex:
	vlna "$@" 2>/dev/null || :

clean:
	git clean -Xdf

.PHONY: clean all
