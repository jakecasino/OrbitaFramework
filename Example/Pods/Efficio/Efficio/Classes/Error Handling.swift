//
//  Error Handling.swift
//  Efficio Framework
//
//  Created by Jake Casino on 7/3/18.
//  Copyright © 2018 Jake Casino. All rights reserved.
//

public struct error {
	public static func regarding(_ item: Any, explanation: String) {
		error.regarding(item, when: { () -> (Bool) in
			true
		}, explanation: explanation)
	}
	
	public static func regarding(_ item: Any, when problematicSituationOccurs: () -> (Bool), explanation: String) {
		if problematicSituationOccurs() {
			print("ERROR regarding \(Unmanaged.passUnretained(item as AnyObject).toOpaque()) of type '\(type(of: item))' [\(explanation)]")
		}
	}
	
	public static func thereWasNoSuperview(for view: UIView) {
		error.regarding(view, explanation: "There was no referenced superview for this UIView.")
	}
}
