# -*- makefile -*-


# Lleida/document/root.tex -> Main Content File
# Lleida/document/images/ -> images

# Copyright (C) 2007  Carles Mateu <carlesm@carlesm.com>
# Bassed on work by:
# Copyright (C) 2005  Nick Urbanik <nicku@nicku.org>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#LATEX = latex --interaction=batchmode
#PDFLATEX = pdflatex --interaction=batchmode
LATEX = latex
PDFLATEX = pdflatex
#DOCUMENT_BASE = DFKI
DOCUMENT_BASE = kaestchenpapier


all: \
	$(DOCUMENT_BASE).pdf \
#	$(DOCUMENT_BASE)-beamer.pdf \
#	$(DOCUMENT_BASE)-handout.ps
#	$(DOCUMENT_BASE)-trans-dual.pdf \


%.pdf: %.tex
	@echo
	@echo \*
	@echo \* Compiling $<
	@echo \*
	$(PDFLATEX) $<
	@echo $(subst .tex,.log,$<) 
	@while ( grep "Rerun to get cross-references"                   \
			$(subst .tex,.log,$<) >/dev/null ); do          \
		echo '** Re-running LaTeX **';                          \
		$(PDFLATEX) $<;                                            \
	done
	@while ( grep "No file " $(subst .tex,.log,$<) >/dev/null ); do          \
		echo '** Re-running LaTeX **';                          \
		$(PDFLATEX) $<;                                            \
	done
#	mv Lleida-trans.pdf DFKI-presentation_hhanff.pdf	

tidy:
	rm -f *.log *.ps *.toc *.aux *.eepic *.bak *.lg *.out *.idx *~ \
	*.nav *.snm *.out *.vrb

clean:  tidy
	rm -f *.dvi *-presentation_hhanff.pdf *-trans-dual.pdf *-handout.pdf 

# Stop overzealous deletion of intermediate files
.PRECIOUS: %.eps $(pdffigs) %.slides-beamer.tex

.PHONY: all clean tidy list lpr print message

