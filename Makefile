
all: MT_Jecmen_Jan_2017.pdf

MT_Jecmen_Jan_2017.pdf: library.bib MT_Jecmen_Jan_2017.tex template pdfs
	arara MT_Jecmen_Jan_2017

%.tex:
	vlna "$@" 2>/dev/null || :

clean:
	git clean -Xf

.PHONY: clean all
