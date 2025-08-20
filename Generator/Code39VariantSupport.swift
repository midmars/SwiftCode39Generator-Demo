//
//  Code39VariantSupport.swift
//  HappyGo
//
//  Created by Ricky on 2025/7/29.
//

import UIKit

// MARK: - Code39 變體支援

public enum Code39Variant {
	case plain          // Code 39 (standard)
	case mod43          // Code 39 Mod 43
	case fullASCII      // Full ASCII Code 39
	case extendedMod43  // Full ASCII Code 39 + Mod 43
}

extension SwiftCode39Generator {
	
	/// 生成指定變體的 Code39 條碼
	/// - Parameters:
	///   - codeStr: 要編碼的字符串
	///   - codeSize: 條碼圖片尺寸
	///   - variant: Code 39 變體類型
	/// - Returns: 生成的條碼圖片，失敗則返回 nil
	public static func generateCode39(
		codeStr: String,
		codeSize: CGSize,
		variant: Code39Variant
	) -> UIImage? {
		
		switch variant {
		case .plain:
			return generateCode39(codeStr: codeStr, codeSize: codeSize)
			
		case .mod43:
			guard let processedString = processForMod43(codeStr) else { return nil }
			return generateCode39(codeStr: processedString, codeSize: codeSize)
			
		case .fullASCII:
			guard let encodedString = encodeFullASCII(codeStr) else { return nil }
			return generateCode39(codeStr: encodedString, codeSize: codeSize)
			
		case .extendedMod43:
			guard let encodedString = encodeFullASCII(codeStr),
			      let processedString = processForMod43(encodedString) else { return nil }
			return generateCode39(codeStr: processedString, codeSize: codeSize)
		}
	}
	
	// MARK: - Mod 43 支援
	
	private static func processForMod43(_ input: String) -> String? {
		let processedString = input.uppercased()
		let checkDigit = calculateMod43CheckDigit(processedString)
		guard !checkDigit.isEmpty else { return nil }
		return processedString + checkDigit
	}
	
	private static func calculateMod43CheckDigit(_ input: String) -> String {
		var sum = 0
		
		for character in input {
			guard let index = code39Alphabet.firstIndex(of: character) else {
				return "" // 包含非法字符
			}
			let value = code39Alphabet.distance(from: code39Alphabet.startIndex, to: index)
			sum += value
		}
		
		let checkDigitIndex = sum % (code39Alphabet.count - 1) // 排除 '*'
		let checkDigitChar = code39Alphabet[code39Alphabet.index(code39Alphabet.startIndex,
																 offsetBy: checkDigitIndex)]
		return String(checkDigitChar)
	}
	
	// MARK: - Full ASCII 支援
	
	private static func encodeFullASCII(_ input: String) -> String? {
		var encoded = ""
		encoded.reserveCapacity(input.count * 2) // 預分配記憶體
		
		for character in input {
			if let basicEncoding = encodeBasicCharacter(character) {
				encoded += basicEncoding
			} else {
				return nil // 無法編碼的字符
			}
		}
		
		return encoded
	}
	
	private static func encodeBasicCharacter(_ char: Character) -> String? {
		// 直接支援的基本字符
		if code39Alphabet.contains(char) && char != "*" {
			return String(char)
		}
		
		// 需要轉義的字符
		switch char {
		// 小寫字母
		case "a"..."z":
			return "+" + String(char).uppercased()
			
		// 特殊符號
		case "!": return "/A"
		case "\"": return "/B"
		case "#": return "/C"
		case "&": return "/F"
		case "'": return "/G"
		case "(": return "/H"
		case ")": return "/I"
		case "*": return "/J"
		case ",": return "/L"
		case ":": return "/Z"
		case ";": return "%F"
		case "<": return "%G"
		case "=": return "%H"
		case ">": return "%I"
		case "?": return "%J"
		case "@": return "%V"
		case "[": return "%K"
		case "\\": return "%L"
		case "]": return "%M"
		case "^": return "%N"
		case "_": return "%O"
		case "`": return "%W"
		case "{": return "%P"
		case "|": return "%Q"
		case "}": return "%R"
		case "~": return "%S"
		case "\t": return "$I"
		case "\n": return "$M"
			
		default:
			return nil // 不支援的字符
		}
	}
}
