//
//  Colors.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

// UIColor Standard Colors Library
extension UIColor {
	public static var whiteF8: UIColor { return UIColor.from(RGB: [248, 248, 248]) }
	public static var whiteF2: UIColor { return UIColor.from(RGB: [242, 242, 242]) }
	public static var whiteE: UIColor { return UIColor.from(RGB: [238, 238, 238]) }
	public static var whiteD: UIColor { return UIColor.from(RGB: [221, 221, 221]) }
	public static var whiteC: UIColor { return UIColor.from(RGB: [204, 204, 204]) }
}

// UIColor Adjustment Library
extension UIColor {
	public func brighten(by adjustmentPercentage: CGFloat) -> UIColor {
		return adjustBrightness({ (currentValue) in
			let leftover = RGBColor.maxValue - currentValue
			let incrementValue = (CGFloat(leftover) * adjustmentPercentage).rounded(.towardZero)
			return (currentValue + incrementValue)
		})
	}
	
	public func darken(by adjustmentPercentage: CGFloat) -> UIColor {
		return adjustBrightness({ (currentValue) in
			let incrementValue = (currentValue * adjustmentPercentage).rounded(.towardZero)
			return (currentValue - incrementValue)
		})
	}
	
	private func adjustBrightness(_ lightenOrDarken: (CGFloat) -> (CGFloat)) -> UIColor {
		func fetchCurrentRGBValues() -> [CGFloat] {
			func getRGBValue() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
				var fRed : CGFloat = 0
				var fGreen : CGFloat = 0
				var fBlue : CGFloat = 0
				var fAlpha: CGFloat = 0
				if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
					func UIColorTo(RGB value: CGFloat) -> CGFloat {
						return value * RGBColor.maxValue
					}
					let iRed = UIColorTo(RGB: fRed)
					let iGreen = UIColorTo(RGB: fGreen)
					let iBlue = UIColorTo(RGB: fBlue)
					let iAlpha = UIColorTo(RGB: fAlpha)
					
					return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
				} else {
					// Could not extract RGBA components:
					return nil
				}
			}
			
			var currentValues = [CGFloat]()
			_ = getRGBValue()
			currentValues.append(getRGBValue()!.red)
			currentValues.append(getRGBValue()!.green)
			currentValues.append(getRGBValue()!.blue)
			return currentValues
		}
		let currentValues = fetchCurrentRGBValues()
		var adjustedValues = [CGFloat]()
		
		currentValues.forEach { (currentValue) in
			adjustedValues.append(lightenOrDarken(currentValue))
		}
		
		return UIColor.from(RGB: adjustedValues)
	}
}

// RGB Conversion Library
extension UIColor {
	fileprivate struct RGBColor {
		static var minValue: CGFloat = 0
		static var maxValue: CGFloat = 255
	}
	
	public static func from(RGB values: [CGFloat]) -> UIColor {
		func checkForErrorsInRGBComponents(_ values: [CGFloat]) {
			/* for value in values {
				if (value < RGBColor.minValue) || (value > RGBColor.maxValue) {
					error.regarding(values, explanation: "One or more of the values are out of the RGB range. RGBValues: \(values)")
					break
				}
			} */
			
			error.regarding(values, when: { () -> (Bool) in
				values.count > 3
			}, explanation: "More than 3 RGB values were specified. Only first three values will be used.")
		}
		
		func RGB(toUIColor values: [CGFloat]) -> [CGFloat] {
			var newValues = [CGFloat]()
			values.forEach { (value) in
				newValues.append(value / RGBColor.maxValue)
			}
			return newValues
		}
		
		checkForErrorsInRGBComponents(values)
		let rgb = RGB(toUIColor: values)
		return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
	}
}
