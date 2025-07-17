//
//  MPG123.swift
//
//  Created by Mateusz Kosikowski, PhD on 10/01/2020.
//

#if canImport(Darwin)
    import Darwin // For SEEK_SET, SEEK_CUR, SEEK_END
#elseif canImport(Glibc)
    import Glibc // For SEEK_SET, SEEK_CUR, SEEK_END
#endif
import cmpg123
import Foundation // For Data type

// MARK: - MPG123

/// A Swift wrapper for the mpg123 library, providing MP3 decoding functionality.
public class MPG123 {
    // MARK: Properties

    // Audio format properties
    public private(set) var sampleRate: Int32 = 0
    public private(set) var channels: Int32 = 0
    public private(set) var encoding: Int32 = 0

    private var handle: OpaquePointer?

    // MARK: Lifecycle

    /// Initializes a new MPG123 instance.
    /// - Throws: `MPG123Error.initializationFailed` if library or handle initialization fails.
    public init() throws {
        // Initialize the mpg123 library
        let initResult = mpg123_init()
        guard initResult == MPG123_OK.rawValue else {
            throw MPG123Error.initializationFailed
        }

        // Create a new mpg123 handle
        guard let h = mpg123_new(nil, nil) else {
            mpg123_exit()
            throw MPG123Error.initializationFailed
        }

        handle = h
    }

    deinit {
        if let h = handle {
            mpg123_delete(h)
            mpg123_exit()
        }
    }

    // MARK: Static Functions

    /// Check if a specific feature is available in the mpg123 build.
    /// - Parameter feature: The feature to check for.
    /// - Returns: True if the feature is available, false otherwise.
    public static func hasFeature(_ feature: MPG123Feature) -> Bool {
        mpg123_feature2(feature.rawValue) != 0
    }

    /// Get the library version information.
    /// - Returns: A tuple containing (major, minor, patch) version numbers.
    public static func version() -> (major: UInt, minor: UInt, patch: UInt) {
        var patch: UInt32 = 0
        let version = mpg123_libversion(&patch)
        let major = UInt((version >> 16) & 0xFF)
        let minor = UInt((version >> 8) & 0xFF)
        let patchValue = UInt(patch)
        return (major: major, minor: minor, patch: patchValue)
    }

    // MARK: Functions

    /// Set a parameter on the mpg123 handle.
    /// - Parameters:
    ///   - param: The parameter to set.
    ///   - value: The integer value for the parameter.
    ///   - fvalue: The floating point value for the parameter (default 0.0).
    /// - Throws: `MPG123Error.parameterError` if setting the parameter fails.
    public func setParameter(_ param: MPG123Param, value: Int, fvalue: Double = 0.0) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_param2(h, param.rawValue, value, fvalue)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Get a parameter from the mpg123 handle.
    /// - Parameter param: The parameter to get.
    /// - Returns: A tuple containing (value, fvalue) for the parameter.
    /// - Throws: `MPG123Error.parameterError` if getting the parameter fails.
    public func getParameter(_ param: MPG123Param) throws -> (value: Int, fvalue: Double) {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        var value = 0
        var fvalue = 0.0
        let result = mpg123_getparam2(h, param.rawValue, &value, &fvalue)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
        return (value: value, fvalue: fvalue)
    }

