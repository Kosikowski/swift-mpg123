//
//  MPG123AudioStream.swift
//
//  Created by Mateusz Kosikowski, PhD on 11/01/2020.
//
import Foundation

public extension MPG123 {
    /// A streaming interface that produces chunks of decoded audio data.
    struct AudioStream: Sequence, IteratorProtocol {
        private let mpg123Instance: MPG123
        private let chunkSize: Int
        private var isDone: Bool = false

        /// Initializes the audio stream sequence.
        /// - Parameters:
        ///   - mpg123Instance: The MPG123 instance to stream from.
        ///   - chunkSize: Size in bytes of each data chunk.
        public init(mpg123Instance: MPG123, chunkSize: Int) {
            self.mpg123Instance = mpg123Instance
            self.chunkSize = chunkSize
        }

        /// Produces the next chunk of decoded audio data.
        /// - Returns: A Data object containing the next chunk, or nil if the stream is finished.
        public mutating func next() -> Data? {
            if isDone { return nil }
            do {
                let chunk = try mpg123Instance.readChunked(size: chunkSize)
                if chunk.isEmpty {
                    isDone = true
                    return nil
                }
                return chunk
            } catch {
                isDone = true
                return nil
            }
        }
    }

    /// Creates an audio stream for sequential reading of decoded audio data.
    /// - Parameter chunkSize: Size in bytes of each data chunk.
    /// - Returns: An AudioStream sequence for iterating over audio data.
    func stream(chunkSize: Int = 4096) -> AudioStream {
        return AudioStream(mpg123Instance: self, chunkSize: chunkSize)
    }

    /// Reads all remaining audio data from the stream.
    /// - Returns: A Data object containing all remaining decoded audio bytes.
    /// - Throws: `MPG123Error.readFailed` if reading fails.
    func read() throws -> Data {
        var allData = Data()
        for chunk in stream() {
            allData.append(chunk)
        }
        return allData
    }

    /// Reads a chunk of decoded audio data of specified size.
    /// - Parameter size: The size in bytes of data to read.
    /// - Returns: A Data object containing the decoded audio bytes.
    /// - Throws: `MPG123Error.readFailed` if reading fails.
    func readChunked(size: Int) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: size)
        let bytesRead = try buffer.withUnsafeMutableBufferPointer { ptr -> Int in
            guard let baseAddress = ptr.baseAddress else { return 0 }
            return try read(into: baseAddress, size: size)
        }
        return Data(buffer[..<bytesRead])
    }
}
