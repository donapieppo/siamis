.PHONY: all

all: IS18_program.pdf

IS18_program.pdf: IS18_program.tex 
	pdflatex IS18_program.tex

clean:
	-rm -f *.aux
	-rm -f *.log
	-rm -f *.toc
	-rm -f *.bbl
	-rm -f *.blg
	-rm -f *.out
	-rm -f *.bcf
	-rm -f *.idx
	-rm -f *.ptc
	touch IS18_program.tex


