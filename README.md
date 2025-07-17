# SwiftMpg123

A comprehensive Swift wrapper for the mpg123 library, providing easy access to MP3 decoding functionality in Swift applications.

## Overview

SwiftMpg123 is a Swift Package Manager (SPM) package that wraps the mpg123 C library, allowing you to decode MP3 files and extract metadata in Swift applications. The package provides a clean Swift API while maintaining the performance and reliability of the underlying mpg123 library.

## Features

### Core Functionality
- ✅ MP3 file decoding and playback
- ✅ Audio format detection and configuration
- ✅ Metadata extraction (ID3v1/ID3v2 tags)
- ✅ Seeking and positioning in audio streams
- ✅ Streaming audio data processing

### Advanced Features
- ✅ **Parameter Configuration** - Set and get mpg123 parameters (flags, RVA, etc.)
- ✅ **Feature Detection** - Check what features are available in the mpg123 build
- ✅ **Frame-by-Frame Decoding** - Decode individual MP3 frames with detailed information
- ✅ **Equalizer Support** - 32-band equalizer with per-channel control
- ✅ **Volume Control** - Set volume, change by factor or decibels
- ✅ **Feed Mode** - Direct feeding of MP3 data for streaming applications
- ✅ **Comprehensive Error Handling** - Detailed error types with descriptions
- ✅ **Audio Stream Interface** - Swift Sequence for easy audio processing

### Audio Processing
- ✅ Multiple output formats (8-bit, 16-bit, 32-bit, float)
- ✅ Channel conversion (mono/stereo)
- ✅ Sample rate conversion
- ✅ Gapless playback support
- ✅ Variable bitrate (VBR) support

## Demo: MP3 Playback Example

A full-featured demo is included to show how to use SwiftMpg123 for real MP3 playback using AVAudioPlayerNode. The demo covers:
- Decoding MP3 files
- Displaying metadata
- Creating audio buffers
- Playing audio with AVFoundation
- Handling multiple audio formats

See [docs/MP3PlayerDemo.md](docs/MP3PlayerDemo.md) for build and usage instructions.

## System Requirements

### Prerequisites

- **macOS 12.0+** (primary development platform)
- **Swift 5.9+**
- **Xcode 15.0+** (for macOS development)

### Development Tools

For development, you'll also need:
- **SwiftFormat** - Code formatting
- **Pre-commit** - Git hooks for code quality

Install them with:
```bash
brew install swiftformat pre-commit
```

### Embedded Library

This package embeds the mpg123 library directly, so no system installation is required. The package is self-contained and works on macOS, Linux, and Windows.

**Note:** Previous versions required system installation of mpg123. This version embeds the library for better portability.

## Installation

### Using Swift Package Manager

Add SwiftMpg123 to your project's dependencies in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/swift-mpg123.git", from: "1.0.0")
]
```

Or add it directly to your Xcode project:
1. In Xcode, go to File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/swift-mpg123.git
cd swift-mpg123
```

2. Set up development environment (optional but recommended):
```bash
./scripts/setup-dev.sh
```

3. Build the package:

   **Standard Build (macOS/Apple):**
   ```bash
   swift build
   ```

   **Platform-Specific Builds:**

   The package supports building for different platforms with appropriate file inclusion:

   **For Apple (macOS/iOS):**
   ```bash
   BUILD_MPG123_FOR_APPLE=1 swift scripts/build-platform.swift
   ```

   **For Linux:**
   ```bash
   BUILD_MPG123_FOR_LINUX=1 swift scripts/build-platform.swift
   ```

   **For Windows:**
   ```bash
   BUILD_MPG123_FOR_WINDOWS=1 swift scripts/build-platform.swift
   ```

   **Alternative: Bash Script**
   ```bash
   BUILD_MPG123_FOR_APPLE=1 ./scripts/build-platform.sh
   BUILD_MPG123_FOR_LINUX=1 ./scripts/build-platform.sh
   BUILD_MPG123_FOR_WINDOWS=1 ./scripts/build-platform.sh
   ```

4. Run tests:
```bash
swift test
```

## Package Structure

```
swift-mpg123/
├── Package.swift              # Package configuration
├── Sources/
│   ├── mpg123/               # C library wrapper
│   │   ├── module.modulemap  # Module map for C interop
│   │   └── include/          # mpg123 headers
│   │       ├── mpg123.h
│   │       ├── fmt123.h
│   │       └── ...
│   ├── SwiftMpg123/          # Swift wrapper
│   │   └── SwiftMPG.swift    # Main Swift API
│   └── MP3PlayerDemo/        # Demo application
│       ├── main.swift
│       └── MP3Player.swift
├── Tests/
│   └── SwiftMpg123Tests/     # Unit tests
│       └── MPG123Tests.swift
├── .github/
│   ├── workflows/            # CI/CD workflows
│   │   └── ci.yml
│   └── dependabot.yml        # Dependency updates
├── scripts/
│   └── setup-dev.sh          # Development setup script
├── .swiftformat              # SwiftFormat configuration
└── .pre-commit-config.yaml   # Pre-commit hooks
```

