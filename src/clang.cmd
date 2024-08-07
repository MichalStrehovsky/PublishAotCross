@echo off

@where zig >nul 2>&1
@if ERRORLEVEL 1 (
  echo Error: zig is not on the PATH. Install zig and make sure it's on PATH. Follow instructions at https://github.com/MichalStrehovsky/PublishAotCross.
  exit /B 1
)

set args=%*

rem Works around zlib not being available with zig. This is not great.
set args=%args:-lz =%

rem Work around a .NET 8 Preview 6 issue
set args=%args:'-Wl,-rpath,$ORIGIN'=-Wl,-rpath,$ORIGIN%

rem Work around parameters unsupported by zig. Just drop them from the command line.
set args=%args:--discard-all=--as-needed%
set args=%args:-Wl,-pie =%
set args=%args:-pie =%
set args=%args:-Wl,-e0x0 =%

rem Works around zig linker dropping necessary parts of the executable.
set args=-Wl,-u,__Module %args%

rem Run zig cc
zig cc %args%
