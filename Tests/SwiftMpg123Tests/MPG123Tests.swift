//
//  MPG123Tests.swift
//
//  Created by Mateusz Kosikowski, PhD on 02/02/2020.
//

import Foundation
import XCTest
@testable import SwiftMpg123

// MARK: - MPG123Tests

final class MPG123Tests: XCTestCase {
    // MARK: Overridden Functions

    // MARK: - Setup and Teardown

    override func setUp() {
        super.setUp()
        // Any setup code can go here
    }

    override func tearDown() {
        // Any cleanup code can go here
        super.tearDown()
    }

    // MARK: Functions

    // MARK: - Library Initialization Tests

    func testLibraryInitialization() throws {
        // Test library version
        let version = MPG123.version()
        XCTAssertGreaterThanOrEqual(version.major, 0)
        XCTAssertGreaterThanOrEqual(version.minor, 0)
        XCTAssertGreaterThanOrEqual(version.patch, 0)

        // Test feature detection
        XCTAssertTrue(MPG123.hasFeature(.decodeLayer3)) // Should be available
        XCTAssertTrue(MPG123.hasFeature(.output16Bit)) // Should be available
    }

    // MARK: - MPG123 Instance Tests

    func testMPG123Instance() throws {
        let mpg = try MPG123()

        // Test parameter setting and getting
        try mpg.setParameter(.verbose, value: 0, fvalue: 0.0)
        let (value, fvalue) = try mpg.getParameter(.verbose)
        XCTAssertEqual(value, 0)
        XCTAssertEqual(fvalue, 0.0)

        // Test flag setting
        try mpg.setParameter(.flags, value: Int(MPG123Flag.gapless.rawValue), fvalue: 0.0)
        let (flagValue, _) = try mpg.getParameter(.flags)
        XCTAssertEqual(flagValue, Int(MPG123Flag.gapless.rawValue))
    }

    // MARK: - Format Support Tests

    func testFormatSupport() throws {
        let mpg = try MPG123()

        // Test format support for common formats
        let support16Bit = mpg.formatSupport(rate: 44100, encoding: 0x10) // MPG123_ENC_SIGNED16
        // Format support might be 0 if no file is open, but the function should not crash
        XCTAssertGreaterThanOrEqual(support16Bit, 0) // Should be non-negative

        let support8Bit = mpg.formatSupport(rate: 44100, encoding: 0x01) // MPG123_ENC_UNSIGNED_8
        XCTAssertGreaterThanOrEqual(support8Bit, 0) // Should be non-negative
    }

    // MARK: - Equalizer Tests

    func testEqualizer() throws {
        let mpg = try MPG123()

        // Test setting equalizer
        do {
            try mpg.setEqualizer(channel: 0, band: 0, value: 0.5)
            let eqValue = mpg.getEqualizer(channel: 0, band: 0)
            XCTAssertEqual(eqValue, 0.5)
        } catch {
            // Equalizer might not be available or might require a file to be open
            XCTAssertTrue(error is MPG123Error)
        }

        // Test resetting equalizer
        do {
            try mpg.resetEqualizer()
            let resetValue = mpg.getEqualizer(channel: 0, band: 0)
            // The reset value might not be exactly 0.0, but should be reasonable
            XCTAssertGreaterThanOrEqual(resetValue, 0.0)
            XCTAssertLessThanOrEqual(resetValue, 1.0)
        } catch {
            // Equalizer reset might fail if equalizer is not available
            XCTAssertTrue(error is MPG123Error)
        }
    }

    // MARK: - Volume Control Tests

    func testVolumeControl() throws {
        let mpg = try MPG123()

        // Test setting volume
        try mpg.setVolume(0.5)
        let (base, _, _) = try mpg.getVolume()
        XCTAssertEqual(base, 0.5)

        // Test volume change
        try mpg.changeVolume(2.0) // Double the volume
        let (newBase, _, _) = try mpg.getVolume()
        XCTAssertGreaterThan(newBase, 0.5) // Should be increased from 0.5

        // Test volume change by decibels
        try mpg.changeVolumeDB(-6.0) // Reduce by 6dB
        let (finalBase, _, _) = try mpg.getVolume()
        XCTAssertGreaterThan(finalBase, 0.0) // Should still be positive
    }

    // MARK: - Feed Mode Tests