## Development Workflow

### Code Quality

This project uses automated code quality tools:

- **SwiftFormat** - Automatically formats code
- **Pre-commit hooks** - Run quality checks before commits

### CI/CD Pipeline

The project includes a comprehensive CI/CD pipeline that runs on:

- **macOS** - Build, test, and validate on latest macOS with Swift 5.9 and 6.1.2
- **Code quality checks** - SwiftFormat validation
- **Security scanning** - Vulnerability scanning with Trivy
- **Package validation** - Verify package structure and dependencies
- **Automated releases** - Create GitHub releases on version tags

### Development Setup

1. **Quick setup** (recommended):
   ```bash
   ./scripts/setup-dev.sh
   ```

2. **Manual setup**:
   ```bash
   # Install development tools
   brew install swiftformat pre-commit
   
   # Install pre-commit hooks
   pre-commit install
   ```

3. **Format code**:
   ```bash
   swiftformat --config .swiftformat Sources/ Tests/
   ```

### Contributing

When contributing to this project:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run the development tools:
   ```bash
   swift build
   swift test
   swiftformat --config .swiftformat Sources/ Tests/
   ```
5. Commit your changes (pre-commit hooks will run automatically)
6. Push and create a pull request

The CI pipeline will automatically:
- Build and test your changes on macOS with Swift 5.9 and 6.1.2
- Check code quality with SwiftFormat
- Validate the package structure
- Run security scans
- Create releases on version tags

## Configuration Details

### Embedded Library Integration

The package embeds the mpg123 library directly as a C target:

```swift
.target(
    name: "mpg123",
    path: "Sources/mpg123",
    exclude: ["module.modulemap"],
    sources: ["src"],
    publicHeadersPath: "include"
)
```

### Header Files

The package includes the necessary mpg123 header files in `Sources/mpg123/include/`:
- `mpg123.h` - Main library header
- `fmt123.h` - Format utilities
- `config.h` - Platform-specific configuration
- Additional dependency headers

### Module Map

The module map (`Sources/mpg123/module.modulemap`) configures the C library for Swift interop:

```modulemap
module mpg123 {
  header "include/mpg123.h"
  export *
}
```

### Source Code

The embedded mpg123 source code is located in `Sources/mpg123/src/` and includes:
- `libmpg123/` - Core MP3 decoding library
- `libout123/` - Audio output library
- `libsyn123/` - Synthesis library
- Platform-specific optimizations and modules

## Usage

### Basic Example

```swift
import SwiftMpg123

do {
    let mpg = try MPG123()
    try mpg.open(path: "/path/to/audio.mp3")
    
    // Get audio format information
    print("Sample Rate: \(mpg.sampleRate)")
    print("Channels: \(mpg.channels)")
    print("Encoding: \(mpg.encoding)")
    
    // Get metadata
    let metadata = mpg.metadata()
    print("Title: \(metadata["title"] ?? "Unknown")")
    print("Artist: \(metadata["artist"] ?? "Unknown")")
    
    // Read audio data
    let buffer = try mpg.read()
    // Process audio data...
    
    mpg.close()
} catch {
    print("Error: \(error)")
}
```

### Advanced Features

#### Parameter Configuration

```swift
let mpg = try MPG123()

// Set gapless playback
try mpg.setParameter(.flags, value: MPG123Flag.gapless.rawValue)

// Set RVA (ReplayGain) mode
try mpg.setParameter(.rva, value: MPG123RVA.mix.rawValue)

// Get current parameters
let (value, fvalue) = try mpg.getParameter(.flags)
```

#### Feature Detection

```swift
// Check if features are available
if MPG123.hasFeature(.equalizer) {
    print("Equalizer is available")
}

if MPG123.hasFeature(.decodeLayer3) {
    print("MP3 decoding is available")
}

// Get library version
let version = MPG123.version()
print("mpg123 version: \(version.major).\(version.minor).\(version.patch)")
```

#### Equalizer Control

```swift
let mpg = try MPG123()

// Set equalizer for left channel, band 0 (lowest frequency)
try mpg.setEqualizer(channel: 0, band: 0, value: 0.5)

// Get equalizer value
let eqValue = mpg.getEqualizer(channel: 0, band: 0)

// Reset equalizer to flat response
try mpg.resetEqualizer()
```

