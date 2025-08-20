# Swift Code39 Generator Demo

A pure Swift implementation of Code39 barcode generator for iOS applications with support for multiple variants and customizable styling options.

## Features

- ✅ Pure Swift implementation (no external dependencies)
- ✅ Multiple Code39 variants support
  - Code 39 (Standard)
  - Code 39 Mod 43
  - Full ASCII Code 39
  - Full ASCII Code 39 + Mod 43
- ✅ Customizable barcode styling
  - Adjustable bar width ratios (1.8-3.0)
  - Custom colors (background and bar colors)
  - Configurable edge insets
  - Flexible image sizing
- ✅ SwiftUI integration
- ✅ UIImage extensions for easy usage
- ✅ Memory optimized with pre-allocated capacity
- ✅ Antialiasing disabled for crisp barcode output

## Requirements

- iOS 16.0+
- Xcode 16.0+
- Swift 5.0+

## Installation

### Manual Installation
1. Clone or download this repository
2. Drag the `Generator` folder into your Xcode project
3. Make sure to add the files to your target

### Files to Include
```
Generator/
├── SwiftCode39Generator.swift      # Core barcode generator
├── UIImage+Code39.swift           # UIImage extensions
└── Code39VariantSupport.swift     # Variant implementations
```

## Usage

### Basic Usage

```swift
import UIKit

// Generate a simple Code39 barcode
let barcode = SwiftCode39Generator.generateCode39(
    codeStr: "HELLO123",
    codeSize: CGSize(width: 300, height: 60)
)

// Using UIImage extension
let barcodeImage = UIImage.generateCode39(
    codeStr: "HELLO123", 
    codeSize: CGSize(width: 300, height: 60)
)
```

### Advanced Usage

```swift
// Generate barcode with custom styling
let styledBarcode = SwiftCode39Generator.generateCode39Image(
    with: "HELLO123",
    imageSize: CGSize(width: 400, height: 80),
    edgeInsets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20),
    backgroundColor: .white,
    barColor: .black,
    barWidthRatio: 2.5
)
```

### Code39 Variants

```swift
// Standard Code39
let standard = SwiftCode39Generator.generateCode39(
    codeStr: "HELLO123",
    codeSize: CGSize(width: 300, height: 60),
    variant: .plain
)

// Code39 with Mod 43 checksum
let mod43 = SwiftCode39Generator.generateCode39(
    codeStr: "HELLO123",
    codeSize: CGSize(width: 300, height: 60),
    variant: .mod43
)

// Full ASCII support (lowercase letters and special characters)
let fullASCII = SwiftCode39Generator.generateCode39(
    codeStr: "Hello@123!",
    codeSize: CGSize(width: 400, height: 60),
    variant: .fullASCII
)
```

### SwiftUI Usage

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            if let barcodeImage = SwiftCode39Generator.generateCode39(
                codeStr: "SWIFT123",
                codeSize: CGSize(width: 300, height: 60)
            ) {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .frame(width: 300, height: 60)
            }
        }
        .padding()
    }
}
```

## Supported Characters

### Standard Code39 Alphabet
- Numbers: `0-9`
- Letters: `A-Z` (uppercase only in standard mode)
- Special characters: `- . $ / + % *` (space)

### Full ASCII Mode
Supports all ASCII characters including:
- Lowercase letters: `a-z`
- Special symbols: `! " # & ' ( ) , : ; < = > ? @ [ \ ] ^ _ ` { | } ~`
- Control characters: Tab, Line Feed

## Configuration Options

### Global Configuration
```swift
// Set global default bar width ratio
SwiftCode39Generator.defaultBarWidthRatio = 2.5
```

### Available Parameters
- `barWidthRatio`: Ratio between wide and narrow bars (1.8-3.0, default: 2.0)
- `backgroundColor`: Background color of the barcode image
- `barColor`: Color of the barcode bars
- `edgeInsets`: Padding around the barcode content
- `narrowBarWidth`: Custom width for narrow bars (auto-calculated if not specified)

## Code39 Variants

| Variant | Description | Use Case |
|---------|-------------|----------|
| `.plain` | Standard Code39 | Basic alphanumeric encoding |
| `.mod43` | Code39 + Mod43 checksum | Enhanced error detection |
| `.fullASCII` | Full ASCII character set | Mixed case and special characters |
| `.extendedMod43` | Full ASCII + Mod43 | Maximum compatibility and reliability |

## Performance Optimizations

- Pre-allocated string capacity for better memory performance
- Disabled antialiasing for crisp barcode rendering
- Efficient character encoding lookup
- Minimal memory footprint

## Demo Application

The included demo application demonstrates:
- Basic barcode generation
- SwiftUI integration
- Real-time barcode display

To run the demo:
1. Open `SwiftCode39GeneratorDemo.xcodeproj`
2. Build and run the project
3. The app will display a sample Code39 barcode

## API Reference

### Core Methods

#### `generateCode39(codeStr:codeSize:)`
Basic barcode generation with default settings.

#### `generateCode39Image(with:imageSize:edgeInsets:backgroundColor:barColor:barWidthRatio:narrowBarWidth:)`
Full-featured barcode generation with all customization options.

#### `generateCode39(codeStr:codeSize:variant:)`
Generate barcode with specific Code39 variant.

### UIImage Extensions

#### `UIImage.generateCode39(codeStr:codeSize:)`
Convenient UIImage class method for basic barcode generation.

#### `UIImage.generateCode39(codeStr:codeSize:barWidthRatio:)`
UIImage class method with custom bar width ratio.

## License

This project is available under the MIT License. See the LICENSE file for more info.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Created by Ricky - 2025

## Changelog

### Version 1.0
- Initial release
- Pure Swift Code39 implementation
- Multiple variant support
- SwiftUI compatibility
- UIImage extensions
- Comprehensive customization options
