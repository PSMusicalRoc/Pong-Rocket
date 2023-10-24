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
    "-Wall", "-Wextra"
}

filter "system:Linux"
    linkoptions {
        "-Wl,-z,origin,-rpath='./libs/'"
    }

filter "configurations:Debug"
    prebuildcommands {
        rocket.prebuildCommandsDebug,
        string.format("mkdir libs; cp \"%s\" libs", rocket.outputDebugLinux)
    }
    postbuildcommands {
        "cp libs/libRocketGameEngine.so bin/Debug/libs/"
    }

filter "configurations:Release"
    prebuildcommands {
        rocket.prebuildCommandsRelease,
        string.format("mkdir libs; cp \"%s\" libs", rocket.outputReleaseLinux)
    }
    postbuildcommands {
        "cp libs/libRocketGameEngine.so bin/Release/libs/"
    }

filter ""
