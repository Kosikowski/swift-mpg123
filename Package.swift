// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMpg123",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftMpg123",
            targets: ["SwiftMpg123"]
        ),
        .executable(
            name: "MP3PlayerDemo",
            targets: ["MP3PlayerDemo"]
        ),
    ],
    targets: [
        .target(
            name: "mpg123",
            path: "Sources/mpg123",
            exclude: [
                "module.modulemap",
                "src/Makemodule.am", "src/config.h.in", "src/Makefile.am", "src/Makefile.in", "src/README", "src/*.am", "src/*.in", "src/*.txt", "src/*.dat", "src/*.sh", "src/tests", "src/doc", "src/build", "src/scripts", "src/man1", "src/m4", "src/NEWS*", "src/TODO",
                "src/mpg123-with-modules", "src/out123-with-modules",
                "src/win32_net.c", "src/net123_wininet.c", "src/win32_support.c", "src/term_win32.c", "src/net123_winhttp.c", "src/win32_support.h",
                "src/libout123/modules/win32.c", "src/libout123/modules/win32_wasapi.c",
                "src/compat/Makemodule.am", "src/libmpg123/Makemodule.am", "src/libsyn123/Makemodule.am", "src/tests/Makemodule.am", "src/common/Makemodule.am", "src/libout123/Makemodule.am", "src/libout123/modules/Makemodule.am",
                "src/libout123/modules/pulse.c", "src/libout123/modules/sun.c", "src/libout123/modules/jack.c", "src/libout123/modules/arts.c", "src/libout123/modules/alsa.c", "src/libout123/modules/sdl.c", "src/libout123/modules/tinyalsa.c", "src/libout123/modules/esd.c", "src/libout123/modules/oss.c", "src/libout123/modules/sndio.c", "src/libout123/modules/os2.c", "src/libout123/modules/nas.c", "src/libout123/modules/portaudio.c",
                "src/libout123/modules/qsa.c", "src/libout123/modules/mint.c",
                "src/libout123/modules/sgi.c", "src/libout123/modules/alib.c", "src/libout123/modules/hp.c", "src/libout123/modules/aix.c", "src/libout123/modules/openal.c",
                "src/libmpg123/dct64_3dnow.S", "src/libmpg123/dct64_x86_64_float.S", "src/libmpg123/equalizer_3dnow.S", "src/libmpg123/synth_i586_dither.S", "src/libmpg123/dct64_sse.S", "src/libmpg123/synth_3dnowext.S", "src/libmpg123/synth_mmx.S", "src/libmpg123/synth_stereo_sse_s32.S", "src/libmpg123/dct64_sse_float.S", "src/libmpg123/getcpuflags_x86_64.S", "src/libmpg123/synth_sse_float.S", "src/libmpg123/synth_x86_64_float.S", "src/libmpg123/synth_x86_64.S", "src/libmpg123/synth_stereo_sse_accurate.S", "src/libmpg123/synth_sse_s32.S", "src/libmpg123/synth_x86_64_s32.S", "src/libmpg123/synth_sse_accurate.S", "src/libmpg123/synth_stereo_x86_64_s32.S", "src/libmpg123/dct64_3dnowext.S", "src/libmpg123/synth_i586.S", "src/libmpg123/tabinit_mmx.S", "src/libmpg123/synth_x86_64_accurate.S", "src/libmpg123/dct36_3dnow.S", "src/libmpg123/dct36_x86_64.S", "src/libmpg123/synth_stereo_x86_64_float.S", "src/libmpg123/synth_stereo_sse_float.S", "src/libmpg123/dct36_sse.S", "src/libmpg123/synth_sse.S", "src/libmpg123/synth_stereo_x86_64.S", "src/libmpg123/dct64_mmx.S", "src/libmpg123/synth_3dnow.S", "src/libmpg123/dct36_3dnowext.S", "src/libmpg123/dct64_x86_64.S", "src/libmpg123/synth_stereo_x86_64_accurate.S",
                "src/libmpg123/synth_neon_s32.S", "src/libmpg123/synth_neon_accurate.S", "src/libmpg123/synth_arm.S", "src/libmpg123/synth_stereo_neon.S", "src/libmpg123/synth_neon.S", "src/libmpg123/synth_arm_accurate.S", "src/libmpg123/synth_neon_float.S", "src/libmpg123/synth_stereo_neon_float.S", "src/libmpg123/synth_stereo_neon_s32.S", "src/libmpg123/synth_stereo_neon_accurate.S", "src/libmpg123/dct36_neon.S", "src/libmpg123/check_neon.S",
                "src/libmpg123/dct36_avx.S", "src/libmpg123/synth_stereo_avx.S", "src/libmpg123/synth_stereo_avx_float.S", "src/libmpg123/synth_stereo_avx_s32.S", "src/libmpg123/dct64_avx.S", "src/libmpg123/dct64_avx_float.S", "src/libmpg123/synth_stereo_avx_accurate.S",
                "src/libmpg123/synth_altivec.c", "src/libmpg123/synth_i486.c",
                "src/libmpg123/getcpuflags.S",
                "src/libmpg123/dct64_altivec.c", "src/libmpg123/dct64_neon.S", "src/libmpg123/dct64_neon_float.S",
                "src/libmpg123/testcpu.c",
                "src/libmpg123/getcpuflags_arm.c",
                "src/mpg123.c", "src/out123.c", "src/mpg123-id3dump.c", "src/mpg123-strip.c",
                "src/term_posix.c", "src/term_none.c", "src/audio.c",
                "src/control_generic.c", "src/term.c", "src/common.c", "src/metaprint.c", "src/playlist.c",
                "src/equalizer.c", "src/httpget.c",
                "src/streamdump.c", "src/net123_exec.c",
                "src/resolver.c",
                "src/libout123/legacy_module.c", "src/libmpg123/calctables.c",
                "src/libout123/modules/dummy.c"
            ],
            sources: ["src"],
            publicHeadersPath: "include"
        ),
        .target(
            name: "SwiftMpg123",
            dependencies: ["mpg123"],
            linkerSettings: [
                // No need to link system mpg123, we build it ourselves
            ]
        ),
        .executableTarget(
            name: "MP3PlayerDemo",
            dependencies: ["SwiftMpg123"],
            path: "Sources/MP3PlayerDemo"
        ),
        .testTarget(
            name: "SwiftMpg123Tests",
            dependencies: ["SwiftMpg123"]
        ),
    ]
)
