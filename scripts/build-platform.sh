#!/bin/bash

# Build script for SwiftMpg123 with platform-specific file inclusion
# Usage: 
#   BUILD_MPG123_FOR_APPLE=1 swift run build-platform.sh
#   BUILD_MPG123_FOR_LINUX=1 swift run build-platform.sh  
#   BUILD_MPG123_FOR_WINDOWS=1 swift run build-platform.sh

set -e

# Default to Apple if no platform specified
if [ -z "$BUILD_MPG123_FOR_APPLE" ] && [ -z "$BUILD_MPG123_FOR_LINUX" ] && [ -z "$BUILD_MPG123_FOR_WINDOWS" ]; then
    BUILD_MPG123_FOR_APPLE=1
fi

echo "Building for platform:"
if [ "$BUILD_MPG123_FOR_APPLE" = "1" ]; then
    echo "  - Apple (macOS/iOS)"
    PLATFORM="apple"
elif [ "$BUILD_MPG123_FOR_LINUX" = "1" ]; then
    echo "  - Linux"
    PLATFORM="linux"
elif [ "$BUILD_MPG123_FOR_WINDOWS" = "1" ]; then
    echo "  - Windows"
    PLATFORM="windows"
else
    echo "  - Unknown platform, defaulting to Apple"
    PLATFORM="apple"
fi

# Create a temporary Package.swift with platform-specific excludes
cp Package.swift Package.swift.tmp

# Function to comment/uncomment lines in Package.swift
comment_line() {
    local pattern="$1"
    local file="Package.swift"
    sed -i.tmp "s/^[[:space:]]*\"$pattern\"/\/\/ \"$pattern\"/" "$file"
}

uncomment_line() {
    local pattern="$1"
    local file="Package.swift"
    sed -i.tmp "s/^[[:space:]]*\/\/ \"$pattern\"/\"$pattern\"/" "$file"
}

# Windows-specific files
WINDOWS_FILES=(
    "src/win32_net.c"
    "src/net123_wininet.c"
    "src/win32_support.c"
    "src/term_win32.c"
    "src/net123_winhttp.c"
    "src/win32_support.h"
    "src/libout123/modules/win32.c"
    "src/libout123/modules/win32_wasapi.c"
)

# Linux-specific files
LINUX_FILES=(
    "src/libout123/modules/pulse.c"
    "src/libout123/modules/alsa.c"
    "src/libout123/modules/oss.c"
    "src/libout123/modules/tinyalsa.c"
    "src/libout123/modules/sndio.c"
    "src/libout123/modules/esd.c"
    "src/libout123/modules/nas.c"
    "src/libout123/modules/arts.c"
    "src/libout123/modules/jack.c"
)

# Apple-specific files (only coreaudio should be included)
APPLE_FILES=(
    "src/libout123/modules/coreaudio.c"
)

# Other platform files (always excluded)
OTHER_PLATFORM_FILES=(
    "src/libout123/modules/sun.c"
    "src/libout123/modules/hp.c"
    "src/libout123/modules/sgi.c"
    "src/libout123/modules/aix.c"
    "src/libout123/modules/qsa.c"
    "src/libout123/modules/mint.c"
    "src/libout123/modules/os2.c"
    "src/libout123/modules/alib.c"
)

# Cross-platform optional files (can be included on any platform)
CROSS_PLATFORM_OPTIONAL=(
    "src/libout123/modules/sdl.c"
    "src/libout123/modules/openal.c"
    "src/libout123/modules/portaudio.c"
)

echo "Configuring excludes for $PLATFORM..."

# First, comment out all platform-specific files
for file in "${WINDOWS_FILES[@]}" "${LINUX_FILES[@]}" "${APPLE_FILES[@]}" "${OTHER_PLATFORM_FILES[@]}" "${CROSS_PLATFORM_OPTIONAL[@]}"; do
    comment_line "$file"
done

# Then uncomment files for the target platform
if [ "$PLATFORM" = "apple" ]; then
    echo "Including Apple-specific files..."
    for file in "${APPLE_FILES[@]}"; do
        uncomment_line "$file"
    done
elif [ "$PLATFORM" = "linux" ]; then
    echo "Including Linux-specific files..."
    for file in "${LINUX_FILES[@]}"; do
        uncomment_line "$file"
    done
elif [ "$PLATFORM" = "windows" ]; then
    echo "Including Windows-specific files..."
    for file in "${WINDOWS_FILES[@]}"; do
        uncomment_line "$file"
    done
fi

# Clean up temporary files
rm -f Package.swift.tmp

echo "Package.swift configured for $PLATFORM platform"
echo "Building with swift build..."

# Build the package
swift build

echo "Build complete!" 