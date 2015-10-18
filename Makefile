
all: stoke build

build:
	sbt compile

stoke:
	$(MAKE) -C stoke all

clean:
	sbt clean
	$(MAKE) -C stoke clean

.PHONY: build stoke clean
