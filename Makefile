# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

build: build-populate
	mkdir -p bin
	#nitserial src/app.nit -o src/app_serial.nit
	nitc src/app.nit -m src/app_serial.nit -o bin/app

debug: build-populate
	mkdir -p bin
	nitc src/app_debug.nit -m src/app_serial.nit -o bin/app

build-populate: bin/db_loader

bin/db_loader:
	mkdir -p bin
	nitserial src/db_loader.nit -o src/db_loader_serial.nit
	nitc src/db_loader.nit -m src/db_loader_serial.nit -o bin/db_loader

populate: bin/db_loader
	# There are levels to this... try: `make populate level=2`
	bin/db_loader $(level)

run:
	bin/app --auth shib

run-gh:
	bin/app --auth github

check:
	nitunit .
	$(MAKE) -C tests/

clean:
	rm -rf bin
	rm -rf src/app_serial.nit
	rm -rf src/db_loader_serial.nit

.PHONY: pep8term
pep8term:
	test -d pep8term || git clone https://github.com/privat/pep8term.git
	cd pep8term && git pull
	${MAKE} -C pep8term
