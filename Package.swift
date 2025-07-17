// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var targets: [Target] = [
    .target(
        name: "SwiftMpg123",
        dependencies: ["cmpg123"],
        path: "Sources/SwiftMpg123"
    ),
     .testTarget(
        name: "SwiftMpg123Tests",
        dependencies: ["SwiftMpg123"]
    )
]

#if os(macOS)
targets.append(
    .executableTarget(
        name: "MP3PlayerDemo",
        dependencies: ["SwiftMpg123"],
        path: "Sources/MP3PlayerDemo"
    )
)
#endif

// Platform-specific C targets
#if os(macOS)
targets.insert(
    .target(
        name: "cmpg123",
        path: "Sources/mpg123",
        exclude: [
            "module.modulemap",
            "src/Makemodule.am", "src/config.h.in",
            "src/mpg123-with-modules", "src/out123-with-modules",
            // Exclude all Linux and Windows modules
            "src/win32_net.c", "src/net123_wininet.c", "src/win32_support.c", "src/term_win32.c", "src/net123_winhttp.c", "src/win32_support.h",
            "src/libout123/modules/win32.c", "src/libout123/modules/win32_wasapi.c",
            "src/libout123/modules/pulse.c", "src/libout123/modules/alsa.c", "src/libout123/modules/oss.c", "src/libout123/modules/tinyalsa.c", "src/libout123/modules/sndio.c", "src/libout123/modules/esd.c", "src/libout123/modules/nas.c", "src/libout123/modules/arts.c", "src/libout123/modules/jack.c",
            // Only include coreaudio for Apple
            // Exclude all other platform modules
            "src/libout123/modules/sun.c", "src/libout123/modules/hp.c", "src/libout123/modules/sgi.c", "src/libout123/modules/aix.c", "src/libout123/modules/qsa.c", "src/libout123/modules/mint.c", "src/libout123/modules/os2.c", "src/libout123/modules/alib.c",
            // Cross-platform optional files (excluded by default)
            "src/libout123/modules/sdl.c", "src/libout123/modules/openal.c", "src/libout123/modules/portaudio.c",
            // Build system files
            "src/compat/Makemodule.am", "src/libmpg123/Makemodule.am", "src/libsyn123/Makemodule.am", "src/tests", "src/common/Makemodule.am", "src/libout123/Makemodule.am", "src/libout123/modules/Makemodule.am",
            // Assembly and other arch-specific files (as before)
            "src/libmpg123/dct64_3dnow.S", "src/libmpg123/dct64_x86_64_float.S", "src/libmpg123/equalizer_3dnow.S", "src/libmpg123/synth_i586_dither.S", "src/libmpg123/dct64_sse.S", "src/libmpg123/synth_3dnowext.S", "src/libmpg123/synth_mmx.S", "src/libmpg123/synth_stereo_sse_s32.S", "src/libmpg123/dct64_sse_float.S", "src/libmpg123/getcpuflags_x86_64.S", "src/libmpg123/synth_sse_float.S", "src/libmpg123/synth_x86_64_float.S", "src/libmpg123/synth_x86_64.S", "src/libmpg123/synth_stereo_sse_accurate.S", "src/libmpg123/synth_sse_s32.S", "src/libmpg123/synth_x86_64_s32.S", "src/libmpg123/synth_sse_accurate.S", "src/libmpg123/synth_stereo_x86_64_s32.S", "src/libmpg123/dct64_3dnowext.S", "src/libmpg123/synth_i586.S", "src/libmpg123/tabinit_mmx.S", "src/libmpg123/synth_x86_64_accurate.S", "src/libmpg123/dct36_3dnow.S", "src/libmpg123/dct36_x86_64.S", "src/libmpg123/synth_stereo_x86_64_float.S", "src/libmpg123/synth_stereo_sse_float.S", "src/libmpg123/dct36_sse.S", "src/libmpg123/synth_sse.S", "src/libmpg123/synth_stereo_x86_64.S", "src/libmpg123/dct64_mmx.S", "src/libmpg123/synth_3dnow.S", "src/libmpg123/dct36_3dnowext.S", "src/libmpg123/dct64_x86_64.S", "src/libmpg123/synth_stereo_x86_64_accurate.S",
            "src/libmpg123/synth_neon_s32.S", "src/libmpg123/synth_neon_accurate.S", "src/libmpg123/synth_arm.S", "src/libmpg123/synth_stereo_neon.S", "src/libmpg123/synth_neon.S", "src/libmpg123/synth_arm_accurate.S", "src/libmpg123/synth_neon_float.S", "src/libmpg123/synth_stereo_neon_float.S", "src/libmpg123/synth_stereo_neon_s32.S", "src/libmpg123/synth_stereo_neon_accurate.S", "src/libmpg123/dct36_neon.S", "src/libmpg123/check_neon.S",
            "src/libmpg123/dct36_avx.S", "src/libmpg123/synth_stereo_avx.S", "src/libmpg123/synth_stereo_avx_float.S", "src/libmpg123/synth_stereo_avx_s32.S", "src/libmpg123/dct64_avx.S", "src/libmpg123/dct64_avx_float.S", "src/libmpg123/synth_stereo_avx_accurate.S",
            "src/libmpg123/synth_altivec.c", "src/libmpg123/synth_i486.c", "src/libmpg123/getcpuflags.S", "src/libmpg123/dct64_altivec.c", "src/libmpg123/dct64_neon.S", "src/libmpg123/dct64_neon_float.S", "src/libmpg123/testcpu.c", "src/libmpg123/getcpuflags_arm.c",
            // Executable files (not needed for library)
            "src/mpg123.c", "src/out123.c", "src/mpg123-id3dump.c", "src/mpg123-strip.c", "src/term_posix.c", "src/term_none.c", "src/audio.c", "src/control_generic.c", "src/term.c", "src/common.c", "src/metaprint.c", "src/playlist.c", "src/equalizer.c", "src/httpget.c", "src/streamdump.c", "src/net123_exec.c", "src/resolver.c", "src/libout123/legacy_module.c", "src/libmpg123/calctables.c", "src/libout123/modules/dummy.c"
        ],
        sources: ["src"],
        publicHeadersPath: "include"
    ), at: 0)
