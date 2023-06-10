set_project("picoc")
set_version("0.1.0")
set_description("A WIP tiny lang")
set_license("MIT")
set_languages("c99")
add_includedirs("/usr/include", "/usr/local/include", "include")
add_rules("mode.debug", "mode.release", "mode.releasedbg", "plugin.compile_commands.autoupdate")
set_defaultmode("release")
set_xmakever("2.7.9")
set_optimize("fastest")
add_cxflags("-std=c99", { force = true })

-- add libraries
local project_libs = {}

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
set_targetdir("./")
