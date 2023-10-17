# Generated by devtools/yamaker.

LIBRARY()

LICENSE(
    Apache-2.0 AND
    CC0-1.0 AND
    MIT AND
    Public-Domain
)

LICENSE_TEXTS(.yandex_meta/licenses.list.txt)

ADDINCL(
    GLOBAL contrib/clickhouse/base/widechar_width
)

NO_COMPILER_WARNINGS()

NO_UTIL()

IF (OS_DARWIN)
    CFLAGS(
        GLOBAL -DOS_DARWIN
    )
ELSEIF (OS_LINUX)
    CFLAGS(
        GLOBAL -DOS_LINUX
    )
ENDIF()

CFLAGS(
    -DHAS_RESERVED_IDENTIFIER
    -D_LIBCPP_ENABLE_THREAD_SAFETY_ANNOTATIONS
    -D__GCC_HAVE_DWARF2_CFI_ASM=1
)

SRCS(
    widechar_width.cpp
)

END()