#/bin/bash

set -e

[[ -f pyvenv.cfg ]] && python3 -m venv .
source bin/activate

(cd namespace-test-1 && python3 setup.py install --force >/dev/null)
# here we also suppress “package init file 'namespace_test/__init__.py' not found (or not a regular file)”
(cd namespace-test-2 && python3 setup.py install --force >/dev/null 2>/dev/null)

RV=$(python3 -c '
import namespace_test.a
import namespace_test.b
print(namespace_test.BASE, namespace_test.a.A, namespace_test.b.B)
')

if [[ "$RV" == "0 1 2" ]]; then
	echo 'Everything is accessible: namespace_test.{BASE,a.A,b.B}'
else
	echo "Output is “$RV” instead of “0 1 2”" >&2
	exit 1
fi
