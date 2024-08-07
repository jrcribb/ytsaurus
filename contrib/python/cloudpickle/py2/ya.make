# Generated by devtools/yamaker (pypi).

PY2_LIBRARY()

VERSION(1.3.0)

LICENSE(BSD-3-Clause)

NO_LINT()

NO_CHECK_IMPORTS(
    cloudpickle.cloudpickle_fast
)

PY_SRCS(
    TOP_LEVEL
    cloudpickle/__init__.py
    cloudpickle/cloudpickle.py
    cloudpickle/cloudpickle_fast.py
)

RESOURCE_FILES(
    PREFIX contrib/python/cloudpickle/py2/
    .dist-info/METADATA
    .dist-info/top_level.txt
)

END()