#endif

#if os(Linux)
targets.insert(
    .target(
        name: "cmpg123",
        path: "Sources/mpg123",
        exclude: [
            "module.modulemap",
            "src/Makemodule.am", "src/config.h.in",
            "src/mpg123-with-modules", "src/out123-with-modules",
            // Exclude all Apple and Windows modules
            "src/win32_net.c", "src/net123_wininet.c", "src/win32_support.c", "src/term_win32.c", "src/net123_winhttp.c", "src/win32_support.h",
            "src/libout123/modules/win32.c", "src/libout123/modules/win32_wasapi.c",
            "src/libout123/modules/coreaudio.c",
            // Only include alsa, pulse, oss, etc. for Linux
            // Exclude all other platform modules
            "src/libout123/modules/sun.c", "src/libout123/modules/hp.c", "src/libout123/modules/sgi.c", "src/libout123/modules/aix.c", "src/libout123/modules/qsa.c", "src/libout123/modules/mint.c", "src/libout123/modules/os2.c", "src/libout123/modules/alib.c",
            // Exclude modules that require external libraries
            "src/libout123/modules/tinyalsa.c", "src/libout123/modules/pulse.c", "src/libout123/modules/alsa.c", "src/libout123/modules/oss.c", "src/libout123/modules/sndio.c", "src/libout123/modules/esd.c", "src/libout123/modules/nas.c", "src/libout123/modules/arts.c", "src/libout123/modules/jack.c",
            // Cross-platform optional files (excluded by default)
            "src/libout123/modules/sdl.c", "src/libout123/modules/openal.c", "src/libout123/modules/portaudio.c",
            // Build system files
            "src/compat/Makemodule.am", "src/libmpg123/Makemodule.am", "src/libsyn123/Makemodule.am", "src/tests", "src/common/Makemodule.am", "src/libout123/Makemodule.am", "src/libout123/modules/Makemodule.am",
            // Assembly and other arch-specific files (as before)
            "src/libmpg123/dct64_3dnow.S", "src/libmpg123/dct64_x86_64_float.S", "src/libmpg123/equalizer_3dnow.S", "src/libmpg123/synth_i586_dither.S", "src/libmpg123/dct64_sse.S", "src/libmpg123/synth_3dnowext.S", "src/libmpg123/synth_mmx.S", "src/libmpg123/synth_stereo_sse_s32.S", "src/libmpg123/dct64_sse_float.S", "src/libmpg123/getcpuflags_x86_64.S", "src/libmpg123/synth_sse_float.S", "src/libmpg123/synth_x86_64_float.S", "src/libmpg123/synth_x86_64.S", "src/libmpg123/synth_stereo_sse_accurate.S", "src/libmpg123/synth_sse_s32.S", "src/libmpg123/synth_x86_64_s32.S", "src/libmpg123/synth_sse_accurate.S", "src/libmpg123/synth_stereo_x86_64_s32.S", "src/libmpg123/dct64_3dnowext.S", "src/libmpg123/synth_i586.S", "src/libmpg123/tabinit_mmx.S", "src/libmpg123/synth_x86_64_accurate.S", "src/libmpg123/dct36_3dnow.S", "src/libmpg123/dct36_x86_64.S", "src/libmpg123/synth_stereo_x86_64_float.S", "src/libmpg123/synth_stereo_sse_float.S", "src/libmpg123/dct36_sse.S", "src/libmpg123/synth_sse.S", "src/libmpg123/synth_stereo_x86_64.S", "src/libmpg123/dct64_mmx.S", "src/libmpg123/synth_3dnow.S", "src/libmpg123/dct36_3dnowext.S", "src/libmpg123/dct64_x86_64.S", "src/libmpg123/synth_stereo_x86_64_accurate.S",
            "src/libmpg123/synth_neon_s32.S", "src/libmpg123/synth_neon_accurate.S", "src/libmpg123/synth_neon64_accurate.S", "src/libmpg123/synth_arm.S", "src/libmpg123/synth_stereo_neon.S", "src/libmpg123/synth_neon.S", "src/libmpg123/synth_arm_accurate.S", "src/libmpg123/synth_neon_float.S", "src/libmpg123/synth_stereo_neon_float.S", "src/libmpg123/synth_stereo_neon_s32.S", "src/libmpg123/synth_stereo_neon_accurate.S", "src/libmpg123/dct36_neon.S", "src/libmpg123/dct36_neon64.S", "src/libmpg123/check_neon.S",
            // Additional ARM64 NEON files that need to be excluded
            "src/libmpg123/synth_neon64_float.S", "src/libmpg123/synth_neon64.S", "src/libmpg123/synth_stereo_neon64_s32.S", "src/libmpg123/synth_stereo_neon64_accurate.S", "src/libmpg123/dct64_neon64_float.S", "src/libmpg123/dct64_neon64.S", "src/libmpg123/synth_stereo_neon64.S", "src/libmpg123/synth_neon64_s32.S", "src/libmpg123/synth_stereo_neon64_float.S",
            "src/libmpg123/dct36_avx.S", "src/libmpg123/synth_stereo_avx.S", "src/libmpg123/synth_stereo_avx_float.S", "src/libmpg123/synth_stereo_avx_s32.S", "src/libmpg123/dct64_avx.S", "src/libmpg123/dct64_avx_float.S", "src/libmpg123/synth_stereo_avx_accurate.S",
            "src/libmpg123/synth_altivec.c", "src/libmpg123/synth_i486.c", "src/libmpg123/getcpuflags.S", "src/libmpg123/dct64_altivec.c", "src/libmpg123/dct64_neon.S", "src/libmpg123/dct64_neon_float.S", "src/libmpg123/testcpu.c", "src/libmpg123/getcpuflags_arm.c",
            // Executable files (not needed for library)
            "src/mpg123.c", "src/out123.c", "src/mpg123-id3dump.c", "src/mpg123-strip.c", "src/term_posix.c", "src/term_none.c", "src/audio.c", "src/control_generic.c", "src/term.c", "src/common.c", "src/metaprint.c", "src/playlist.c", "src/equalizer.c", "src/httpget.c", "src/streamdump.c", "src/net123_exec.c", "src/resolver.c", "src/libout123/legacy_module.c", "src/libmpg123/calctables.c", "src/libout123/modules/dummy.c"
        ],
        sources: ["src"],
        publicHeadersPath: "include"
    ), at: 0)
