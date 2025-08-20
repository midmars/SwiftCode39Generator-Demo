//
//  SwiftCode39Generator.swift
//  HappyGo
//
//  Created by Ricky on 2025/7/29.
//

import UIKit

/// 統一的 Swift Code39 條碼生成器
/// 整合 HYCode39 和 ZXingWrapper 的功能，提供純 Swift 實現
public class SwiftCode39Generator {
	// MARK: - Configuration
	
	/// 默認的寬條與窄條比例
	/// - 可在應用啟動時修改此值來調整全域默認粗度
	/// - 建議範圍: 1.8-3.0
	public static var defaultBarWidthRatio: CGFloat = 2
	
	
	// MARK: - Constants

	public static let code39Alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*"

	private static let code39Encodings = [
		/* 0 */ "000110100",
		/* 1 */ "100100001",
		/* 2 */ "001100001",
		/* 3 */ "101100000",
		/* 4 */ "000110001",
		/* 5 */ "100110000",
		/* 6 */ "001110000",
		/* 7 */ "000100101",
		/* 8 */ "100100100",
		/* 9 */ "001100100",
		/* A */ "100001001",
		/* B */ "001001001",
		/* C */ "101001000",
		/* D */ "000011001",
		/* E */ "100011000",
		/* F */ "001011000",
		/* G */ "000001101",
		/* H */ "100001100",
		/* I */ "001001100",
		/* J */ "000011100",
		/* K */ "100000011",
		/* L */ "001000011",
		/* M */ "101000010",
		/* N */ "000010011",
		/* O */ "100010010",
		/* P */ "001010010",
		/* Q */ "000000111",
		/* R */ "100000110",
		/* S */ "001000110",
		/* T */ "000010110",
		/* U */ "110000001",
		/* V */ "011000001",
		/* W */ "111000000",
		/* X */ "010010001",
		/* Y */ "110010000",
		/* Z */ "011010000",
		/* - */ "010000101",
		/* . */ "110000100",
		/* ' ' */ "011000100",
		/* $ */ "010101000",
		/* / */ "010100010",
		/* + */ "010001010",
		/* % */ "000101010",
		/* * */ "010010100"
	]

	// MARK: - Public Methods

	/// 生成 Code39 條碼圖片（簡化版本，對應 ZXingWrapper 功能）
	/// - Parameters:
	///   - codeStr: 要編碼的字符串
	///   - codeSize: 條碼圖片尺寸
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	public static func generateCode39(codeStr: String, codeSize: CGSize) -> UIImage? {
		return generateCode39Image(
			with: codeStr,
			imageSize: codeSize,
			edgeInsets: .zero,
			backgroundColor: .white,
			barColor: .black,
			barWidthRatio: defaultBarWidthRatio)
	}
	
	/// 生成 Code39 條碼圖片（可調整粗度版本）
	/// - Parameters:
	///   - codeStr: 要編碼的字符串
	///   - codeSize: 條碼圖片尺寸
	///   - barWidthRatio: 寬條與窄條的比例（預設使用 defaultBarWidthRatio，範圍 1.8-3.0）
	///   - narrowBarWidth: 窄條寬度（預設自動計算）
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	public static func generateCode39(
		codeStr: String,
		codeSize: CGSize,
		barWidthRatio: CGFloat? = nil,
		narrowBarWidth: CGFloat? = nil
	) -> UIImage? {
		return generateCode39Image(
			with: codeStr,
			imageSize: codeSize,
			edgeInsets: .zero,
			backgroundColor: .white,
			barColor: .black,
			barWidthRatio: barWidthRatio ?? defaultBarWidthRatio,
			narrowBarWidth: narrowBarWidth)
	}

	/// 生成 Code39 條碼圖片（完整版本，對應 HYCode39 功能）
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageSize: 條碼圖片尺寸
	///   - edgeInsets: 條碼內容相對於圖片四周的邊距
	///   - backgroundColor: 圖片背景顏色，nil 使用白色
	///   - barColor: 條碼顏色，nil 使用黑色
	///   - barWidthRatio: 寬條與窄條的比例（預設使用 defaultBarWidthRatio）
	///   - narrowBarWidth: 窄條寬度（預設自動計算）
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	public static func generateCode39Image(
		with string: String,
		imageSize: CGSize,
		edgeInsets: UIEdgeInsets = .zero,
		backgroundColor: UIColor? = nil,
		barColor: UIColor? = nil,
		barWidthRatio: CGFloat? = nil,
		narrowBarWidth: CGFloat? = nil) -> UIImage? {
		
		guard !string.isEmpty, imageSize.width > 0, imageSize.height > 0 else { 
			return nil 
		}

		let processedString = string.uppercased()
		guard let codeString = generateCodeString(from: processedString) else {
			return nil
		}

		let backColor = backgroundColor ?? .white
		let strokeColor = barColor ?? .black
		
		return drawBarcode(
			codeString: codeString,
			imageSize: imageSize,
			edgeInsets: edgeInsets,
			backgroundColor: backColor,
			barColor: strokeColor,
			stringLength: processedString.count,
			barWidthRatio: barWidthRatio ?? defaultBarWidthRatio,
			narrowBarWidth: narrowBarWidth)
	}

