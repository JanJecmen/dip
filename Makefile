
all: MT_Jecmen_Jan_2017.pdf

MT_Jecmen_Jan_2017.pdf: library.bib $(wildcard template/*) $(wildcard images/*) $(wildcard *.tex)
	@arara MT_Jecmen_Jan_2017

%.tex: .FORCE
	@echo -n "Running vlna for $@... "
	@vlna -m -n -l "$@" 2>/dev/null || :
	@echo "DONE"

clean:
	@git clean -Xdf

.PHONY: all clean

.FORCE:
