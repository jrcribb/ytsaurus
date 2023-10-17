# Generated by devtools/yamaker.

LIBRARY()

LICENSE(Apache-2.0 WITH LLVM-exception)

LICENSE_TEXTS(.yandex_meta/licenses.list.txt)

PEERDIR(
    contrib/libs/llvm16
    contrib/libs/llvm16/include
    contrib/libs/llvm16/lib/Analysis
    contrib/libs/llvm16/lib/CodeGen
    contrib/libs/llvm16/lib/CodeGen/GlobalISel
    contrib/libs/llvm16/lib/ExecutionEngine
    contrib/libs/llvm16/lib/ExecutionEngine/MCJIT
    contrib/libs/llvm16/lib/ExecutionEngine/RuntimeDyld
    contrib/libs/llvm16/lib/IR
    contrib/libs/llvm16/lib/MC
    contrib/libs/llvm16/lib/MC/MCDisassembler
    contrib/libs/llvm16/lib/MC/MCParser
    contrib/libs/llvm16/lib/MCA
    contrib/libs/llvm16/lib/Object
    contrib/libs/llvm16/lib/ObjectYAML
    contrib/libs/llvm16/lib/Support
    contrib/libs/llvm16/lib/TargetParser
)

ADDINCL(
    contrib/libs/llvm16/tools/llvm-exegesis/lib
)

NO_COMPILER_WARNINGS()

NO_UTIL()

SRCS(
    Analysis.cpp
    Assembler.cpp
    BenchmarkResult.cpp
    BenchmarkRunner.cpp
    Clustering.cpp
    CodeTemplate.cpp
    Error.cpp
    LatencyBenchmarkRunner.cpp
    LlvmState.cpp
    MCInstrDescView.cpp
    ParallelSnippetGenerator.cpp
    PerfHelper.cpp
    RegisterAliasing.cpp
    RegisterValue.cpp
    SchedClassResolution.cpp
    SerialSnippetGenerator.cpp
    SnippetFile.cpp
    SnippetGenerator.cpp
    SnippetRepetitor.cpp
    Target.cpp
    UopsBenchmarkRunner.cpp
)

END()