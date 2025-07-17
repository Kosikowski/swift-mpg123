# SwiftMpg123 Package Exclusions Documentation

This document explains the file exclusions and inclusions in `Package.swift` for the SwiftMpg123 library.

## Overview

The SwiftMpg123 package embeds the mpg123 C library source code and selectively excludes files that are not needed for a Swift wrapper library. The goal is to include only the core MP3 decoding functionality while excluding command-line tools, platform-specific modules, and external dependencies.

## File Categories

### 1. Build System Files (Excluded)
```
"src/Makemodule.am", "src/config.h.in"
```
**Why excluded**: These are Autotools build system files used for the original mpg123 build process. Swift Package Manager uses its own build system.

### 2. Module System Files (Excluded)
```
"src/mpg123-with-modules", "src/out123-with-modules"
```
**Why excluded**: These are build scripts for the module system. The Swift wrapper doesn't use dynamic modules.

### 3. Platform-Specific Modules (Selectively Excluded)

#### Windows Modules (Excluded on macOS/Linux)
```
"src/win32_net.c", "src/net123_wininet.c", "src/win32_support.c", "src/term_win32.c", "src/net123_winhttp.c", "src/win32_support.h"
"src/libout123/modules/win32.c", "src/libout123/modules/win32_wasapi.c"
```
**Why excluded**: Windows-specific networking and audio output modules. Not needed on macOS/Linux.

#### Linux Modules (Excluded on macOS)
```
"src/libout123/modules/pulse.c", "src/libout123/modules/alsa.c", "src/libout123/modules/oss.c", "src/libout123/modules/tinyalsa.c", "src/libout123/modules/sndio.c", "src/libout123/modules/esd.c", "src/libout123/modules/nas.c", "src/libout123/modules/arts.c", "src/libout123/modules/jack.c"
```
**Why excluded**: Linux-specific audio output modules (PulseAudio, ALSA, OSS, etc.). Not needed on macOS.

#### Apple Modules (Excluded on Linux)
```
"src/libout123/modules/coreaudio.c"
```
**Why excluded**: macOS-specific Core Audio module. Not needed on Linux.

#### Other Platform Modules (Excluded on all platforms)
```
"src/libout123/modules/sun.c", "src/libout123/modules/hp.c", "src/libout123/modules/sgi.c", "src/libout123/modules/aix.c", "src/libout123/modules/qsa.c", "src/libout123/modules/mint.c", "src/libout123/modules/os2.c", "src/libout123/modules/alib.c"
```
**Why excluded**: Legacy platform modules for systems not supported by Swift Package Manager.

### 4. Cross-Platform Optional Modules (Excluded)
```
"src/libout123/modules/sdl.c", "src/libout123/modules/openal.c", "src/libout123/modules/portaudio.c"
```
**Why excluded**: These modules require external dependencies:
- **SDL**: Simple DirectMedia Layer (game audio)
- **OpenAL**: 3D spatial audio library
- **PortAudio**: Cross-platform audio I/O library

The Swift wrapper only needs MP3 decoding, not audio output functionality.

### 5. Build System Module Files (Excluded)
```
"src/compat/Makemodule.am", "src/libmpg123/Makemodule.am", "src/libsyn123/Makemodule.am", "src/tests", "src/common/Makemodule.am", "src/libout123/Makemodule.am", "src/libout123/modules/Makemodule.am"
```
**Why excluded**: Autotools build system files for subdirectories.

### 6. Architecture-Specific Assembly Files (Selectively Excluded)

#### x86_64 Assembly Files (Excluded on ARM)
```
"src/libmpg123/dct64_3dnow.S", "src/libmpg123/dct64_x86_64_float.S", "src/libmpg123/equalizer_3dnow.S", "src/libmpg123/synth_i586_dither.S", "src/libmpg123/dct64_sse.S", "src/libmpg123/synth_3dnowext.S", "src/libmpg123/synth_mmx.S", "src/libmpg123/synth_stereo_sse_s32.S", "src/libmpg123/dct64_sse_float.S", "src/libmpg123/getcpuflags_x86_64.S", "src/libmpg123/synth_sse_float.S", "src/libmpg123/synth_x86_64_float.S", "src/libmpg123/synth_x86_64.S", "src/libmpg123/synth_stereo_sse_accurate.S", "src/libmpg123/synth_sse_s32.S", "src/libmpg123/synth_x86_64_s32.S", "src/libmpg123/synth_sse_accurate.S", "src/libmpg123/synth_stereo_x86_64_s32.S", "src/libmpg123/dct64_3dnowext.S", "src/libmpg123/synth_i586.S", "src/libmpg123/tabinit_mmx.S", "src/libmpg123/synth_x86_64_accurate.S", "src/libmpg123/dct36_3dnow.S", "src/libmpg123/dct36_x86_64.S", "src/libmpg123/synth_stereo_x86_64_float.S", "src/libmpg123/synth_stereo_sse_float.S", "src/libmpg123/dct36_sse.S", "src/libmpg123/synth_sse.S", "src/libmpg123/synth_stereo_x86_64.S", "src/libmpg123/dct64_mmx.S", "src/libmpg123/synth_3dnow.S", "src/libmpg123/dct36_3dnowext.S", "src/libmpg123/dct64_x86_64.S", "src/libmpg123/synth_stereo_x86_64_accurate.S"
```
**Why excluded**: x86_64-specific optimized assembly code (MMX, SSE, 3DNow!, etc.). Not compatible with ARM processors.