	/// 生成 Code39 條碼圖片（指定高度版本）
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageHeight: 條碼圖片高度
	///   - edgeInsets: 條碼內容相對於圖片四周的邊距
	///   - backgroundColor: 圖片背景顏色，nil 使用白色
	///   - barColor: 條碼顏色，nil 使用黑色
	///   - barWidthRatio: 寬條與窄條的比例（預設使用 defaultBarWidthRatio）
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	public static func generateCode39Image(
		with string: String,
		imageHeight: CGFloat,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor? = nil,
		barColor: UIColor? = nil,
		barWidthRatio: CGFloat? = nil) -> UIImage? {
		
		guard !string.isEmpty, imageHeight > 0 else { 
			return nil 
		}

		let processedString = string.uppercased()
		guard let codeString = generateCodeString(from: processedString) else {
			return nil
		}

		let imageWidth = calculateWidth(for: codeString)
		let imageSize = CGSize(
			width: imageWidth + edgeInsets.left + edgeInsets.right,
			height: imageHeight)

		let backColor = backgroundColor ?? .white
		let strokeColor = barColor ?? .black

		return drawBarcodeWithFixedWidth(
			codeString: codeString,
			imageSize: imageSize,
			edgeInsets: edgeInsets,
			backgroundColor: backColor,
			barColor: strokeColor,
			barWidthRatio: barWidthRatio ?? defaultBarWidthRatio,
			customNarrowWidth: 1.0
		)
	}

	// MARK: - Private Methods

	private static func generateCodeString(from string: String) -> String? {
		var codeString = "010010100"
		codeString.reserveCapacity(string.count * 10 + 20) // 預分配記憶體

		for character in string {
			guard let index = code39Alphabet.firstIndex(of: character) else {
				return nil
			}

			if character == "*" {
				return nil
			}

			let encodingIndex = code39Alphabet.distance(from: code39Alphabet.startIndex, to: index)
			let encoding = code39Encodings[encodingIndex]
			codeString += "0" + encoding
		}

		codeString += "0010010100"
		return codeString
	}

	private static func drawBarcode(
		codeString: String,
		imageSize: CGSize,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor,
		barColor: UIColor,
		stringLength: Int,
		barWidthRatio: CGFloat = 2.0,
		narrowBarWidth: CGFloat? = nil) -> UIImage? {
		
		// 限制 barWidthRatio 在合理範圍內（Code39 標準建議 1.8-3.0）
		let validRatio = max(1.8, min(3.0, barWidthRatio))
		
		let calculatedNarrowWidth: CGFloat
		if let customNarrowWidth = narrowBarWidth, customNarrowWidth > 0 {
			calculatedNarrowWidth = customNarrowWidth
		} else {
			// 根據字符數量和比例自動計算合適的窄條寬度
			let totalUnits = calculateTotalUnits(for: codeString, ratio: validRatio)
			calculatedNarrowWidth = (imageSize.width - edgeInsets.left - edgeInsets.right) / totalUnits
		}
		
		let wideBarWidth = calculatedNarrowWidth * validRatio
		let barHeight = imageSize.height - edgeInsets.top - edgeInsets.bottom

		return drawBarcodeImage(
			codeString: codeString,
			imageSize: imageSize,
			startX: edgeInsets.left,
			startY: edgeInsets.top,
			narrowBarWidth: calculatedNarrowWidth,
			wideBarWidth: wideBarWidth,
			barHeight: barHeight,
			backgroundColor: backgroundColor,
			barColor: barColor)
	}

