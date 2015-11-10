
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

update_imm8_base:
	rm -rf resources/imm8_baseset
	cp -r ~/dev/circuits resources/imm8_baseset

.PHONY: build stoke clean debug update_imm8_base
