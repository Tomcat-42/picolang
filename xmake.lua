-- Big ol' c99
set_languages("c99")
-- add_rules("mode.debug", "mode.release")

-- add_includedirs("/usr/include", "/usr/local/include", "include")

-- like god intended
-- set_warnings("all", "error")
-- set_optimize("fastest")
-- add_cxflags("-std=c99", { force = true })

-- add libraries
local project_libs = {}
local test_libs = {}
local bench_libs = {}

-- static libraries
target("picolang")
  set_kind("static")
  add_files("src/**/*.c")
  add_packages(table.unpack(project_libs))
  set_installdir("/usr/local")

-- main project executable
target("picoc")
  set_kind("binary")
  add_rules("lex", "yacc")
  add_files("src/*.c", "src/picolang/*.l", "src/picolang/*.y")
  add_packages(table.unpack(project_libs))
  add_deps("picolang")
  set_installdir("/usr/local")

-- test suites
-- target("picolang_test")
-- set_kind("binary")
-- add_files("test/**/*.cpp", "test/main.cpp")
-- add_packages(table.unpack(test_libs))
-- add_deps("libpicolang")
-- set_installdir("/usr/local")

-- benchmarks
-- target("picolang_bench")
-- set_kind("binary")
-- add_files("bench/**/*.cpp", "bench/main.cpp")
-- add_packages(table.unpack(bench_libs))
-- add_deps("libpicolang")
-- set_installdir("/usr/local")
