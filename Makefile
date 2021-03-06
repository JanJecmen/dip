
all: MT_Jecmen_Jan_2017.pdf

cover: MT_cover.pdf

MT_Jecmen_Jan_2017.pdf: library.bib $(wildcard template/*) $(wildcard images/*) $(wildcard *.tex)
	@arara MT_Jecmen_Jan_2017

%.tex: .FORCE
	@echo -n "Running vlna for $@... "
	@vlna -m -n -l "$@" 2>/dev/null || :
	@echo "DONE"

verbose: .FORCE
	arara -v MT_Jecmen_Jan_2017

MT_cover.pdf: .FORCE
	@arara MT_cover

print: MT_Jecmen_Jan_2017.pdf
	@cpdf MT_Jecmen_Jan_2017.pdf 3-end -o MT_Jecmen_Jan_2017_print.pdf

clean:
	@git clean -Xdf

.PHONY: all clean

.FORCE:
