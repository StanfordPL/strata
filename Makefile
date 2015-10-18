
all: stoke build

build:
	sbt compile

debug: build
	$(MAKE) -C stoke debug

stoke:
	$(MAKE) -C stoke all

clean:
	sbt clean
	$(MAKE) -C stoke clean

.PHONY: build stoke clean debug