#### ARM64 NEON Assembly Files (Excluded on x86_64)
```
"src/libmpg123/synth_neon64_float.S", "src/libmpg123/synth_neon64.S", "src/libmpg123/synth_stereo_neon64_s32.S", "src/libmpg123/synth_stereo_neon64_accurate.S", "src/libmpg123/dct64_neon64_float.S", "src/libmpg123/dct64_neon64.S", "src/libmpg123/synth_stereo_neon64.S", "src/libmpg123/synth_neon64_s32.S", "src/libmpg123/synth_stereo_neon64_float.S"
```
**Why excluded**: ARM64-specific NEON optimized assembly code. Not compatible with x86_64 processors.

#### ARM32 NEON Assembly Files (Excluded on x86_64)
```
"src/libmpg123/synth_neon_s32.S", "src/libmpg123/synth_neon_accurate.S", "src/libmpg123/synth_arm.S", "src/libmpg123/synth_stereo_neon.S", "src/libmpg123/synth_neon.S", "src/libmpg123/synth_arm_accurate.S", "src/libmpg123/synth_neon_float.S", "src/libmpg123/synth_stereo_neon_float.S", "src/libmpg123/synth_stereo_neon_s32.S", "src/libmpg123/synth_stereo_neon_accurate.S", "src/libmpg123/dct36_neon.S", "src/libmpg123/check_neon.S"
```
**Why excluded**: ARM32-specific NEON optimized assembly code. Not compatible with x86_64 processors.

#### PowerPC Assembly Files (Excluded on all platforms)
```
"src/libmpg123/synth_altivec.c", "src/libmpg123/dct64_altivec.c"
```
**Why excluded**: PowerPC AltiVec optimized code. Not relevant for modern platforms.

#### Legacy x86 Assembly Files (Excluded on all platforms)
```
"src/libmpg123/synth_i486.c", "src/libmpg123/dct64_i386.c", "src/libmpg123/dct64_i486.c"
```
**Why excluded**: Legacy x86 (i386/i486) optimized code. Not relevant for modern platforms.

### 7. CPU Detection and Testing Files (Excluded)
```
"src/libmpg123/getcpuflags.S", "src/libmpg123/getcpuflags_arm.c", "src/libmpg123/testcpu.c"
```
**Why excluded**: Runtime CPU feature detection and testing code. Not needed for the library.

### 8. Executable Files (Excluded)
```
"src/mpg123.c", "src/out123.c", "src/mpg123-id3dump.c", "src/mpg123-strip.c", "src/term_posix.c", "src/term_none.c", "src/audio.c", "src/control_generic.c", "src/term.c", "src/common.c", "src/metaprint.c", "src/playlist.c", "src/equalizer.c", "src/httpget.c", "src/streamdump.c", "src/net123_exec.c", "src/resolver.c", "src/libout123/legacy_module.c", "src/libmpg123/calctables.c", "src/libout123/modules/dummy.c"
```
**Why excluded**: These are command-line tools and application-specific code:
- **Command-line tools**: `mpg123.c`, `out123.c`, `mpg123-id3dump.c`, `mpg123-strip.c`
- **Terminal interfaces**: `term_posix.c`, `term_none.c`, `term.c`, `control_generic.c`
- **Application code**: `audio.c`, `common.c`, `metaprint.c`, `playlist.c`, `equalizer.c`, `httpget.c`, `streamdump.c`, `net123_exec.c`, `resolver.c`
- **Build utilities**: `calctables.c` (build-time table generation)
- **Module system**: `legacy_module.c`, `dummy.c`

The Swift wrapper only needs the core MP3 decoding library, not the command-line tools or audio output functionality.

## What's Included

### Core MP3 Decoding Library
- **`src/libmpg123/`** - Core MP3 decoding functionality
- **`src/compat/`** - Platform compatibility layer
- **`src/common/`** - Common utilities
- **`src/libsyn123/`** - Audio synthesis library

### Platform-Specific Optimizations
- **macOS**: Core Audio modules, x86_64 assembly optimizations
- **Linux**: ALSA/PulseAudio modules, x86_64 assembly optimizations
- **iOS/tvOS/visionOS**: Core Audio modules, ARM64 assembly optimizations

## Benefits of This Approach

1. **Reduced Build Time**: Excluding unnecessary files speeds up compilation
2. **Smaller Binary Size**: Only includes code that's actually needed
3. **No External Dependencies**: Avoids linking against external audio libraries
4. **Platform Compatibility**: Includes only relevant code for each platform
5. **Maintainability**: Clear separation between library code and application code

## Platform-Specific Considerations

### macOS
- Includes Core Audio modules
- Includes x86_64 and ARM64 assembly optimizations
- Excludes Linux-specific audio modules

### Linux
- Includes ALSA/PulseAudio modules
- Includes x86_64 assembly optimizations
- Excludes macOS-specific modules

### iOS/tvOS/visionOS
- Includes Core Audio modules
- Includes ARM64 assembly optimizations
- Excludes x86_64 assembly code

This selective inclusion ensures that each platform gets only the code it needs while maintaining full MP3 decoding functionality. 