#### Volume Control

```swift
let mpg = try MPG123()

// Set volume (0.0 = mute, 1.0 = normal, >1.0 = amplification)
try mpg.setVolume(0.8)

// Change volume by factor
try mpg.changeVolume(1.5) // 50% louder

// Change volume by decibels
try mpg.changeVolumeDB(-6.0) // Reduce by 6dB

// Get current volume information
let (base, really, rvaDb) = try mpg.getVolume()
```

#### Frame-by-Frame Decoding

```swift
let mpg = try MPG123()
try mpg.open(path: "/path/to/audio.mp3")

// Decode frames with detailed information
while let frame = try mpg.decodeFrame() {
    print("Frame \(frame.frameNumber): \(frame.audioData.count) bytes")
    print("  Bitrate: \(frame.frameInfo.bitrate) kbps")
    print("  Sample rate: \(frame.frameInfo.rate) Hz")
    
    // Process frame.audioData...
}
```

#### Feed Mode for Streaming

```swift
let mpg = try MPG123()

// Open feed mode for direct data feeding
try mpg.openFeed()

// Feed MP3 data (e.g., from network stream)
let mp3Data = // ... get MP3 data from somewhere
try mpg.feed(mp3Data)

// Decode frames as they become available
while let frame = try mpg.decodeFrame() {
    // Process decoded audio...
}

mpg.close()
```

#### Audio Streaming Interface

```swift
let mpg = try MPG123()
try mpg.open(path: "/path/to/audio.mp3")

// Create audio stream with 4KB chunks
let audioStream = mpg.stream(chunkSize: 4096)

// Process audio in chunks
for chunk in audioStream {
    // Process chunk of audio data...
    processAudio(chunk)
}
```

#### Seeking and Positioning

```swift
let mpg = try MPG123()
try mpg.open(path: "/path/to/audio.mp3")

// Seek to specific time (in seconds)
let sampleOffset = try mpg.seekToTime(seconds: 30.0)

// Seek to specific frame
let frameOffset = try mpg.seekFrame(to: 1000)

// Get current position
let currentSample = try mpg.tell()
let currentFrame = try mpg.tellFrame()

// Get total length
let totalSamples = try mpg.length()
let totalFrames = try mpg.frameLength()
```

#### Format Support Checking

```swift
let mpg = try MPG123()

// Check if specific format is supported
let support16Bit = mpg.formatSupport(rate: 44100, encoding: 0x10) // MPG123_ENC_SIGNED16
if support16Bit != 0 {
    print("16-bit 44.1kHz is supported")
}

// Configure output format
try mpg.setOutputFormat(rate: 44100, channels: 2, encoding: 0x10)
```

### Error Handling

The package provides comprehensive error handling with detailed error types:

```swift
do {
    let mpg = try MPG123()
    try mpg.open(path: "/path/to/audio.mp3")
    // ... use mpg123
} catch MPG123Error.initializationFailed {
    print("Failed to initialize mpg123 library")
} catch MPG123Error.openFailed {
    print("Failed to open MP3 file")
} catch MPG123Error.readFailed {
    print("Failed to read audio data")
} catch MPG123Error.seekFailed {
    print("Failed to seek in audio stream")
} catch MPG123Error.parameterError {
    print("Parameter error")
} catch MPG123Error.featureNotAvailable {
    print("Feature not available in this build")
} catch {
    print("Other error: \(error)")
}
```

## API Reference

### Core Classes

#### MPG123

Main class for MP3 decoding operations.

**Initialization:**
```swift
init() throws
```

**Static Methods:**
```swift
static func version() -> (major: UInt, minor: UInt, patch: UInt)
static func hasFeature(_ feature: MPG123Feature) -> Bool
```

**File Operations:**
```swift
func open(path: String) throws
func openFeed() throws
func close()
func feed(_ data: Data) throws
```

**Audio Information:**
```swift
var sampleRate: Int32
var channels: Int32
var encoding: Int32
```

**Data Reading:**
```swift
func read() throws -> Data
func read(into buffer: UnsafeMutablePointer<UInt8>, size: Int) throws -> Int
func readChunked(size: Int) throws -> Data
func decodeFrame() throws -> (frameNumber: Int64, audioData: Data, frameInfo: MPG123FrameInfo)?
```

**Seeking and Positioning:**
```swift
func seek(to offset: Int64, whence: Int32) throws -> Int64
func seekFrame(to frameOffset: Int64, whence: Int32) throws -> Int64
func seekToTime(seconds: Double) throws -> Int64
func tell() throws -> Int64
func tellFrame() throws -> Int64
func length() throws -> Int64
func frameLength() throws -> Int64
```

