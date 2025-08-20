//
//  UIImage+Code39.swift
//  SwiftCode39GeneratorDemo
//
//  Created by Ricky on 2025/8/20.
//
import UIKit
public extension UIImage {
	/// 產生Code39的BarCode
	/// barCodeStr: 所需轉換的文字
	/// barCodeSize: 轉換成圖片的size
	class func generateCode39(codeStr: String, codeSize: CGSize) -> UIImage? {
		return SwiftCode39Generator.generateCode39(codeStr: codeStr, codeSize: codeSize)
	}
	
	/// 產生Code39的BarCode（可調整粗度）
	/// - Parameters:
	///   - codeStr: 所需轉換的文字
	///   - codeSize: 轉換成圖片的size
	///   - barWidthRatio: 寬條與窄條的比例（預設 2.0，建議範圍 1.8-3.0）
	/// - Returns: 條碼圖片或 nil
	class func generateCode39(codeStr: String, codeSize: CGSize, barWidthRatio: CGFloat) -> UIImage? {
		return SwiftCode39Generator.generateCode39(
			codeStr: codeStr,
			codeSize: codeSize,
			barWidthRatio: barWidthRatio
		)
	}
}
