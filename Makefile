
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
	stoke/bin/specgen_statistics --circuit_dir ../strata-data/circuits > bin/statistics-regs.json

bin/statistics-imm8.json:
	# cache statistics about instructions and formulas (e.g. formula size)
	stoke/bin/specgen_statistics --circuit_dir ../strata-data/circuits --two > bin/statistics-imm8.json

bin:
	mkdir bin

evaluate_precompute: bin bin/statistics-regs.json bin bin/statistics-imm8.json

graphs: evaluate_precompute bin/levels.csv
	scripts/graphs/levels.py
	scripts/graphs/size.py
	scripts/graphs/size2.py

bin/levels.csv:
	./strata evaluate

update_imm8_base:
	rm -rf resources/imm8_baseset
	cp -r ~/dev/circuits resources/imm8_baseset

.PHONY: build stoke clean debug update_imm8_base graphs
