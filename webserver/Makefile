all:pythoncheck

pythoncheck:
	@for f in `find . -iname "*.py"`; do\
		pylint -E $$f;\
	done
