PY3_PROGRAM(spyt_cli)

PEERDIR(
    yt/spark/spark-over-yt/data-source/src/main/python
)

PY_SRCS(
    MAIN spyt_cli.py
)

RESOURCE_FILES(
    spark-discovery-yt
    spark-launch-yt
    spark-manage-yt
)

END()