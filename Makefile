
all: stoke build

build:
	sbt compile

debug: build
	cd stoke && ./configure.sh
	$(MAKE) -C stoke debug

stoke:
	cd stoke && ./configure.sh
	$(MAKE) -C stoke all

clean:
	sbt clean
	cd stoke && ./configure.sh
	$(MAKE) -C stoke clean

bin/statistics-regs.json:
	# cache statistics about instructions and formulas (e.g. formula size)
	stoke/bin/specgen_statistics --circuit_dir ../strata-data/circuits > in/statistics-regs.json

bin:
	mkdir bin

evaluate: bin bin/statistics-regs.json
	echo "yes"

update_imm8_base:
	rm -rf resources/imm8_baseset
	cp -r ~/dev/circuits resources/imm8_baseset

.PHONY: build stoke clean debug update_imm8_base
