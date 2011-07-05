BOOK_NAME=fontbook
FTP_TOPDIR=fonts
FTP_PDFDIR=$(FTP_TOPDIR)
TARGETS=$(BOOK_NAME)
TEXINPUTS=

# Include crocodoc conf
include ~/.crocodoc.conf

all: pdf

pdf: $(addsuffix .pdf,$(TARGETS))

%.pdf: %.tex
	TEXINPUTS=$(TEXINPUTS) xelatex -shell-escape -interaction=batchmode $*
	TEXINPUTS=$(TEXINPUTS) xelatex -shell-escape -interaction=batchmode $*

upload:
	-ncftpput -f ~/.ncftp/cc.cfg $(FTP_PDFDIR)/ *.pdf

%.json: %.pdf
ifeq ($(strip $(TOKEN)),)
	$(error No crocodoc token found in ~/.crocodoc.conf)
endif
	curl -F "file=@$<" -F "token=$(TOKEN)" -F "title=$* $(TODAY)" \
	   https://crocodoc.com/api/v1/document/upload > $@

crocupload: $(BOOK_NAME).json

clean:
	rm -f *.ps *.aux *.log *.out *.lol
	rm -f *.idx *.ind *.ilg *.toc *.dvi
	rm -f *.json
	# Remove only target pdf
	rm -f $(addsuffix *.pdf,$(TARGETS))


