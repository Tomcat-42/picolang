-- Big ol' c99
set_languages("c99")
add_rules("mode.debug", "mode.release")

add_includedirs("/usr/include", "/usr/local/include", "include")

-- like god intended
set_warnings("all", "error")
set_optimize("fastest")
add_cxflags("-std=c99", { force = true })

-- add libraries
local project_libs = {}
local test_libs = {}
local bench_libs = {}

-- static libraries
target("libpicolang")
set_kind("static")
add_files("src/**/*.cpp")
add_packages(table.unpack(project_libs))
set_installdir("/usr/local")
-- set_targetdir("./picolang")
set_prefixname("")

-- main project executable
target("picolang")
set_kind("binary")
add_files("src/main.cpp")
add_packages(table.unpack(project_libs))
add_deps("libpicolang")
set_installdir("/usr/local")
-- set_targetdir("./picolang")

-- test suites
-- target("picolang_test")
-- set_kind("binary")
-- add_files("test/**/*.cpp", "test/main.cpp")
-- add_packages(table.unpack(test_libs))
-- add_deps("libpicolang")
-- set_installdir("/usr/local")
-- set_targetdir("./picolang")

-- benchmarks
-- target("picolang_bench")
-- set_kind("binary")
-- add_files("bench/**/*.cpp", "bench/main.cpp")
-- add_packages(table.unpack(bench_libs))
-- add_deps("libpicolang")
-- set_installdir("/usr/local")
-- set_targetdir("./picolang")
