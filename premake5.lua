local rocket = require("vendor/Rocket/buildRocket")
rocket.intialize("vendor/Rocket")

workspace "RocketTest"
    configurations { "Debug", "Release" }

project "app"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"

files {
    "include/**.h",
    "include/**.hpp",
    "include/**.cpp",
    "src/**.c",
    "src/**.cpp"
}

includedirs {rocket.Includes.all, "include"}

libdirs {"libs"}

links {rocket.Links.UserProject}

buildoptions {
    "-Wall", "-Wextra",
    rocket.cflags.UserProject
}

linkoptions {
    rocket.linkflags.UserProject
}

filter "system:Linux"
    linkoptions {
        "-Wl,-rpath='./libs/'"
    }

filter "configurations:Debug"
    prebuildcommands {
        rocket.prebuildCommandsDebug,
        string.format("[ -d libs ] || mkdir libs; cp \"%s\" libs", rocket.outputDebugLinux)
    }
    postbuildcommands {
        "[ -d bin/Debug/libs ] || mkdir -p bin/Debug/libs",
        "cp libs/libRocketGameEngine.so bin/Debug/libs/"
    }

filter "configurations:Release"
    prebuildcommands {
        rocket.prebuildCommandsRelease,
        string.format("[ -d libs ] || mkdir libs; cp \"%s\" libs", rocket.outputReleaseLinux)
    }
    postbuildcommands {
        "[ -d bin/Release/libs ] || mkdir -p bin/Release/libs",
        "cp libs/libRocketGameEngine.so bin/Release/libs/"
    }

filter ""
