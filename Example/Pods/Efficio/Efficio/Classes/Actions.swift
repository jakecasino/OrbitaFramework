//
//  Buttons.swift
//  Efficio
//
//  Created by Jake Casino on 7/6/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

import UIKit

public class UIAction: UIButton {
	public override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				if backgroundColor == UIColor.clear {
					for view in subviews {
						view.alpha = 0.6
					}
				} else {
					backgroundColor = baseColor.darken(by: 0.15)
					tintColor = accentColor.darken(by: 0.15)
				}
			} else {
				if backgroundColor == UIColor.clear {
					for view in subviews {
						view.alpha = 1.0
					}
				} else {
					backgroundColor = baseColor
					tintColor = accentColor
				}
			}
		}
	}
	
	private static var associationKey_baseColor: UInt8 = 0
	private static var associationKey_accentColor: UInt8 = 1
	
	@IBInspectable public var baseColor: UIColor {
		get {
			return objc_getAssociatedObject(self, &UIAction.associationKey_baseColor) as! UIColor
		}
		set(newValue) {
			objc_setAssociatedObject(self, &UIAction.associationKey_baseColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	@IBInspectable public var accentColor: UIColor {
		get {
			return objc_getAssociatedObject(self, &UIAction.associationKey_accentColor) as! UIColor
		}
		set(newValue) {
			objc_setAssociatedObject(self, &UIAction.associationKey_accentColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public convenience init(addTo view: UIView, glyph: UIImage?, label: String?, baseColor: UIColor) {
		if let glyph = glyph {
			if let label = label {
				self.init(view: view, base: baseColor, accent: nil, glyph: glyph, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: nil, glyph: glyph, label: nil)
			}
		} else {
			if let label = label {
				self.init(view: view, base: baseColor, accent: nil, glyph: nil, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: nil, glyph: nil, label: nil)
			}
		}
	}
	
	public convenience init(addTo view: UIView, glyph: UIImage?, label: String?, baseColor: UIColor, accentColor: UIColor) {
		if let glyph = glyph {
			if let label = label {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: glyph, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: glyph, label: nil)
			}
		} else {
			if let label = label {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: nil, label: label)
			} else {
				self.init(view: view, base: baseColor, accent: accentColor, glyph: nil, label: nil)
			}
		}
	}
	
	private convenience init(view: UIView, base: UIColor, accent: UIColor?, glyph: UIImage?, label: String?) {
		self.init(frame: CGRect.zero)
		view.addSubview(self)
		
		baseColor = base
		if let accent = accent { accentColor = accent }
		else { accentColor = UIColor.white }
		
		style(self, [.backgroundColor: baseColor, .maskContent: true])
		tintColor = accentColor
		
		if let glyph = glyph {
			setImage(glyph, for: .normal)
			adjustsImageWhenHighlighted = false
		}
		
		if let label = label {
			setTitle(label, for: .normal)
		}
	}
	
	public typealias action = () -> ()
	public func toggle(inactiveState: action, activeState: action) {
		if isSelected {
			isSelected = false
			inactiveState()
		} else {
			isSelected = true
			activeState()
		}
	}
}
