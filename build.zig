const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const upstream = b.dependency("zlib", .{});
    const lib = b.addStaticLibrary(.{
        .name = "z",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    lib.linkLibC();
    lib.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "adler32.c",
            "crc32.c",
            "deflate.c",
            "infback.c",
            "inffast.c",
            "inflate.c",
            "inftrees.c",
            "trees.c",
            "zutil.c",
            "compress.c",
            "uncompr.c",
            "gzclose.c",
            "gzlib.c",
            "gzread.c",
            "gzwrite.c",
        },
        .flags = &.{
            "-DHAVE_SYS_TYPES_H",
            "-DHAVE_STDINT_H",
            "-DHAVE_STDDEF_H",
            "-DZ_HAVE_UNISTD_H",
        },
    });
    lib.installHeadersDirectoryOptions(.{
        .source_dir = upstream.path(""),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{
            "zconf.h",
            "zlib.h",
        },
    });
    b.installArtifact(lib);
}
