#!/usr/bin/env swift

import Foundation

// Build script for SwiftMpg123 with platform-specific file inclusion
// Usage:
//   BUILD_MPG123_FOR_APPLE=1 swift scripts/build-platform.swift
//   BUILD_MPG123_FOR_LINUX=1 swift scripts/build-platform.swift
//   BUILD_MPG123_FOR_WINDOWS=1 swift scripts/build-platform.swift

let environment = ProcessInfo.processInfo.environment

// Determine target platform
var platform: String
if environment["BUILD_MPG123_FOR_APPLE"] == "1" {
    platform = "apple"
    print("Building for Apple (macOS/iOS)")
} else if environment["BUILD_MPG123_FOR_LINUX"] == "1" {
    platform = "linux"
    print("Building for Linux")
} else if environment["BUILD_MPG123_FOR_WINDOWS"] == "1" {
    platform = "windows"
    print("Building for Windows")
} else {
    platform = "apple"
    print("No platform specified, defaulting to Apple")
}

// Platform-specific files
let windowsFiles = [
    "src/win32_net.c",
    "src/net123_wininet.c",
    "src/win32_support.c",
    "src/term_win32.c",
    "src/net123_winhttp.c",
    "src/win32_support.h",
    "src/libout123/modules/win32.c",
    "src/libout123/modules/win32_wasapi.c",
]

let linuxFiles = [
    "src/libout123/modules/pulse.c",
    "src/libout123/modules/alsa.c",
    "src/libout123/modules/oss.c",
    "src/libout123/modules/tinyalsa.c",
    "src/libout123/modules/sndio.c",
    "src/libout123/modules/esd.c",
    "src/libout123/modules/nas.c",
    "src/libout123/modules/arts.c",
    "src/libout123/modules/jack.c",
]

let appleFiles = [
    "src/libout123/modules/coreaudio.c",
]

// Read Package.swift
guard let packageSwift = try? String(contentsOfFile: "Package.swift", encoding: .utf8) else {
    print("Error: Could not read Package.swift")
    exit(1)
}

var modifiedPackageSwift = packageSwift

// Function to comment/uncomment lines
func commentLine(_ file: String, in content: String) -> String {
    let lines = content.components(separatedBy: .newlines)
    var result: [String] = []

    for line in lines {
        if line.contains("\"\(file)\""), !line.contains("//") {
            // Comment out the line
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("\"\(file)\"") {
                result.append("                // \"\(file)\",")
            } else {
                result.append(line.replacingOccurrences(of: "\"\(file)\"", with: "// \"\(file)\""))
            }
        } else {
            result.append(line)
        }
    }

    return result.joined(separator: "\n")
}

func uncommentLine(_ file: String, in content: String) -> String {
    let lines = content.components(separatedBy: .newlines)
    var result: [String] = []

    for line in lines {
        if line.contains("// \"\(file)\"") {
            // Uncomment the line
            result.append(line.replacingOccurrences(of: "// \"\(file)\"", with: "\"\(file)\""))
        } else {
            result.append(line)
        }
    }

    return result.joined(separator: "\n")
}

// First, comment out all platform-specific files
print("Configuring excludes for \(platform)...")

for file in windowsFiles + linuxFiles + appleFiles {
    modifiedPackageSwift = commentLine(file, in: modifiedPackageSwift)
}

// Then uncomment files for the target platform
switch platform {
    case "apple":
        print("Including Apple-specific files...")
        for file in appleFiles {
            modifiedPackageSwift = uncommentLine(file, in: modifiedPackageSwift)
        }

    case "linux":
        print("Including Linux-specific files...")
        for file in linuxFiles {
            modifiedPackageSwift = uncommentLine(file, in: modifiedPackageSwift)
        }

    case "windows":
        print("Including Windows-specific files...")
        for file in windowsFiles {
            modifiedPackageSwift = uncommentLine(file, in: modifiedPackageSwift)
        }

    default:
        print("Unknown platform: \(platform)")
        exit(1)
}

// Write the modified Package.swift
do {
    try modifiedPackageSwift.write(toFile: "Package.swift", atomically: true, encoding: .utf8)
    print("Package.swift configured for \(platform) platform")
} catch {
    print("Error writing Package.swift: \(error)")
    exit(1)
}

// Build the package
print("Building with swift build...")
let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
process.arguments = ["build"]

do {
    try process.run()
    process.waitUntilExit()

    if process.terminationStatus == 0 {
        print("Build complete!")
    } else {
        print("Build failed with exit code: \(process.terminationStatus)")
        exit(Int32(process.terminationStatus))
    }
} catch {
    print("Error running swift build: \(error)")
    exit(1)
}
