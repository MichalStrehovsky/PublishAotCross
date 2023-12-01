# PublishAotCross

This is a NuGet package with an MSBuild target to aid in crosscompilation with [PublishAot](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/). It helps resolving following error:

```sh
$ dotnet publish -r linux-x64
Microsoft.NETCore.Native.Publish.targets(59,5): error : Cross-OS native compilation is not supported.
```

This nuget package by default uses [Zig](https://ziglang.org/) provided by the package [Vezel.Zig.Toolsets](https://github.com/vezel-dev/zig-toolsets) as the linker/sysroot to allow crosscompiling to linux-x64/linux-arm64/linux-musl-x64/linux-musl-arm64 from a Windows machine.

1. Optional: [download](https://releases.llvm.org/) LLVM. We only need llvm-objcopy executable so if you care about size, you can delete the rest. The executable needs to be on PATH - you could copy it next to the Zig executable. This step is optional and is required only to strip symbols (make the produced executables smaller). If you don't care about stripping symbols, you can skip it.
2. To your project that is already using Native AOT, add a reference to this NuGet package.
3. Publish for one of the newly available RIDs:
    * `dotnet publish -r linux-x64`
    * `dotnet publish -r linux-arm64`
    * `dotnet publish -r linux-musl-x64`
    * `dotnet publish -r linux-musl-arm64`

    If you skipped the second optional step to download llvm-objcopy, you must also pass `/p:StripSymbols=false` to the publish command, or you'll see an error instructing you to do that.


While it's also possible to use your own Zig installation. To use it you need to [download](https://ziglang.org/download/) an archive with Zig for your host machine, extract it and place it on your PATH. When you publish your project, make sure to pass the property `/p:UseExternalZig=true` as well. 


Even though Zig allows crosscompiling for Windows as well, it's not possible to crosscompile PublishAot like this due to ABI differences (MSVC vs. MingW ABI).
