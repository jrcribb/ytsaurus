# This file was generated by the YaTool build system (https://github.com/yandex/yatool),
# from a source YaTool build configuration provided in ya.make files.
#
# If the repository supports both CMake and ya build configurations, please modify both of them.
#
# If only CMake build configuration is supported then modify only CMake files and note that only
# simple modifications are allowed like adding source-files to targets or adding simple properties
# like target_include_directories. These modifications will be ported to original ya.make files
# by maintainers. Any complex modifications which can't be easily ported back to the ya build
# system may be rejected.
#
# Please refer to the build instructions in the repository for more information about manual
# changes in this file.

add_subdirectory(batch_request)
add_subdirectory(dyntable_get_insert)
add_subdirectory(job_statistics)
add_subdirectory(join_reduce_tnode)
add_subdirectory(map_tnode_with_file)
add_subdirectory(mapreduce_lambda)
add_subdirectory(mapreduce_protobuf)
add_subdirectory(multiple_input_multiple_output_reduce_protobuf)
add_subdirectory(multiple_input_multiple_output_reduce_tnode)
add_subdirectory(multiple_input_reduce_tnode)
add_subdirectory(operation_tracker)
add_subdirectory(prepare_operation)
add_subdirectory(profile_cpu)
add_subdirectory(profile_memory)
add_subdirectory(protobuf_complex_types)
add_subdirectory(pass_table_as_file)
add_subdirectory(simple_map_lambda)
add_subdirectory(simple_map_protobuf)
add_subdirectory(simple_map_tnode)
add_subdirectory(simple_reduce_tnode)
add_subdirectory(stateful_map_tnode)
add_subdirectory(table_read_write_tnode)
