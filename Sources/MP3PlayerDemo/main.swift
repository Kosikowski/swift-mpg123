//
//  main.swift
//
//  Created by Mateusz Kosikowski, PhD on 10/01/2020.
//

#if canImport(AVFoundation)
    import AVFoundation
    import Foundation
    import SwiftMpg123

    func promptForEqualizerPreset() -> EqualizerPreset? {
        print("\nChoose an equalizer preset:")
        print("  1. Flat (no EQ)")
        print("  2. Bass Boost")
        print("  3. Treble Boost")
        print("  4. Vocal Boost")
        print("  5. Custom")
        print("  6. Very Low (muffled sound)")
        print("  7. Very High (bright sound)")
        print("Enter choice [1-7]: ", terminator: "")
        guard let input = readLine(), let choice = Int(input) else { return .flat }
        switch choice {
            case 2: return .bassBoost
            case 3: return .trebleBoost
            case 4: return .vocalBoost
            case 5: return nil // Custom
            case 6: return .veryLow
            case 7: return .veryHigh
            default: return .flat
        }
    }

    func promptForCustomBands(player: MP3Player) {
        print("\nCustom Equalizer: Set band values (-1.0 to 1.0, Enter to skip)")
        for band in 0 ..< 5 {
            print("  Band \(band) (Left): ", terminator: "")
            if let input = readLine(), let value = Double(input) {
                player.setEqualizer(channel: 0, band: band, value: Float(value))
            }
            print("  Band \(band) (Right): ", terminator: "")
            if let input = readLine(), let value = Double(input) {
                player.setEqualizer(channel: 1, band: band, value: Float(value))
            }
        }
        print("Custom EQ applied to first 5 bands (use code to set more)")
    }

    func main() {
        let player = MP3Player()

        // Check if a file path was provided as command line argument
        if CommandLine.arguments.count > 1 {
            let filePath = CommandLine.arguments[1]

            print("🎵 SwiftMpg123 MP3 Player Demo")
            print("================================")

            // Check for equalizer feature
            if MPG123.hasFeature(.equalizer) {
                print("✅ Equalizer feature is available!")
                print("   You can choose a preset or set custom bands.")
                if let preset = promptForEqualizerPreset() {
                    player.applyEqualizerPreset(preset)
                } else {
                    player.resetEqualizer()
                    promptForCustomBands(player: player)
                }
            } else {
                print("⚠️  Equalizer feature not available in this mpg123 build")
            }

            print("\n🎧 Playing: \(filePath)")
            print("   (Press Ctrl+C to stop playback)")

            // Play the file
            player.play(filePath: filePath)

            // Showcase equalizer features if available
            if MPG123.hasFeature(.equalizer) {
                print("\n🎛️  Equalizer Showcase:")
                print("   The demo applied your chosen equalizer settings.")
                print("   You can modify the preset in the MP3Player.swift file.")

                // Demonstrate getting equalizer values
                print("\n📊 Current Equalizer Settings (first few bands):")
                for band in 0 ..< 5 {
                    let leftValue = player.getEqualizer(channel: 0, band: band)
                    let rightValue = player.getEqualizer(channel: 1, band: band)
                    print("   Band \(band): Left=\(String(format: "%.2f", leftValue)), Right=\(String(format: "%.2f", rightValue))")
                }
            }

        } else {
            print("🎵 SwiftMpg123 MP3 Player Demo")
            print("================================")
            print("Usage: MP3PlayerDemo <path-to-mp3-file>")
            print("Example: MP3PlayerDemo /path/to/song.mp3")
            print("\nFeatures:")
            print("  ✅ MP3 decoding with SwiftMpg123")
            print("  ✅ Audio playback with AVAudioPlayerNode")
            print("  ✅ Metadata extraction (ID3 tags)")
            print("  ✅ Multiple audio format support")
            if MPG123.hasFeature(.equalizer) {
                print("  ✅ 32-band equalizer with presets")
            }
            print("  ✅ Real-time audio processing")
        }
    }

#else
    func main() {
        print(" Demo project is only available of macOS. 💔")
    }
#endif

main()
