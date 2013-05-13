newoption {
	trigger		= "no-64bit",
	description	= "Don't add the 64-bit project configuration."
}

newoption {
	trigger		= "no-static",
	description	= "Don't compile as a static runtime."
}

solution "serverlist3"
	configurations { "Debug", "Release" }
	platforms { "native", "x32" }
	if not _OPTIONS["no-64bit"] then platforms { "x64" } end
	flags { "Symbols", "Unicode" }
	if not _OPTIONS["no-static"] then flags { "StaticRuntime" } end
	
	project "serverlist3"
		kind "ConsoleApp"
		language "C++"
		location "projects"
		targetdir "../bin"
		targetname "serverlist3"
		files { "../include/**", "../source/**" }
		includedirs { "../server/include" }
		
		-- It bugs if I remove next line, but why? paul
		includedirs { "../dependencies" }
		
		files { "../dependencies/bzip2/**" }
		includedirs { "../dependencies/bzip2" }

		files { "../dependencies/zlib/**" }
		includedirs { "../dependencies/zlib" }
		
		-- Libraries.
		configuration "windows"
			links { "ws2_32" }
		
		-- Windows defines.
		configuration "windows"
			defines { "WIN32", "_WIN32" }
		if not _OPTIONS["no-64bit"] then 
			configuration { "windows", "x64" }
				defines { "WIN64", "_WIN64" }
		end
		-- Dependencies (Windows only, we expect others to have those)

		-- Linux defines.
		configuration "Linux"
			defines { "_BSD_SOURCE", "_POSIX_C_SOURCE=1" }
		
		-- Debug options.
		configuration "Debug"
			defines { "DEBUG" }
			targetsuffix "_d"
			flags { "NoEditAndContinue" }
		
		-- Release options.
		configuration "Release"
			defines { "NDEBUG" }
			flags { "OptimizeSpeed" }