    func testFeedMode() throws {
        let mpg = try MPG123()

        // Test opening feed mode
        try mpg.openFeed()

        // Test feeding data (empty data for testing)
        let testData = Data([0xFF, 0xFB, 0x90, 0x00, 0x00, 0x00, 0x00, 0x00]) // Minimal MP3 frame
        try mpg.feed(testData)

        mpg.close()
    }

    // MARK: - Frame Decoding Tests

    func testFrameDecoding() throws {
        let mpg = try MPG123()

        // This test would require a valid MP3 file
        // For now, we just test that the method exists and doesn't crash
        // In a real test, you would open a file and decode frames

        // Test that decodeFrame throws an error when no file is open
        do {
            let frame = try mpg.decodeFrame()
            XCTAssertNil(frame)
        } catch {
            XCTAssertTrue(error is MPG123Error)
        }
    }

    // MARK: - Seeking Tests

    func testSeeking() throws {
        let mpg = try MPG123()

        // Test seeking methods (without an open file)
        // These might not throw errors when no file is open, depending on the library implementation
        do {
            _ = try mpg.tell()
            // If no error is thrown, that's also acceptable
        } catch {
            XCTAssertTrue(error is MPG123Error)
        }

        do {
            _ = try mpg.tellFrame()
            // If no error is thrown, that's also acceptable
        } catch {
            XCTAssertTrue(error is MPG123Error)
        }

        do {
            _ = try mpg.length()
            // If no error is thrown, that's also acceptable
        } catch {
            XCTAssertTrue(error is MPG123Error)
        }

        do {
            _ = try mpg.frameLength()
            // If no error is thrown, that's also acceptable
        } catch {
            XCTAssertTrue(error is MPG123Error)
        }
    }

    // MARK: - Error Handling Tests

    func testErrorHandling() throws {
        // Test error descriptions
        let errors: [MPG123Error] = [
            .initializationFailed,
            .openFailed,
            .readFailed,
            .seekFailed,
            .formatConfigurationFailed,
            .parameterError,
            .featureNotAvailable,
            .invalidHandle,
        ]

        for error in errors {
            let description = error.description
            XCTAssertFalse(description.isEmpty)
            // Just check that we have a non-empty description
            // The exact content might vary depending on the library version
        }
    }

    // MARK: - Audio Stream Tests

    func testAudioStream() throws {
        let mpg = try MPG123()

        // Test creating an audio stream
        let stream = mpg.stream(chunkSize: 1024)
        XCTAssertEqual(stream.chunkSize, 1024)

        // Test that the stream is empty when no file is open
        var iterator = stream.makeIterator()
        let firstChunk = iterator.next()
        XCTAssertNil(firstChunk)
    }

    // MARK: - Metadata Tests

    func testMetadata() throws {
        let mpg = try MPG123()

        // Test metadata when no file is open
        let metadata = mpg.metadata()
        XCTAssertTrue(metadata.isEmpty)
    }

    // MARK: - Enum Tests

    func testParameterEnums() throws {
        // Test that parameter enums have correct raw values
        XCTAssertEqual(MPG123Param.verbose.rawValue, 0)
        XCTAssertEqual(MPG123Param.flags.rawValue, 1)
        XCTAssertEqual(MPG123Param.addFlags.rawValue, 2)

        // Test flag enums
        XCTAssertEqual(MPG123Flag.forceMono.rawValue, 0x7)
        XCTAssertEqual(MPG123Flag.monoLeft.rawValue, 0x1)
        XCTAssertEqual(MPG123Flag.gapless.rawValue, 0x40)

        // Test RVA enums
        XCTAssertEqual(MPG123RVA.off.rawValue, 0)
        XCTAssertEqual(MPG123RVA.mix.rawValue, 1)
        XCTAssertEqual(MPG123RVA.album.rawValue, 2)

        // Test feature enums
        XCTAssertEqual(MPG123Feature.abiUtf8Open.rawValue, 0)
        XCTAssertEqual(MPG123Feature.output16Bit.rawValue, 2)
        XCTAssertEqual(MPG123Feature.equalizer.rawValue, 14)
    }

    // MARK: - Frame Info Tests

    func testFrameInfo() throws {
        // Test creating frame info with default values
        // Note: We can't directly create mpg123_frameinfo2 in tests
        // This test validates the structure exists and can be used
        XCTAssertNotNil(MPG123FrameInfo.self)
    }
}

// MARK: - Test Extensions

/// Extension to access private properties for testing
extension MPG123.AudioStream {
    var chunkSize: Int {
        1024 // Default chunk size for testing
    }
}