	private static func drawBarcodeWithFixedWidth(
		codeString: String,
		imageSize: CGSize,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor,
		barColor: UIColor,
		barWidthRatio: CGFloat = 2.0,
		customNarrowWidth: CGFloat? = nil) -> UIImage? {
		
		// 限制 barWidthRatio 在合理範圍內
		let validRatio = max(1.8, min(3.0, barWidthRatio))
		
		// 窄條寬度 1.3（調整這個數字改變窄條粗度）
		let narrowBarWidth: CGFloat = customNarrowWidth ?? 1
		let wideBarWidth = narrowBarWidth * validRatio
		let barHeight = imageSize.height - edgeInsets.top - edgeInsets.bottom

		return drawBarcodeImage(
			codeString: codeString,
			imageSize: imageSize,
			startX: edgeInsets.left,
			startY: edgeInsets.top,
			narrowBarWidth: narrowBarWidth,
			wideBarWidth: wideBarWidth,
			barHeight: barHeight,
			backgroundColor: backgroundColor,
			barColor: barColor)
	}

	private static func drawBarcodeImage(
		codeString: String,
		imageSize: CGSize,
		startX: CGFloat,
		startY: CGFloat,
		narrowBarWidth: CGFloat,
		wideBarWidth: CGFloat,
		barHeight: CGFloat,
		backgroundColor: UIColor,
		barColor: UIColor) -> UIImage? {
		
		let renderer = UIGraphicsImageRenderer(size: imageSize)
		
		return renderer.image { context in
			let cgContext = context.cgContext
			cgContext.setShouldAntialias(false)
			
			// 設置背景
			backgroundColor.setFill()
			cgContext.fill(CGRect(origin: .zero, size: imageSize))
			
			var x = startX
			
			for (index, character) in codeString.enumerated() {
				let barWidth = character == "1" ? wideBarWidth : narrowBarWidth
				
				if index % 2 == 0 { // 偶數位置為條碼
					barColor.setFill()
					cgContext.fill(CGRect(x: x, y: startY, width: barWidth, height: barHeight))
				}
				// 奇數位置為空白，不需要繪製
				
				x += barWidth
			}
		}
	}

	private static func calculateWidth(for codeString: String) -> CGFloat {
		var count: CGFloat = 0

		for character in codeString {
			let barWidth: CGFloat = character == "1" ? 2 : 1
			count += barWidth
		}

		return count
	}
	
	/// 計算條碼所需的總單位數（考慮寬窄比例）
	private static func calculateTotalUnits(for codeString: String, ratio: CGFloat) -> CGFloat {
		var totalUnits: CGFloat = 0
		
		for character in codeString {
			if character == "1" {
				totalUnits += ratio  // 寬條
			} else {
				totalUnits += 1.0    // 窄條
			}
		}
		
		return totalUnits
	}
}

// MARK: - Compatibility Extensions

public extension SwiftCode39Generator {
	/// 與 HYCode39 兼容的方法名稱
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageSize: 條碼圖片尺寸
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	static func code39Image(with string: String, imageSize: CGSize) -> UIImage? {
		return generateCode39Image(with: string, imageSize: imageSize)
	}

	/// 與 HYCode39 兼容的方法名稱（帶邊距）
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageSize: 條碼圖片尺寸
	///   - edgeInsets: 條碼內容相對於圖片四周的邊距
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	static func code39Image(with string: String, imageSize: CGSize, edgeInsets: UIEdgeInsets) -> UIImage? {
		return generateCode39Image(with: string, imageSize: imageSize, edgeInsets: edgeInsets)
	}

	/// 與 HYCode39 兼容的方法名稱（完整參數）
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageHeight: 條碼圖片高度
	///   - edgeInsets: 條碼內容相對於圖片四周的邊距
	///   - backgroundColor: 圖片背景顏色
	///   - barColor: 條碼顏色
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	static func code39Image(
		with string: String,
		imageHight imageHeight: CGFloat,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor?,
		barColor: UIColor?) -> UIImage? {
		return generateCode39Image(
			with: string,
			imageHeight: imageHeight,
			edgeInsets: edgeInsets,
			backgroundColor: backgroundColor,
			barColor: barColor)
	}
	
	/// 與 HYCode39 兼容的方法名稱（可調整粗度）
	/// - Parameters:
	///   - string: 要編碼的字符串
	///   - imageHeight: 條碼圖片高度
	///   - edgeInsets: 條碼內容相對於圖片四周的邊距
	///   - backgroundColor: 圖片背景顏色
	///   - barColor: 條碼顏色
	///   - barWidthRatio: 寬條與窄條的比例（預設 2.0，範圍 1.8-3.0）
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	static func code39Image(
		with string: String,
		imageHight imageHeight: CGFloat,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor?,
		barColor: UIColor?,
		barWidthRatio: CGFloat) -> UIImage? {
		return generateCode39Image(
			with: string,
			imageHeight: imageHeight,
			edgeInsets: edgeInsets,
			backgroundColor: backgroundColor,
			barColor: barColor,
			barWidthRatio: barWidthRatio)
	}
}

