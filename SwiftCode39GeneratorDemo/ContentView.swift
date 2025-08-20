//
//  ContentView.swift
//  SwiftCode39GeneratorDemo
//
//  Created by Ricky on 2025/7/31.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = "HELLO123"
    @State private var barWidthRatio: Double = 2.0
    @State private var selectedVariant: Code39Variant = .plain
    @State private var barColor: Color = .black
    @State private var backgroundColor: Color = .white
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                Text("Swift Code39 Generator Demo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Interactive Controls Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Interactive Controls")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        // Input text control
                        VStack(alignment: .leading) {
                            Text("Input Text:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("Enter text to encode", text: $inputText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Bar width ratio slider
                        VStack(alignment: .leading) {
                            Text("Bar Width Ratio: \(String(format: "%.1f", barWidthRatio))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Slider(value: $barWidthRatio, in: 1.8...3.0, step: 0.1)
                        }
                        
                        // Variant picker
                        VStack(alignment: .leading) {
                            Text("Code39 Variant:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Picker("Variant", selection: $selectedVariant) {
                                Text("Plain").tag(Code39Variant.plain)
                                Text("Mod 43").tag(Code39Variant.mod43)
                                Text("Full ASCII").tag(Code39Variant.fullASCII)
                                Text("Extended Mod43").tag(Code39Variant.extendedMod43)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Color controls
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Bar Color:")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                ColorPicker("", selection: $barColor)
                                    .labelsHidden()
                                    .frame(width: 50)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Background:")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                ColorPicker("", selection: $backgroundColor)
                                    .labelsHidden()
                                    .frame(width: 50)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Interactive barcode result
                VStack(alignment: .leading, spacing: 10) {
                    Text("Interactive Result")
                        .font(.headline)
                        .padding(.horizontal)
                    
									if #available(iOS 17.0, *) {
										generateInteractiveBarcode()
											.frame(height: 80)
											.background(Color(backgroundColor))
											.cornerRadius(8)
											.padding(.horizontal)
									} else {
										generateInteractiveBarcode()
											.frame(height: 80)
											.background(backgroundColor)
											.cornerRadius(8)
											.padding(.horizontal)
										// Fallback on earlier versions
									}
                }
                
                // Predefined Examples
                VStack(alignment: .leading, spacing: 20) {
                    Text("Code39 Variants Examples")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Standard Code39
                    BarcodeSection(
                        title: "Standard Code39",
                        description: "Basic alphanumeric encoding",
                        barcode: generateBarcode(text: "HELLO123", variant: .plain)
                    )
                    
                    // Mod43
                    BarcodeSection(
                        title: "Code39 Mod43",
                        description: "With checksum for error detection",
                        barcode: generateBarcode(text: "HELLO123", variant: .mod43)
                    )
                    
                    // Full ASCII
                    BarcodeSection(
                        title: "Full ASCII Code39",
                        description: "Supports lowercase and symbols",
                        barcode: generateBarcode(text: "Hello@123!", variant: .fullASCII)
                    )
                    
                    // Extended Mod43
                    BarcodeSection(
                        title: "Full ASCII + Mod43",
                        description: "Maximum compatibility",
                        barcode: generateBarcode(text: "Test#123", variant: .extendedMod43)
                    )
                }
                .padding(.horizontal)
                
                // Parameter Effects Examples
                VStack(alignment: .leading, spacing: 20) {
                    Text("Parameter Effects Examples")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Different bar width ratios
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Bar Width Ratio Effects")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ParameterEffectSection(
                            title: "Ratio 1.8 (Narrow)",
                            barcode: generateBarcodeWithRatio("RATIO18", ratio: 1.8)
                        )
                        
                        ParameterEffectSection(
                            title: "Ratio 2.0 (Default)",
                            barcode: generateBarcodeWithRatio("RATIO20", ratio: 2.0)
                        )
                        
                        ParameterEffectSection(
                            title: "Ratio 3.0 (Wide)",
                            barcode: generateBarcodeWithRatio("RATIO30", ratio: 3.0)
                        )
                    }
                    
                    // Different colors
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Color Variations")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ColorVariationSection(
                            title: "Blue on White",
                            barcode: generateColorBarcode("BLUE123", barColor: .blue, bgColor: .white)
                        )
                        
                        ColorVariationSection(
                            title: "White on Black",
                            barcode: generateColorBarcode("WHITE123", barColor: .white, bgColor: .black)
                        )
                        
                        ColorVariationSection(
                            title: "Red on Yellow",
                            barcode: generateColorBarcode("RED123", barColor: .red, bgColor: .yellow)
                        )
                    }
                    
                    // Different sizes
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Size Variations")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        SizeVariationSection(
                            title: "Small (200x40)",
                            barcode: generateSizedBarcode("SMALL", size: CGSize(width: 200, height: 40)),
                            height: 40
                        )
                        
                        SizeVariationSection(
                            title: "Medium (300x60)",
                            barcode: generateSizedBarcode("MEDIUM", size: CGSize(width: 300, height: 60)),
                            height: 60
                        )
                        
                        SizeVariationSection(
                            title: "Large (400x80)",
                            barcode: generateSizedBarcode("LARGE", size: CGSize(width: 400, height: 80)),
                            height: 80
                        )
                    }
                    
                    // Edge insets variations
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Edge Insets (Margins) Effects")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        EdgeInsetsSection(
                            title: "No Margins",
                            barcode: generateBarcodeWithInsets("NOMARGIN", insets: .zero)
                        )
                        
                        EdgeInsetsSection(
                            title: "Small Margins (5px all)",
                            barcode: generateBarcodeWithInsets("SMALL", insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
                        )
                        
                        EdgeInsetsSection(
                            title: "Medium Margins (10px all)",
                            barcode: generateBarcodeWithInsets("MEDIUM", insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
                        )
                        
                        EdgeInsetsSection(
                            title: "Large Margins (20px all)",
                            barcode: generateBarcodeWithInsets("LARGE", insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
                        )
                        
                        EdgeInsetsSection(
                            title: "Left/Right Only (0,15,0,15)",
                            barcode: generateBarcodeWithInsets("LEFTRIGHT", insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
                        )
                        
                        EdgeInsetsSection(
                            title: "Top/Bottom Only (15,0,15,0)",
                            barcode: generateBarcodeWithInsets("TOPBOTTOM", insets: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0))
                        )
                        
                        EdgeInsetsSection(
                            title: "Asymmetric (5,25,10,25)",
                            barcode: generateBarcodeWithInsets("ASYMMETRIC", insets: UIEdgeInsets(top: 5, left: 25, bottom: 10, right: 25))
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
        }
    }
    
    // MARK: - Barcode Generation Functions
    
    private func generateInteractiveBarcode() -> some View {
        Group {
            if let barcodeImage = SwiftCode39Generator.generateCode39Image(
                with: inputText,
                imageSize: CGSize(width: 350, height: 80),
                edgeInsets: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10),
                backgroundColor: UIColor(backgroundColor),
                barColor: UIColor(barColor),
                barWidthRatio: CGFloat(barWidthRatio)
            ) {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Invalid input for selected variant")
                    .foregroundColor(.red)
                    .frame(height: 80)
            }
        }
    }
    
    private func generateBarcode(text: String, variant: Code39Variant) -> Image? {
        guard let barcodeImage = SwiftCode39Generator.generateCode39(
            codeStr: text,
            codeSize: CGSize(width: 300, height: 60),
            variant: variant
        ) else { return nil }
        
        return Image(uiImage: barcodeImage)
    }
    
    private func generateBarcodeWithRatio(_ text: String, ratio: CGFloat) -> Image? {
        guard let barcodeImage = SwiftCode39Generator.generateCode39(
            codeStr: text,
            codeSize: CGSize(width: 300, height: 60),
            barWidthRatio: ratio
        ) else { return nil }
        
        return Image(uiImage: barcodeImage)
    }
    
    private func generateColorBarcode(_ text: String, barColor: UIColor, bgColor: UIColor) -> Image? {
        guard let barcodeImage = SwiftCode39Generator.generateCode39Image(
            with: text,
            imageSize: CGSize(width: 300, height: 60),
            edgeInsets: .zero,
            backgroundColor: bgColor,
            barColor: barColor
        ) else { return nil }
        
        return Image(uiImage: barcodeImage)
    }
    
    private func generateSizedBarcode(_ text: String, size: CGSize) -> Image? {
        guard let barcodeImage = SwiftCode39Generator.generateCode39(
            codeStr: text,
            codeSize: size
        ) else { return nil }
        
        return Image(uiImage: barcodeImage)
    }
    
    private func generateBarcodeWithInsets(_ text: String, insets: UIEdgeInsets) -> Image? {
        guard let barcodeImage = SwiftCode39Generator.generateCode39Image(
            with: text,
            imageSize: CGSize(width: 300, height: 60),
            edgeInsets: insets,
            backgroundColor: .white,
            barColor: .black
        ) else { return nil }
        
        return Image(uiImage: barcodeImage)
    }
}

