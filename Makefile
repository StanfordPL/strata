
all: stoke build


build:
	sbt compile

stoke:
	$(MAKE) -C stoke all

.PHONY: build stoke
