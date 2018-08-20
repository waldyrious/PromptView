all: lint browser-specs test

lint:; eslint .
test:; atom -t test

.PHONY: lint test


SRC = prompt-view.js test/atom-specs.js test/utils.js

# Browserify Atom's specs for browser testing
browser-specs: test/browser-specs.js
test/browser-specs.js: $(SRC)
	printf 'window.atom = "object" === typeof atom;\n' > $@
	node_modules/.bin/browserify \
		--ignore chai \
		--ignore mocha \
		node_modules/atom-mocha/lib/extensions.js \
		test/atom-specs.js >> $@
	sed -i.bak -e '\
		s/require("mocha");$$/window.mocha;/; \
		s/require("chai");$$/window.chai;/; \
	' $@ && rm -f $@.bak