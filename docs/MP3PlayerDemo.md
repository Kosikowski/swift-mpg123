# MP3 Player Demo

This demo shows how to use the SwiftMpg123 library to decode MP3 files and play them using AVAudioPlayerNode.

## Features

- **MP3 Decoding**: Uses SwiftMpg123 to decode MP3 files
- **Audio Playback**: Uses AVAudioPlayerNode for high-quality audio playback
- **Metadata Display**: Shows ID3 tags and audio format information
- **Multiple Formats**: Supports various audio encodings (16-bit, 8-bit, float, etc.)
- **Equalizer Support**: 32-band equalizer with presets (bass boost, treble boost, vocal boost)
- **Real-time Processing**: Audio effects applied during decoding

## Usage

### Build the Demo

```bash
swift build -c release
```

### Run the Demo

```bash
.build/release/MP3PlayerDemo <path-to-mp3-file>
```

### Example

```bash
.build/release/MP3PlayerDemo /path/to/your/song.mp3
```

## How It Works

1. **File Loading**: Opens the MP3 file using SwiftMpg123
2. **Metadata Extraction**: Reads ID3 tags and audio format information
3. **Equalizer Setup**: Applies custom equalizer presets (if available)
4. **Decoding**: Decodes the entire MP3 file into raw audio data with effects
5. **Buffer Creation**: Creates an AVAudioPCMBuffer from the decoded data
6. **Playback**: Uses AVAudioPlayerNode to play the audio buffer

## Audio Format Support

The demo supports various audio encodings:
- Signed 16-bit (most common)
- Unsigned 8-bit
- Signed 8-bit
- Unsigned 16-bit
- Signed 24-bit
- Float 32-bit
- Float 64-bit

## Output

The demo will display:
- MP3 file information (sample rate, channels, encoding)
- ID3 metadata (title, artist, album, etc.)
- Equalizer feature availability and settings
- Decoding progress
- Playback status
- Current equalizer band values (first 5 bands)

## Requirements

- macOS 12.0 or later
- mpg123 library installed via Homebrew
- Swift 6.1 or later 