// MARK: - Helper Views

struct BarcodeSection: View {
    let title: String
    let description: String
    let barcode: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let barcode = barcode {
                barcode
                    .resizable()
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(8)
            } else {
                Text("Generation failed")
                    .foregroundColor(.red)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
}

struct ParameterEffectSection: View {
    let title: String
    let barcode: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            if let barcode = barcode {
                barcode
                    .resizable()
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(6)
                    .padding(.horizontal)
            } else {
                Text("Generation failed")
                    .foregroundColor(.red)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal)
            }
        }
    }
}

struct ColorVariationSection: View {
    let title: String
    let barcode: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            if let barcode = barcode {
                barcode
                    .resizable()
                    .frame(height: 50)
                    .cornerRadius(6)
                    .padding(.horizontal)
            } else {
                Text("Generation failed")
                    .foregroundColor(.red)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal)
            }
        }
    }
}

struct SizeVariationSection: View {
    let title: String
    let barcode: Image?
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            if let barcode = barcode {
                barcode
                    .resizable()
                    .frame(height: height)
                    .background(Color.white)
                    .cornerRadius(6)
                    .padding(.horizontal)
            } else {
                Text("Generation failed")
                    .foregroundColor(.red)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal)
            }
        }
    }
}

struct EdgeInsetsSection: View {
    let title: String
    let barcode: Image?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            if let barcode = barcode {
                barcode
                    .resizable()
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
            } else {
                Text("Generation failed")
                    .foregroundColor(.red)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