**Format Configuration:**
```swift
func setOutputFormat(rate: Int, channels: Int, encoding: Int) throws
func formatSupport(rate: Int, encoding: Int) -> Int32
```

**Parameter Management:**
```swift
func setParameter(_ param: MPG123Param, value: Int32, fvalue: Double) throws
func getParameter(_ param: MPG123Param) throws -> (value: Int32, fvalue: Double)
```

**Equalizer Control:**
```swift
func setEqualizer(channel: Int32, band: Int32, value: Double) throws
func getEqualizer(channel: Int32, band: Int32) -> Double
func resetEqualizer() throws
```

**Volume Control:**
```swift
func setVolume(_ volume: Double) throws
func changeVolume(_ change: Double) throws
func changeVolumeDB(_ db: Double) throws
func getVolume() throws -> (base: Double, really: Double, rvaDb: Double)
```

**Metadata:**
```swift
func metadata() -> [String: String]
```

**Streaming:**
```swift
func stream(chunkSize: Int) -> AudioStream
```

### Enums and Types

#### MPG123Error
Comprehensive error types for all mpg123 operations.

#### MPG123Param
Parameter types for configuration:
- `verbose`, `flags`, `addFlags`, `forceRate`, `downSample`
- `rva`, `downSpeed`, `upSpeed`, `startFrame`, `decodeFrames`
- `icyInterval`, `outScale`, `timeout`, `removeFlags`
- `resyncLimit`, `indexSize`, `preframes`, `feedPool`, `feedBuffer`, `freeformatSize`

#### MPG123Flag
Parameter flags:
- `forceMono`, `monoLeft`, `monoRight`, `monoMix`, `forceStereo`
- `force8Bit`, `quiet`, `gapless`, `noResync`, `seekBuffer`
- `fuzzy`, `forceFloat`, `plainId3Text`, `ignoreStreamLength`
- `skipId3v2`, `ignoreInfoFrame`, `autoResample`, `picture`
- `noPeekEnd`, `forceSeekable`, `storeRawId3`, `forceEndian`
- `bigEndian`, `noReadahead`, `floatFallback`, `noFrankenstein`

#### MPG123RVA
ReplayGain modes:
- `off`, `mix`, `album`

#### MPG123Feature
Available features:
- `abiUtf8Open`, `output8Bit`, `output16Bit`, `output32Bit`
- `index`, `parseId3v2`, `decodeLayer1`, `decodeLayer2`, `decodeLayer3`
- `decodeAccurate`, `decodeDownsample`, `decodeNtom`, `parseIcy`
- `timeoutRead`, `equalizer`, `moreInfo`, `outputFloat32`, `outputFloat64`

#### MPG123FrameInfo
Frame information structure containing:
- `version`, `layer`, `rate`, `mode`, `modeExt`
- `frameSize`, `flags`, `emphasis`, `bitrate`, `abrRate`, `vbr`

#### MPG123.AudioStream
Swift Sequence for streaming audio data.

## Development

### Building from Source

1. Ensure mpg123 is installed:
```bash
brew install mpg123
```

2. Clone and build:
```bash
git clone https://github.com/yourusername/swift-mpg123.git
cd swift-mpg123
swift build
```

3. Run tests:
```bash
swift test
```

### Troubleshooting

#### Common Build Issues

1. **"Cannot find mpg123 library"**
   - This package embeds mpg123 directly, so no system installation is needed
   - If you see this error, it may be from an old version that required system mpg123

2. **Type conversion errors**
   - The package handles C/Swift interop automatically
   - Ensure you're using the provided Swift API, not calling C functions directly

3. **Platform-specific issues**
   - The embedded mpg123 library is configured for macOS, Linux, and Windows
   - If you encounter platform-specific issues, please report them

#### Platform Support

Currently supports:
- ✅ macOS 12.0+

Future support planned:
- iOS 15.0+
- tvOS 15.0+
- watchOS 8.0+

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass: `swift test`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

**Note:** This package includes the [mpg123](https://www.mpg123.de/) library, which is licensed under the GNU Lesser General Public License v2.1 (LGPL-2.1). The embedded mpg123 source code and its modifications are subject to the LGPL-2.1 license terms.

By using this package, you agree to the terms of both licenses. See the LICENSE file for the complete LGPL-2.1 text and AUTHORS file for mpg123 contributors.

## Acknowledgments

- [mpg123](https://www.mpg123.de/) - The underlying C library for MP3 decoding
- Swift Package Manager for the build system
- Homebrew for package management 