    /// Opens an MP3 file for decoding.
    /// - Parameter path: File system path to the MP3 file.
    /// - Throws: `MPG123Error.openFailed` if the file cannot be opened.
    public func open(path: String) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_open(h, path)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.openFailed
        }

        // Retrieve audio format info
        var rate = 0
        var ch: Int32 = 0
        var enc: Int32 = 0
        mpg123_getformat(h, &rate, &ch, &enc)
        sampleRate = Int32(rate)
        channels = ch
        encoding = enc

        // Configure output format for consistency
        let clearResult = mpg123_format_none(h)
        guard clearResult == MPG123_OK.rawValue else {
            throw MPG123Error.formatConfigurationFailed
        }
        let setResult = mpg123_format(h, rate, ch, enc)
        guard setResult == MPG123_OK.rawValue else {
            throw MPG123Error.formatConfigurationFailed
        }
    }

    /// Opens a feed stream for direct feeding of MP3 data.
    /// - Throws: `MPG123Error.openFailed` if opening the feed stream fails.
    public func openFeed() throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_open_feed(h)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.openFailed
        }
    }

    /// Feed data to a feed stream.
    /// - Parameter data: The MP3 data to feed.
    /// - Throws: `MPG123Error.readFailed` if feeding fails.
    public func feed(_ data: Data) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = data.withUnsafeBytes { bytes in
            mpg123_feed(h, bytes.bindMemory(to: UInt8.self).baseAddress, data.count)
        }
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.readFailed
        }
    }

    /// Closes the currently opened MP3 stream.
    public func close() {
        if let h = handle {
            mpg123_close(h)
            sampleRate = 0
            channels = 0
            encoding = 0
        }
    }

    /// Reads decoded audio data into the provided buffer.
    /// - Parameter buffer: The buffer to fill with decoded audio bytes.
    /// - Returns: The number of bytes actually read.
    /// - Throws: `MPG123Error.readFailed` if reading fails.
    public func read(into buffer: UnsafeMutablePointer<UInt8>, size: Int) throws -> Int {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        var bytesRead = 0
        let result = mpg123_read(h, buffer, size, &bytesRead)
        guard result == MPG123_OK.rawValue || result == MPG123_DONE.rawValue else {
            throw MPG123Error.readFailed
        }
        return bytesRead
    }

    /// Decode a frame and get frame information.
    /// - Returns: A tuple containing (frameNumber, audioData, frameInfo) or nil if no more frames.
    /// - Throws: `MPG123Error.readFailed` if decoding fails.
    public func decodeFrame() throws -> (frameNumber: Int64, audioData: Data, frameInfo: MPG123FrameInfo)? {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        var frameNumber: Int64 = 0
        var audioData: UnsafeMutablePointer<UInt8>?
        var bytes = 0

        let result = mpg123_decode_frame64(h, &frameNumber, &audioData, &bytes)

        switch result {
            case MPG123_OK.rawValue:
                guard let audio = audioData else { return nil }
                let data = Data(bytes: audio, count: bytes)
                var frameInfo = mpg123_frameinfo2()
                let infoResult = mpg123_info2(h, &frameInfo)
                if infoResult == MPG123_OK.rawValue {
                    return (frameNumber: frameNumber, audioData: data, frameInfo: MPG123FrameInfo(from: frameInfo))
                } else {
                    return (frameNumber: frameNumber, audioData: data, frameInfo: MPG123FrameInfo(from: frameInfo))
                }

            case MPG123_DONE.rawValue:
                return nil

            case MPG123_NEED_MORE.rawValue:
                return nil

            default:
                throw MPG123Error.readFailed
        }
    }

    /// Seeks to a given sample offset in the audio stream.
    /// - Parameters:
    ///   - offset: Sample offset to seek to.
    ///   - whence: Positioning mode (SEEK_SET, SEEK_CUR, SEEK_END).
    /// - Returns: The resulting sample offset after seeking.
    /// - Throws: `MPG123Error.seekFailed` if seeking fails.
    public func seek(to offset: Int64, whence: Int32 = Int32(SEEK_SET)) throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_seek64(h, offset, whence)
        if result < 0 {
            throw MPG123Error.seekFailed
        }
        return Int64(result)
    }

    /// Seeks to a specific frame in the audio stream.
    /// - Parameters:
    ///   - frameOffset: Frame offset to seek to.
    ///   - whence: Positioning mode (SEEK_SET, SEEK_CUR, SEEK_END).
    /// - Returns: The resulting frame offset after seeking.
    /// - Throws: `MPG123Error.seekFailed` if seeking fails.
    public func seekFrame(to frameOffset: Int64, whence: Int32 = Int32(SEEK_SET)) throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_seek_frame64(h, frameOffset, whence)
        if result < 0 {
            throw MPG123Error.seekFailed
        }
        return Int64(result)
    }

    /// Get the current position in the audio stream.
    /// - Returns: The current sample offset.
    /// - Throws: `MPG123Error.seekFailed` if getting position fails.
    public func tell() throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_tell64(h)
        if result < 0 {
            throw MPG123Error.seekFailed
        }
        return Int64(result)
    }

    /// Get the current frame position in the audio stream.
    /// - Returns: The current frame offset.
    /// - Throws: `MPG123Error.seekFailed` if getting position fails.
    public func tellFrame() throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_tellframe64(h)
        if result < 0 {
            throw MPG123Error.seekFailed
        }
        return Int64(result)
    }

    /// Get the total length of the audio stream in samples.
    /// - Returns: The total number of samples, or -1 if unknown.
    /// - Throws: `MPG123Error.seekFailed` if getting length fails.
    public func length() throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_length64(h)
        return Int64(result)
    }

    /// Get the total length of the audio stream in frames.
    /// - Returns: The total number of frames, or -1 if unknown.
    /// - Throws: `MPG123Error.seekFailed` if getting length fails.
    public func frameLength() throws -> Int64 {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_framelength64(h)
        return Int64(result)
    }

    /// Configures the output format for decoding.
    /// - Parameters:
    ///   - rate: Desired sample rate.
    ///   - channels: Desired number of channels.
    ///   - encoding: Desired encoding format.
    /// - Throws: `MPG123Error.formatConfigurationFailed` if format configuration fails.
    public func setOutputFormat(rate: Int, channels: Int, encoding: Int) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let clearResult = mpg123_format_none(h)
        guard clearResult == MPG123_OK.rawValue else {
            throw MPG123Error.formatConfigurationFailed
        }
        let setResult = mpg123_format(h, rate, Int32(channels), Int32(encoding))
        guard setResult == MPG123_OK.rawValue else {
            throw MPG123Error.formatConfigurationFailed
        }
        // Update local format info after setting output format
        sampleRate = Int32(rate)
        self.channels = Int32(channels)
        self.encoding = Int32(encoding)
    }

    /// Check if a specific format is supported.
    /// - Parameters:
    ///   - rate: Sample rate to check.
    ///   - encoding: Encoding to check.
    /// - Returns: The supported channel configuration (0 = not supported).
    public func formatSupport(rate: Int, encoding: Int32) -> Int32 {
        guard let h = handle else { return 0 }
        return mpg123_format_support(h, rate, encoding)
    }

    /// Set equalizer band value.
    /// - Parameters:
    ///   - channel: Channel to set (0 = left, 1 = right, 3 = both).
    ///   - band: Equalizer band (0-31).
    ///   - value: Equalizer value (-1.0 to 1.0).
    /// - Throws: `MPG123Error.parameterError` if setting equalizer fails.
    public func setEqualizer(channel: Int32, band: Int32, value: Double) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_eq2(h, channel, band, value)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Get equalizer band value.
    /// - Parameters:
    ///   - channel: Channel to get (0 = left, 1 = right).
    ///   - band: Equalizer band (0-31).
    /// - Returns: The equalizer value for the band.
    public func getEqualizer(channel: Int32, band: Int32) -> Double {
        guard let h = handle else { return 0.0 }
        return mpg123_geteq2(h, channel, band)
    }

    /// Reset equalizer to flat response.
    /// - Throws: `MPG123Error.parameterError` if resetting fails.
    public func resetEqualizer() throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_reset_eq(h)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Set volume level.
    /// - Parameter volume: Volume level (0.0 = mute, 1.0 = normal, >1.0 = amplification).
    /// - Throws: `MPG123Error.parameterError` if setting volume fails.
    public func setVolume(_ volume: Double) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_volume(h, volume)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Change volume by a relative amount.
    /// - Parameter change: Volume change factor (e.g., 1.5 = 50% louder).
    /// - Throws: `MPG123Error.parameterError` if changing volume fails.
    public func changeVolume(_ change: Double) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_volume_change(h, change)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Change volume by decibels.
    /// - Parameter db: Volume change in decibels.
    /// - Throws: `MPG123Error.parameterError` if changing volume fails.
    public func changeVolumeDB(_ db: Double) throws {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        let result = mpg123_volume_change_db(h, db)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
    }

    /// Get current volume information.
    /// - Returns: A tuple containing (base, really, rva_db) volume values.
    /// - Throws: `MPG123Error.parameterError` if getting volume fails.
    public func getVolume() throws -> (base: Double, really: Double, rvaDb: Double) {
        guard let h = handle else { throw MPG123Error.invalidHandle }
        var base = 0.0
        var really = 0.0
        var rvaDb = 0.0
        let result = mpg123_getvolume(h, &base, &really, &rvaDb)
        guard result == MPG123_OK.rawValue else {
            throw MPG123Error.parameterError
        }
        return (base: base, really: really, rvaDb: rvaDb)
    }

    /// Seeks to a time offset (in seconds) in the audio stream and returns the actual sample offset.
    /// - Parameter seconds: The time position (in seconds) to seek to.
    /// - Returns: The resulting sample offset after seeking.
    /// - Throws: `MPG123Error.seekFailed` if seeking fails or format is unknown.
    public func seekToTime(seconds: Double) throws -> Int64 {
        guard sampleRate > 0 else {
            throw MPG123Error.seekFailed
        }
        let sampleOffset = Int64(Double(sampleRate) * seconds)
        return try seek(to: sampleOffset)
    }

    /// Retrieves textual metadata from the MP3 stream (ID3v1/ID3v2 tags).
    /// - Returns: A dictionary of common metadata fields if available.
    public func metadata() -> [String: String] {
        guard let h = handle else { return [:] }
        var result: [String: String] = [:]
        var meta: UnsafeMutablePointer<mpg123_id3v2>?
        var id3v1: UnsafeMutablePointer<mpg123_id3v1>?
        let tagType = mpg123_id3(h, &id3v1, &meta)
        // Helper to convert fixed-size C array to String
        func cArrayToString<T>(_ array: T) -> String? {
            withUnsafePointer(to: array) {
                $0.withMemoryRebound(to: CChar.self, capacity: MemoryLayout<T>.size) {
                    let buffer = UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size)
                    if let nulIndex = buffer.firstIndex(of: 0) {
                        return String(decoding: buffer.prefix(upTo: nulIndex).map { UInt8(bitPattern: $0) }, as: UTF8.self)
                    } else {
                        return String(decoding: buffer.map { UInt8(bitPattern: $0) }, as: UTF8.self)
                    }
                }
            }
        }
        if tagType & 2 != 0, let tag = meta?.pointee { // ID3v2
            if let title = cArrayToString(tag.title) { result[ID3Tag.title] = title }
            if let artist = cArrayToString(tag.artist) { result[ID3Tag.artist] = artist }
            if let album = cArrayToString(tag.album) { result[ID3Tag.album] = album }
            if let year = cArrayToString(tag.year) { result[ID3Tag.year] = year }
            if let comment = cArrayToString(tag.comment) { result[ID3Tag.comment] = comment }
            if let genre = cArrayToString(tag.genre) { result[ID3Tag.genre] = genre }
        }
        if tagType & 1 != 0, let tag = id3v1?.pointee { // ID3v1
            if result[ID3Tag.title] == nil, let title = cArrayToString(tag.title) { result[ID3Tag.title] = title }
            if result[ID3Tag.artist] == nil, let artist = cArrayToString(tag.artist) { result[ID3Tag.artist] = artist }
            if result[ID3Tag.album] == nil, let album = cArrayToString(tag.album) { result[ID3Tag.album] = album }
            if result[ID3Tag.year] == nil, let year = cArrayToString(tag.year) { result[ID3Tag.year] = year }
            if result[ID3Tag.comment] == nil, let comment = cArrayToString(tag.comment) { result[ID3Tag.comment] = comment }
            if result[ID3Tag.genre] == nil, let genre = cArrayToString(tag.genre) { result[ID3Tag.genre] = genre }
        }
        return result
    }
}
