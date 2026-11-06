PM = uv
VENV = .venv
PY = python3

all: install run

$(VENV):
	$(PY) -m venv $(VENV)

install: $(VENV)
	pip install $(PM)
	$(PM) sync

run: $(VENV)
	. ./$(VENV)/bin/activate
	$(PM) run $(PY) -m src

clean:
	rm -rf $(VENV)
	rm -rf **/*/__pycache__/
	rm -rf .*_cache
	rm -rf dist/

lint: $(VENV)
	. ./$(VENV)/bin/activate
	$(PM) run mypy . \
    	--warn-return-any \
    	--warn-unused-ignores \
    	--ignore-missing-imports \
    	--disallow-untyped-defs \
    	--check-untyped-defs
	$(PM) run flake8 .
	$(PM) run ruff check

lint-strict: $(VENV)
	. ./$(VENV)/bin/activate
	$(PM) run mypy --strict .
	$(PM) run flake8 .
	$(PM) run ruff check

debug: $(VENV)
	. ./$(VENV)/bin/activate
	$(PM) run $(PY) -m pdb

.PHONY: install all run clean debug lint lint-strict
