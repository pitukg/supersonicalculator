buildandrun:
	@make build && make run

build:
	@echo "Building..."
	@dune build
	@echo "        ...success"

run:
	@echo "Executing calculator:\n"
	@./_build/default/supersonicalculator.exe --runtests
	@echo ""

runv:
	@echo "Executing calculator (value only mode):\n"
	@./_build/default/supersonicalculator.exe -v --runtests

