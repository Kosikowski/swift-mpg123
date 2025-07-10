//
//  MPG123Types.swift
//
//  Created by Mateusz Kosikowski, PhD on 12/01/2020.
//
import Foundation
import mpg123

/// Custom error types for MPG123 operations.
public enum MPG123Error: Error {
    case initializationFailed
    case openFailed
    case readFailed
    case seekFailed
    case formatConfigurationFailed
    case parameterError
    case featureNotAvailable
    case invalidHandle
    case decoderError
    case bufferError
    case outOfMemory
    case badParameter
    case badChannel
    case badRate
    case badDecoder
    case noBuffers
    case badRVA
    case noGapless
    case noSpace
    case badTypes
    case badBand
    case nullPointer
    case readerError
    case noSeekFromEnd
    case badWhence
    case noTimeout
    case badFile
    case noSeek
    case noReader
    case badPars
    case badIndexParam
    case outOfSync
    case resyncFail
    case no8Bit
    case badAlign
    case nullBuffer
    case noRelSeek
    case badKey
    case noIndex
    case indexFail
    case badDecoderSetup
    case missingFeature
    case badValue
    case lseekFailed
    case badCustomIO
    case lfsOverflow
    case intOverflow
    case badFloat

    /// Get the error description from mpg123
    public var description: String {
        switch self {
        case .initializationFailed:
            return "Failed to initialize mpg123 library"
        case .openFailed:
            return "Failed to open MP3 file"
        case .readFailed:
            return "Failed to read audio data"
        case .seekFailed:
            return "Failed to seek in audio stream"
        case .formatConfigurationFailed:
            return "Failed to configure audio format"
        case .parameterError:
            return "Parameter error"
        case .featureNotAvailable:
            return "Feature not available in this build"
        case .invalidHandle:
            return "Invalid mpg123 handle"
        case .decoderError:
            return "Decoder error"
        case .bufferError:
            return "Buffer error"
        case .outOfMemory:
            return "Out of memory"
        case .badParameter:
            return "Bad parameter"
        case .badChannel:
            return "Invalid channel number"
        case .badRate:
            return "Invalid sample rate"
        case .badDecoder:
            return "Invalid decoder choice"
        case .noBuffers:
            return "Unable to initialize frame buffers"
        case .badRVA:
            return "Invalid RVA mode"
        case .noGapless:
            return "Gapless decoding not supported"
        case .noSpace:
            return "Not enough buffer space"
        case .badTypes:
            return "Incompatible numeric data types"
        case .badBand:
            return "Bad equalizer band"
        case .nullPointer:
            return "Null pointer given"
        case .readerError:
            return "Error reading the stream"
        case .noSeekFromEnd:
            return "Cannot seek from end"
        case .badWhence:
            return "Invalid whence for seek function"
        case .noTimeout:
            return "Timeout not supported"
        case .badFile:
            return "File access error"
        case .noSeek:
            return "Seek not supported by stream"
        case .noReader:
            return "No stream opened or no reader callback"
        case .badPars:
            return "Bad parameter handle"
        case .badIndexParam:
            return "Bad parameters to index functions"
        case .outOfSync:
            return "Lost track in bytestream"
        case .resyncFail:
            return "Resync failed to find valid MPEG data"
        case .no8Bit:
            return "No 8bit encoding possible"
        case .badAlign:
            return "Stack alignment error"
        case .nullBuffer:
            return "NULL input buffer with non-zero size"
        case .noRelSeek:
            return "Relative seek not possible"
        case .badKey:
            return "Bad key value"
        case .noIndex:
            return "No frame index in this build"
        case .indexFail:
            return "Frame index error"
        case .badDecoderSetup:
            return "Bad decoder setup"
        case .missingFeature:
            return "Feature not built into libmpg123"
        case .badValue:
            return "Bad value given"
        case .lseekFailed:
            return "Low-level seek failed"
        case .badCustomIO:
            return "Custom I/O not prepared"
        case .lfsOverflow:
            return "Offset value overflow"
        case .intOverflow:
            return "Integer overflow"
        case .badFloat:
            return "Floating-point computation error"
        }
    }
}

/// MPG123 parameter types
public enum MPG123Param: Int32 {
    case verbose = 0
    case flags = 1
    case addFlags = 2
    case forceRate = 3
    case downSample = 4
    case rva = 5
    case downSpeed = 6
    case upSpeed = 7
    case startFrame = 8
    case decodeFrames = 9
    case icyInterval = 10
    case outScale = 11
    case timeout = 12
    case removeFlags = 13
    case resyncLimit = 14
    case indexSize = 15
    case preframes = 16
    case feedPool = 17
    case feedBuffer = 18
    case freeformatSize = 19
}

/// MPG123 parameter flags
public enum MPG123Flag: Int32 {
    case forceMono = 0x7
    case monoLeft = 0x1
    case monoRight = 0x2
    case monoMix = 0x4
    case forceStereo = 0x8
    case force8Bit = 0x10
    case quiet = 0x20
    case gapless = 0x40
    case noResync = 0x80
    case seekBuffer = 0x100
    case fuzzy = 0x200
    case forceFloat = 0x400
    case plainId3Text = 0x800
    case ignoreStreamLength = 0x1000
    case skipId3v2 = 0x2000
    case ignoreInfoFrame = 0x4000
    case autoResample = 0x8000
    case picture = 0x10000
    case noPeekEnd = 0x20000
    case forceSeekable = 0x40000
    case storeRawId3 = 0x80000
    case forceEndian = 0x100000
    case bigEndian = 0x200000
    case noReadahead = 0x400000
    case floatFallback = 0x800000
    case noFrankenstein = 0x1000000
}

/// MPG123 RVA modes
public enum MPG123RVA: Int32 {
    case off = 0
    case mix = 1
    case album = 2
}

/// MPG123 feature set
public enum MPG123Feature: Int32 {
    case abiUtf8Open = 0
    case output8Bit = 1
    case output16Bit = 2
    case output32Bit = 3
    case index = 4
    case parseId3v2 = 5
    case decodeLayer1 = 6
    case decodeLayer2 = 7
    case decodeLayer3 = 8
    case decodeAccurate = 9
    case decodeDownsample = 10
    case decodeNtom = 11
    case parseIcy = 12
    case timeoutRead = 13
    case equalizer = 14
    case moreInfo = 15
    case outputFloat32 = 16
    case outputFloat64 = 17
}

/// ID3 tag keys used for metadata dictionary
public enum ID3Tag {
    public static let title = "title"
    public static let artist = "artist"
    public static let album = "album"
    public static let year = "year"
    public static let comment = "comment"
    public static let genre = "genre"
}

/// Frame information structure
public struct MPG123FrameInfo {
    public let version: Int32
    public let layer: Int32
    public let rate: Int
    public let mode: Int32
    public let modeExt: Int32
    public let frameSize: Int32
    public let flags: Int32
    public let emphasis: Int32
    public let bitrate: Int32
    public let abrRate: Int32
    public let vbr: Int32

    init(from mpg123Info: mpg123_frameinfo2) {
        version = mpg123Info.version
        layer = mpg123Info.layer
        rate = mpg123Info.rate
        mode = mpg123Info.mode
        modeExt = mpg123Info.mode_ext
        frameSize = mpg123Info.framesize
        flags = mpg123Info.flags
        emphasis = mpg123Info.emphasis
        bitrate = mpg123Info.bitrate
        abrRate = mpg123Info.abr_rate
        vbr = mpg123Info.vbr
    }
}
