//
//  MP3Player.swift
//
//  Created by Mateusz Kosikowski, PhD on 10/01/2020.
//

import AVFoundation
import Foundation
import SwiftMpg123

// MARK: - EqualizerPreset

/// Equalizer presets for the MP3 player demo
public enum EqualizerPreset {
    case flat
    case bassBoost
    case trebleBoost
    case vocalBoost
    case custom
    case veryLow
    case veryHigh
}

// MARK: - MP3Player

/// MP3 Player that uses SwiftMpg123 for decoding and AVAudioPlayerNode for playback
public class MP3Player: NSObject {
    // MARK: Properties

    private var audioEngine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var mpg123: MPG123?
    private var isPlaying = false
    private var audioBuffer: AVAudioPCMBuffer?

    // MARK: Lifecycle

    override public init() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        super.init()

        setupAudioEngine()
    }

    // MARK: Functions

    /// Play an MP3 file using SwiftMpg123 for decoding and AVAudioPlayerNode for playback
    /// - Parameter filePath: Path to the MP3 file
    public func play(filePath: String) {
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("Error: File does not exist at path: \(filePath)")
            return
        }

        do {
            // Initialize mpg123
            mpg123 = try MPG123()

            // Open the MP3 file
            try mpg123!.open(path: filePath)

            print("MP3 File Info:")
            print("  Sample Rate: \(mpg123!.sampleRate) Hz")
            print("  Channels: \(mpg123!.channels)")
            print("  Encoding: \(mpg123!.encoding)")

            // Get metadata
            let metadata = mpg123!.metadata()
            if !metadata.isEmpty {
                print("\nID3 Metadata:")
                let fields = [
                    ("Title", metadata["title"]),
                    ("Artist", metadata["artist"]),
                    ("Album", metadata["album"]),
                    ("Year", metadata["year"]),
                    ("Comment", metadata["comment"]),
                    ("Genre", metadata["genre"]),
                ]
                for (label, value) in fields where value != nil && !(value!.isEmpty) {
                    print("  \(label): \(value!)")
                }
            }

            // Setup equalizer if available
            setupEqualizer()

            // Decode the entire MP3 file
            let audioData = try decodeMP3File()

            // Create audio buffer and play
            try createAudioBuffer(from: audioData)
            playAudioBuffer()

        } catch {
            print("Error playing MP3 file: \(error)")
        }
    }

    /// Set equalizer band value
    /// - Parameters:
    ///   - channel: Channel to set (0 = left, 1 = right, 3 = both)
    ///   - band: Equalizer band (0-31)
    ///   - value: Equalizer value (-1.0 to 1.0)
    public func setEqualizer(channel: Int, band: Int, value: Float) {
        guard let mpg123 else { return }
        try? mpg123.setEqualizer(channel: Int32(channel), band: Int32(band), value: Double(value))
    }

    /// Get equalizer band value
    /// - Parameters:
    ///   - channel: Channel to get (0 = left, 1 = right, 3 = both)
    ///   - band: Equalizer band (0-31)
    /// - Returns: Equalizer value (-1.0 to 1.0)
    public func getEqualizer(channel: Int, band: Int) -> Float {
        guard let mpg123 else { return 0.0 }
        return Float(mpg123.getEqualizer(channel: Int32(channel), band: Int32(band)))
    }

    /// Reset equalizer to flat response
    public func resetEqualizer() {
        guard let mpg123 else { return }
        try? mpg123.resetEqualizer()
        print("Equalizer reset to flat response")
    }

    /// Apply a preset equalizer configuration
    /// - Parameter preset: The preset to apply
    public func applyEqualizerPreset(_ preset: EqualizerPreset) {
        guard let mpg123 else { return }

        switch preset {
            case .flat:
                resetEqualizer()

            case .bassBoost:
                // Bass boost preset
                for band in 0 ..< 8 {
                    let value = Double(band) * 0.1
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied bass boost preset")

            case .trebleBoost:
                // Treble boost preset
                for band in 24 ..< 32 {
                    let value = Double(32 - band) * 0.1
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied treble boost preset")

            case .vocalBoost:
                // Vocal boost preset (mid-range enhancement)
                for band in 8 ..< 16 {
                    let value = 0.2
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied vocal boost preset")

            case .custom:
                // Custom preset (example: treble boost)
                for band in 24 ..< 32 {
                    let value = Double(32 - band) * 0.1
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied custom preset (treble boost)")

            case .veryLow:
                // Very low equalizer preset
                for band in 0 ..< 32 {
                    let value = -0.9 // Very strong reduction
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied very low equalizer preset")

            case .veryHigh:
                // Very high equalizer preset
                for band in 0 ..< 32 {
                    let value = 0.9 // Very strong enhancement
                    try? mpg123.setEqualizer(channel: 0, band: Int32(band), value: value)
                    try? mpg123.setEqualizer(channel: 1, band: Int32(band), value: value)
                }
                print("Applied very high equalizer preset")
        }
    }

    /// Stop playback
    public func stop() {
        playerNode.stop()
        isPlaying = false
    }

    /// Pause playback
    public func pause() {
        playerNode.pause()
    }

    /// Resume playback
    public func resume() {
        playerNode.play()
    }

    private func setupAudioEngine() {
        // Add player node to audio engine
        audioEngine.attach(playerNode)

        // Connect player node to main mixer
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: nil)

        // Prepare the audio engine
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }

    /// Setup equalizer with some example presets
    private func setupEqualizer() {
        guard MPG123.hasFeature(.equalizer) else {
            print("Equalizer not available in this mpg123 build")
            return
        }

        print("Equalizer is available - user will choose preset from menu")
    }

    /// Decode the entire MP3 file into raw audio data
    /// - Returns: Raw audio data as Data
    /// - Throws: MPG123Error if decoding fails
    private func decodeMP3File() throws -> Data {
        guard let mpg123 else {
            throw MPG123Error.invalidHandle
        }

        var allAudioData = Data()

        // Read all audio data from the stream
        allAudioData = try mpg123.read()

        print("Decoded \(allAudioData.count) bytes of audio data")
        return allAudioData
    }

    /// Create an AVAudioPCMBuffer from raw audio data with support for multiple formats
    /// - Parameter audioData: Raw audio data
    /// - Throws: Error if buffer creation fails or encoding is not supported
    private func createAudioBuffer(from audioData: Data) throws {
        guard let mpg123 else {
            throw MPG123Error.invalidHandle
        }

        let sampleRate = Double(mpg123.sampleRate)
        let channels = Int(mpg123.channels)
        let encoding = mpg123.encoding

        print("Processing audio with encoding: 0x\(String(format: "%02X", encoding))")

        // Create standard float format for output
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: AVAudioChannelCount(channels))!
        let frameCount = try calculateFrameCount(audioData: audioData, encoding: encoding, channels: channels)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            throw NSError(domain: "MP3Player", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio buffer"])
        }
        buffer.frameLength = frameCount

        // Convert audio data based on encoding
        try convertAudioData(audioData: audioData, encoding: encoding, channels: channels, frameCount: frameCount, buffer: buffer)

        audioBuffer = buffer
        print("Created audio buffer with \(frameCount) frames")
    }

    /// Calculate frame count based on encoding and data size
    private func calculateFrameCount(audioData: Data, encoding: Int32, channels: Int) throws -> AVAudioFrameCount {
        let bytesPerSample = try getBytesPerSample(encoding: encoding)
        let frameCount = AVAudioFrameCount(audioData.count / (bytesPerSample * channels))
        return frameCount
    }

    /// Get bytes per sample for given encoding
    private func getBytesPerSample(encoding: Int32) throws -> Int {
        switch encoding {
            case 0x01,
                 0x02,
                 0x04,
                 0x08: // MPG123_ENC_UNSIGNED_8, SIGNED_8, ULAW_8, ALAW_8
                return 1

            case 0x60,
                 0xD0: // MPG123_ENC_UNSIGNED_16, SIGNED_16
                return 2

            case 0x6000,
                 0x5000: // MPG123_ENC_UNSIGNED_24, SIGNED_24
                return 3

            case 0x2000,
                 0x1100,
                 0x200: // MPG123_ENC_UNSIGNED_32, SIGNED_32, FLOAT_32
                return 4

            case 0x400: // MPG123_ENC_FLOAT_64
                return 8

            default:
                throw NSError(domain: "MP3Player", code: -3, userInfo: [NSLocalizedDescriptionKey: "Unsupported encoding: 0x\(String(format: "%02X", encoding))"])
        }
    }

    /// Convert audio data from various encodings to float
    private func convertAudioData(audioData: Data, encoding: Int32, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) throws {
        audioData.withUnsafeBytes { bytes in
            guard let baseAddress = bytes.baseAddress else { return }

            switch encoding {
                case 0x01: // MPG123_ENC_UNSIGNED_8
                    convertUnsigned8Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x02: // MPG123_ENC_SIGNED_8
                    convertSigned8Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x04: // MPG123_ENC_ULAW_8
                    convertULaw8Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x08: // MPG123_ENC_ALAW_8
                    convertALaw8Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x60: // MPG123_ENC_UNSIGNED_16
                    convertUnsigned16Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0xD0: // MPG123_ENC_SIGNED_16
                    convertSigned16Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x6000: // MPG123_ENC_UNSIGNED_24
                    convertUnsigned24Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x5000: // MPG123_ENC_SIGNED_24
                    convertSigned24Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x2000: // MPG123_ENC_UNSIGNED_32
                    convertUnsigned32Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x1100: // MPG123_ENC_SIGNED_32
                    convertSigned32Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x200: // MPG123_ENC_FLOAT_32
                    convertFloat32Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                case 0x400: // MPG123_ENC_FLOAT_64
                    convertFloat64Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)

                default:
                    print("Warning: Unknown encoding 0x\(String(format: "%02X", encoding)), treating as signed 16-bit")
                    convertSigned16Bit(baseAddress: baseAddress, channels: channels, frameCount: frameCount, buffer: buffer)
            }
        }
    }

    // MARK: - Format Conversion Methods

    private func convertUnsigned8Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceUInt8 = baseAddress.assumingMemoryBound(to: UInt8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceUInt8[frame * channels + channel]
                let floatValue = (Float(sample) - 128.0) / 128.0
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertSigned8Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceInt8 = baseAddress.assumingMemoryBound(to: Int8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceInt8[frame * channels + channel]
                let floatValue = Float(sample) / Float(Int8.max)
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertULaw8Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceUInt8 = baseAddress.assumingMemoryBound(to: UInt8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceUInt8[frame * channels + channel]
                let floatValue = convertULawToFloat(sample)
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertALaw8Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceUInt8 = baseAddress.assumingMemoryBound(to: UInt8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceUInt8[frame * channels + channel]
                let floatValue = convertALawToFloat(sample)
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertUnsigned16Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceUInt16 = baseAddress.assumingMemoryBound(to: UInt16.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceUInt16[frame * channels + channel]
                let floatValue = (Float(sample) - 32768.0) / 32768.0
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertSigned16Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceInt16 = baseAddress.assumingMemoryBound(to: Int16.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceInt16[frame * channels + channel]
                let floatValue = Float(sample) / Float(Int16.max)
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertUnsigned24Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceBytes = baseAddress.assumingMemoryBound(to: UInt8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let offset = (frame * channels + channel) * 3
                let sample = UInt32(sourceBytes[offset]) | (UInt32(sourceBytes[offset + 1]) << 8) | (UInt32(sourceBytes[offset + 2]) << 16)
                let floatValue = (Float(sample) - 8_388_608.0) / 8_388_608.0
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertSigned24Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceBytes = baseAddress.assumingMemoryBound(to: UInt8.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let offset = (frame * channels + channel) * 3
                let sample = UInt32(sourceBytes[offset]) | (UInt32(sourceBytes[offset + 1]) << 8) | (UInt32(sourceBytes[offset + 2]) << 16)
                let signedSample = Int32(sample) - (sample >= 0x800000 ? 0x1000000 : 0)
                let floatValue = Float(signedSample) / 8_388_608.0
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertUnsigned32Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceUInt32 = baseAddress.assumingMemoryBound(to: UInt32.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceUInt32[frame * channels + channel]
                let floatValue = (Float(sample) - 2_147_483_648.0) / 2_147_483_648.0
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertSigned32Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceInt32 = baseAddress.assumingMemoryBound(to: Int32.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceInt32[frame * channels + channel]
                let floatValue = Float(sample) / Float(Int32.max)
                buffer.floatChannelData?[channel][frame] = floatValue
            }
        }
    }

    private func convertFloat32Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceFloat = baseAddress.assumingMemoryBound(to: Float.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceFloat[frame * channels + channel]
                buffer.floatChannelData?[channel][frame] = sample
            }
        }
    }

    private func convertFloat64Bit(baseAddress: UnsafeRawPointer, channels: Int, frameCount: AVAudioFrameCount, buffer: AVAudioPCMBuffer) {
        let sourceDouble = baseAddress.assumingMemoryBound(to: Double.self)
        for frame in 0 ..< Int(frameCount) {
            for channel in 0 ..< channels {
                let sample = sourceDouble[frame * channels + channel]
                buffer.floatChannelData?[channel][frame] = Float(sample)
            }
        }
    }

    // MARK: - Helper Methods for Non-linear Encodings

    private func convertULawToFloat(_ sample: UInt8) -> Float {
        // μ-law to linear conversion
        let MULAW_BIAS = 33
        let MULAW_MAX = 32767

        let sign = Int((sample & 0x80) != 0 ? 1 : 0)
        let exponent = Int((sample & 0x70) >> 4)
        let mantissa = Int(sample & 0x0F)

        let quantization = mantissa << (exponent + 3)
        let bias = MULAW_BIAS << exponent
        let linear = (sign == 0 ? 1 : -1) * (quantization + bias)

        return Float(linear) / Float(MULAW_MAX)
    }

    private func convertALawToFloat(_ sample: UInt8) -> Float {
        // A-law to linear conversion
        let ALAW_BIAS = 33
        let ALAW_MAX = 32767

        let sign = Int((sample & 0x80) != 0 ? 1 : 0)
        let exponent = Int((sample & 0x70) >> 4)
        let mantissa = Int(sample & 0x0F)

        let quantization = mantissa << (exponent + 3)
        let bias = ALAW_BIAS << exponent
        let linear = (sign == 0 ? 1 : -1) * (quantization + bias)

        return Float(linear) / Float(ALAW_MAX)
    }

    /// Play the audio buffer using AVAudioPlayerNode
    private func playAudioBuffer() {
        guard let buffer = audioBuffer else {
            print("Error: No audio buffer to play")
            return
        }

        // Stop any current playback
        if isPlaying {
            playerNode.stop()
        }

        // Use a semaphore to wait for playback to finish
        let semaphore = DispatchSemaphore(value: 0)
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: {
            semaphore.signal()
            print("\nPlayback completed")
        })

        // Start playback
        playerNode.play()
        isPlaying = true

        print("Started playback...")

        // Progress bar setup
        let totalFrames = Int(buffer.frameLength)
        let barWidth = 40
        let updateInterval: TimeInterval = 0.05

        // Start a background thread to update the progress bar
        let progressQueue = DispatchQueue(label: "progress.bar.queue")
        var stopProgress = false
        let stopQueue = DispatchQueue(label: "progress.stop.queue")
        progressQueue.async {
            while true {
                var shouldStop = false
                stopQueue.sync { shouldStop = stopProgress }
                if shouldStop { break }
                let nodeTime = self.playerNode.lastRenderTime
                let playerTime = nodeTime.flatMap { self.playerNode.playerTime(forNodeTime: $0) }
                let currentFrame = playerTime?.sampleTime ?? 0
                let progress = min(max(Double(currentFrame) / Double(totalFrames), 0.0), 1.0)
                let filled = Int(progress * Double(barWidth))
                let empty = barWidth - filled
                let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: empty)
                let percent = Int(progress * 100)
                // Print the bar with carriage return to overwrite
                print("\r[\(bar)] \(percent)%", terminator: "")
                fflush(stdout)
                Thread.sleep(forTimeInterval: updateInterval)
            }
        }

        // Wait for playback to finish
        semaphore.wait()
        stopQueue.sync { stopProgress = true }
        // Print 100% bar at the end
        let bar = String(repeating: "█", count: barWidth)
        print("\r[\(bar)] 100%\n")
        isPlaying = false
    }
}
