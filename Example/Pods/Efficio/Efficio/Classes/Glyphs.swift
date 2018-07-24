//
//  Glyphs.swift
//  Efficio
//
//  Created by Jake Casino on 7/21/18.
//

import UIKit

public class Glyphs { }

public class Glyph: UIImageView {
	public func render(_ name: String, tintColor TINT_COLOR: UIColor?) {
		image = UIImage(named: name)
		tintColor = TINT_COLOR
	}
}