#endif

#if os(Windows)
targets.insert(
    .target(
        name: "cmpg123",
        path: "Sources/mpg123",
        exclude: [
            "module.modulemap",
            "src/Makemodule.am", "src/config.h.in",
            "src/mpg123-with-modules", "src/out123-with-modules",
            // Exclude all Apple and Linux modules
            "src/libout123/modules/coreaudio.c",
            // Exclude Windows-specific files that cause POSIX dependencies
            "src/win32_support.c", "src/win32_support.h", "src/win32_net.c", "src/net123_wininet.c", "src/net123_winhttp.c", "src/term_win32.c",
            // Exclude files that include mpg123app.h (which includes compat.h)
            "src/sysutil.c", "src/local.c",
            // Exclude files that include compat.h directly
            "src/getlopt.c", "src/libmpg123/stringbuf.c", "src/libmpg123/icy2utf8.c", "src/libmpg123/lfs_wrap.c", "src/libout123/xfermem.c", "src/libout123/stringlists.c", "src/libout123/module.c",
            // Exclude libsyn123 directory (has POSIX dependencies)
            "src/libsyn123",
            // Exclude libout123 directory (has POSIX dependencies)
            "src/libout123",
            // Exclude files that include mpg123lib_intern.h (which includes compat.h)
            "src/libmpg123/tabinit.c",
            "src/libout123/modules/pulse.c", "src/libout123/modules/alsa.c", "src/libout123/modules/oss.c", "src/libout123/modules/tinyalsa.c", "src/libout123/modules/sndio.c", "src/libout123/modules/esd.c", "src/libout123/modules/nas.c", "src/libout123/modules/arts.c", "src/libout123/modules/jack.c",
            // Only include win32, win32_wasapi, etc. for Windows
            // Exclude all other platform modules
            "src/libout123/modules/sun.c", "src/libout123/modules/hp.c", "src/libout123/modules/sgi.c", "src/libout123/modules/aix.c", "src/libout123/modules/qsa.c", "src/libout123/modules/mint.c", "src/libout123/modules/os2.c", "src/libout123/modules/alib.c",
            // Cross-platform optional files (excluded by default)
            "src/libout123/modules/sdl.c", "src/libout123/modules/openal.c", "src/libout123/modules/portaudio.c",
            // Build system files
            "src/compat/Makemodule.am", "src/libmpg123/Makemodule.am", "src/libsyn123/Makemodule.am", "src/tests", "src/common/Makemodule.am", "src/libout123/Makemodule.am", "src/libout123/modules/Makemodule.am",
            // Assembly and other arch-specific files (as before)
            "src/libmpg123/dct64_3dnow.S", "src/libmpg123/dct64_x86_64_float.S", "src/libmpg123/equalizer_3dnow.S", "src/libmpg123/synth_i586_dither.S", "src/libmpg123/dct64_sse.S", "src/libmpg123/synth_3dnowext.S", "src/libmpg123/synth_mmx.S", "src/libmpg123/synth_stereo_sse_s32.S", "src/libmpg123/dct64_sse_float.S", "src/libmpg123/getcpuflags_x86_64.S", "src/libmpg123/synth_sse_float.S", "src/libmpg123/synth_x86_64_float.S", "src/libmpg123/synth_x86_64.S", "src/libmpg123/synth_stereo_sse_accurate.S", "src/libmpg123/synth_sse_s32.S", "src/libmpg123/synth_x86_64_s32.S", "src/libmpg123/synth_sse_accurate.S", "src/libmpg123/synth_stereo_x86_64_s32.S", "src/libmpg123/dct64_3dnowext.S", "src/libmpg123/synth_i586.S", "src/libmpg123/tabinit_mmx.S", "src/libmpg123/synth_x86_64_accurate.S", "src/libmpg123/dct36_3dnow.S", "src/libmpg123/dct36_x86_64.S", "src/libmpg123/synth_stereo_x86_64_float.S", "src/libmpg123/synth_stereo_sse_float.S", "src/libmpg123/dct36_sse.S", "src/libmpg123/synth_sse.S", "src/libmpg123/synth_stereo_x86_64.S", "src/libmpg123/dct64_mmx.S", "src/libmpg123/synth_3dnow.S", "src/libmpg123/dct36_3dnowext.S", "src/libmpg123/dct64_x86_64.S", "src/libmpg123/synth_stereo_x86_64_accurate.S",
            "src/libmpg123/synth_neon_s32.S", "src/libmpg123/synth_neon_accurate.S", "src/libmpg123/synth_arm.S", "src/libmpg123/synth_stereo_neon.S", "src/libmpg123/synth_neon.S", "src/libmpg123/synth_arm_accurate.S", "src/libmpg123/synth_neon_float.S", "src/libmpg123/synth_stereo_neon_float.S", "src/libmpg123/synth_stereo_neon_s32.S", "src/libmpg123/synth_stereo_neon_accurate.S", "src/libmpg123/dct36_neon.S", "src/libmpg123/check_neon.S",
            // Exclude POSIX-only files for Windows
            "src/compat/compat.c", "src/compat/compat.h",
            "src/libmpg123/dct36_avx.S", "src/libmpg123/synth_stereo_avx.S", "src/libmpg123/synth_stereo_avx_float.S", "src/libmpg123/synth_stereo_avx_s32.S", "src/libmpg123/dct64_avx.S", "src/libmpg123/dct64_avx_float.S", "src/libmpg123/synth_stereo_avx_accurate.S",
            "src/libmpg123/synth_altivec.c", "src/libmpg123/synth_i486.c", "src/libmpg123/getcpuflags.S", "src/libmpg123/dct64_altivec.c", "src/libmpg123/dct64_neon.S", "src/libmpg123/dct64_neon_float.S", "src/libmpg123/testcpu.c", "src/libmpg123/getcpuflags_arm.c",
            // Executable files (not needed for library)
            "src/mpg123.c", "src/out123.c", "src/mpg123-id3dump.c", "src/mpg123-strip.c", "src/term_posix.c", "src/term_none.c", "src/audio.c", "src/control_generic.c", "src/term.c", "src/common.c", "src/metaprint.c", "src/playlist.c", "src/equalizer.c", "src/httpget.c", "src/streamdump.c", "src/net123_exec.c", "src/resolver.c", "src/libout123/legacy_module.c", "src/libmpg123/calctables.c", "src/libout123/modules/dummy.c"
        ],
        sources: ["src"],
        publicHeadersPath: "include"
    ), at: 0)
#endif

var products: [Product] = [
        .library(
            name: "SwiftMpg123",
            targets: ["SwiftMpg123"]
        ),
    ]

#if os(macOS)

products.append(
    .executable(
            name: "MP3PlayerDemo",
            targets: ["MP3PlayerDemo"]
        )
)
#endif

let package = Package(
    name: "SwiftMpg123",
    platforms: [
        .macOS(.v12),
    ],
    products: products,
    targets: targets
)
