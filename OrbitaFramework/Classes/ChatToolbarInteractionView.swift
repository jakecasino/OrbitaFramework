//
//  ChatToolbar.swift
//  FBSnapshotTestCase
//
//  Created by Jake Casino on 7/24/18.
//

import Efficio

@objc public protocol ORBChatToolbarDelegate {
	func chatToolbarMicDidEnterListeningMode()
	func chatToolbarMicDidExitListeningMode()
	func chatToolbarKeyboardButtonWasSelected()
	func chatToolbarKeyboardButtonWasDeselected()
	func chatToolbarMoreButtonWasSelected()
	func chatToolbarMoreButtonWasDeselected()
}

public class ORBChatToolbarInteractionView: UIView {
	
	// Properties
	@IBOutlet private var view: UIView!
	@IBOutlet public var delegate: ORBChatToolbarDelegate?
	@IBOutlet weak public var keyboardTextField: UITextField!
	public var isListening = false
	private var speakerGrillAnimation: SpeakerGrillAnimation!
	
	@IBOutlet private var micButton: ORBChatToolbarMicButton!
	@IBOutlet weak var keyboardButton: UIAction!
	@IBOutlet weak var moreButton: UIAction!
	private enum buttonFocusStates { case normal; case focused; case unfocused; }
	private var buttons: [UIAction]!
	
	@IBOutlet weak var micButtonLargeHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var keyboardButtonSizeConstraint: NSLayoutConstraint!
	@IBOutlet weak var keyboardButtonLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var moreButtonTrailingConstraint: NSLayoutConstraint!
	private var needsToSetupAutoLayoutAlignment = true
	
	
	// Methods
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		loadXib(forClass: ORBChatToolbarInteractionView.self, named: "ChatToolbarInteractionView")
		setupXibView(view, inContainer: self)
		clipsToBounds = false
		
		buttons = [micButton, keyboardButton, moreButton]
		
		style(micButton, [.glyphEdgeInsets: 10])
		micButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(micButtonWasTapped(_:))))
		micButton.sizeExtraSmall = keyboardButtonSizeConstraint.constant
		micButton.sizeLarge = micButtonLargeHeightConstraint.constant
		
		keyboardButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardButtonWasTapped(_:))))
		moreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moreButtonWasTapped(_:))))
	}
	
	public override func didMoveToSuperview() {
		speakerGrillAnimation = SpeakerGrillAnimation(addTo: view, linkToMicButton: micButton)
		backgroundColor = UIColor.clear
	}
	
	public func changeMicButtonAppearance(newBackgroundColor: UIColor?, newGlyphNamed newGlyphName: String?) {
		if let newBackgroundColor = newBackgroundColor { style(micButton, [.backgroundColor: newBackgroundColor]) }
		if let newGlyphName = newGlyphName {
			if let glyphImage = UIImage(named: newGlyphName) {
				style(micButton, [.glyph: glyphImage])
			}
		}
	}
	
	@objc private func micButtonWasTapped(_ gesture: UITapGestureRecognizer) {
		func toggleMic() {
			micButton.changeSizeState(to: .large)
			realignChatToolbarButton(micButton)
			if micButton.isSelected {
				switchButtonStates(focusOn: nil)
				micButton.isSelected = true
			}
			toggleListeningModeAnimations(executeChatToolbarDelegateMethods: true)
		}
		
		if keyboardTextField.isHidden == false {
			UIView.animate(withDuration: 0.15, animations: {
				self.keyboardTextField.alpha = 0
			}, completion: { (_) in
				self.keyboardTextField.isHidden = true
				self.delegate?.chatToolbarKeyboardButtonWasDeselected()
				toggleMic()
			})
		} else { toggleMic() }
	}
	
	@objc private func keyboardButtonWasTapped(_ gesture: UITapGestureRecognizer) {
		keyboardButton.toggle(inactiveState: { }, activeState: {
			delegate?.chatToolbarKeyboardButtonWasSelected()
			switchButtonStates(focusOn: keyboardButton)
			micButton.changeSizeState(to: .extraSmall)
			
			let offScreen = (padding.extraLarge * 4)
			
			UIView.animate(withDuration: 0.15, animations: {
				self.keyboardButton.move(addToX: -(offScreen), addToY: nil)
				self.micButton.move(x: origins.left, y: nil)
				self.micButton.move(addToX: self.keyboardButtonLeadingConstraint.constant, addToY: nil)
				self.moreButton.move(addToX: offScreen, addToY: nil)
			}, completion: { (_) in
				self.keyboardTextField.isHidden = false
				self.keyboardTextField.becomeFirstResponder()
				UIView.animate(withDuration: 0.15, animations: {
					self.keyboardTextField.alpha = 1
				})
			})
		}, hasHapticFeedback: true)
	}
	
	@objc private func moreButtonWasTapped(_ gesture: UITapGestureRecognizer) {
		moreButton.toggle(inactiveState: {
			delegate?.chatToolbarMoreButtonWasDeselected()
			switchButtonStates(focusOn: nil)
		}, activeState: {
			delegate?.chatToolbarMoreButtonWasSelected()
			switchButtonStates(focusOn: moreButton)
		}, hasHapticFeedback: true)
	}
	
	private func switchButtonStates(focusOn selectedButton: UIAction?) {
		buttons.forEach {
			if $0 == selectedButton {
				$0.isSelected = true
			} else {
				$0.isSelected = false
				realignChatToolbarButton($0)
			}
		}
	}
	
	private func realignChatToolbarButton(_ button: UIAction) {
		UIView.animate(withDuration: 0.15) {
			if button == self.micButton {
				button.move(x: origins.center, y: nil)
			} else if button == self.keyboardButton {
				button.move(x: self.keyboardButtonLeadingConstraint.constant, y: nil)
			} else if button == self.moreButton {
				button.move(x: origins.right, y: nil)
				button.move(addToX: -(self.moreButtonTrailingConstraint.constant), addToY: nil)
			}
		}
	}
	
	public func toggleListeningModeAnimations(executeChatToolbarDelegateMethods: Bool) {
		micButton.toggle(inactiveState: {
			isListening = false
			micButton.changeSizeState(to: .large)
			if executeChatToolbarDelegateMethods {
				delegate?.chatToolbarMicDidExitListeningMode()
			}
			
			UIView.animate(withDuration: 0.85, animations: {
				self.style(self.keyboardButton, [.opacity: 1])
				self.style(self.moreButton, [.opacity: 1])
			}, completion: { (_) in
				self.keyboardButton.isUserInteractionEnabled = true
				self.moreButton.isUserInteractionEnabled = true
			})
		}, activeState: {
			isListening = true
			micButton.changeSizeState(to: .small)
			if executeChatToolbarDelegateMethods {
				delegate?.chatToolbarMicDidEnterListeningMode()
			}
			
			UIView.animate(withDuration: 0.15, animations: {
				self.style(self.keyboardButton, [.opacity: 0])
				self.style(self.moreButton, [.opacity: 0])
			}, completion: { (_) in
				self.keyboardButton.isUserInteractionEnabled = false
				self.moreButton.isUserInteractionEnabled = false
			})
		}, hasHapticFeedback: true)
		
		speakerGrillAnimation.toggle(isListening: micButton.isSelected)
	}
	
	private class SpeakerGrillAnimation: UIView {
		private var speakerGrills = [UIView]()
		private enum loops { case a; case b }
		private var isListening = false
		private var micButton: ORBChatToolbarMicButton!
		
		fileprivate convenience init(addTo view: UIView, linkToMicButton MIC_BUTTON: ORBChatToolbarMicButton) {
			self.init(frame: .zero)
			view.insertSubview(self, at: 0)
			micButton = MIC_BUTTON
			
			let numberOfGrills: Int
			let estimatedNumberOfGrills = Int((((bounds.width - ORBChatToolbarMicButton.sizeSmall) / 2) - padding.extraLarge) / (SpeakerGrill.width + SpeakerGrill.spacing)) * 2
			if (estimatedNumberOfGrills % 2) == 0 {
				numberOfGrills = estimatedNumberOfGrills
			} else {
				numberOfGrills = estimatedNumberOfGrills - 1
			}
			for _ in 1...numberOfGrills {
				let grill = UIView(frame: CGRect.zero)
				grill.resize(width: SpeakerGrill.width, height: SpeakerGrill.height)
				style(grill, [.backgroundColor: UIColor.orbitaBlue, .corners: corners.roundByWidth])
				speakerGrills.append(grill)
			}
		}
		
		override func didMoveToSuperview() {
			guard let superview = superview else { error.thereWasNoSuperview(for: self); return }
			matchFrame(to: superview.bounds)
		}
		
		func toggle(isListening IS_LISTENING: Bool) {
			isListening = IS_LISTENING
			
			switch isListening {
			case true:
				for grill in speakerGrills {
					addSubview(grill)
					grill.move(x: origins.center, y: origins.middle)
					
					let delay = Double(arc4random()) / Double(UINT32_MAX)
					startGrillAnimation(loop: .a, grill: grill, delay: delay)
				}
				
				micButton.isUserInteractionEnabled = false
				UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
					
					for (index, grill) in self.speakerGrills.enumerated() {
						if index < (self.speakerGrills.count / 2) {
							let x = ((self.bounds.width - ORBChatToolbarMicButton.sizeSmall) / 2) - ((SpeakerGrill.width + SpeakerGrill.spacing) * CGFloat(index + 1))
							grill.move(x: x, y: nil)
						} else {
							let x = ((self.bounds.width + ORBChatToolbarMicButton.sizeSmall) / 2) + ((SpeakerGrill.width + SpeakerGrill.spacing) * CGFloat((index - (self.speakerGrills.count / 2)) + 1))
							grill.move(x: x, y: nil)
						}
					}
				}, completion: { (_) in
					self.micButton.isUserInteractionEnabled = true
				})
				
				break
				
			case false:
				micButton.isUserInteractionEnabled = false
				UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
					for grill in self.speakerGrills {
						grill.resize(width: SpeakerGrill.width, height: SpeakerGrill.height)
						grill.move(x: origins.center, y: origins.middle)
					}
				}) { (_) in
					self.speakerGrills.forEach({ $0.removeFromSuperview() })
					self.micButton.isUserInteractionEnabled = true
				}
				
				break
			}
		}
		
		private func startGrillAnimation(loop: loops, grill: UIView, delay: TimeInterval) {
			switch loop {
			case .a:
				UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
					grill.resize(width: nil, height: padding.extraLarge)
					grill.move(x: nil, y: origins.middle)
				}) { (_) in
					if self.isListening { self.startGrillAnimation(loop: .b, grill: grill, delay: 0) }
				}
				break
			case .b:
				UIView.animate(withDuration: 0.6, delay: delay, options: .curveLinear, animations: {
					grill.resize(width: nil, height: SpeakerGrill.height)
					grill.move(x: nil, y: origins.middle)
				}) { (_) in
					if self.isListening { self.startGrillAnimation(loop: .a, grill: grill, delay: 0) }
				}
			}
		}
		
		private class SpeakerGrill {
			static var width: CGFloat { return 4 }
			static var spacing: CGFloat { return padding.small }
			static var height: CGFloat { return padding.small }
		}
	}
}

internal class ORBChatToolbarMicButton: UIAction {
	public enum micButtonSizeStates { case extraSmall; case small; case large }
	private var sizeState: micButtonSizeStates = .large
	var sizeExtraSmall: CGFloat!
	static var sizeSmall: CGFloat { return 44 }
	var sizeLarge: CGFloat!
	
	func changeSizeState(to state: micButtonSizeStates) {
		UIView.animate(withDuration: 0.24, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
			switch state {
			case .extraSmall:
				if self.sizeState == .large {
					let scale = self.sizeExtraSmall / self.sizeLarge
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				} else if self.sizeState == .small {
					let scale = self.sizeExtraSmall / ORBChatToolbarMicButton.sizeSmall
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				}
				self.sizeState = .extraSmall
			case .small:
				if self.sizeState == .extraSmall {
					let scale = ORBChatToolbarMicButton.sizeSmall / self.sizeExtraSmall
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				} else if self.sizeState == .large {
					let scale = ORBChatToolbarMicButton.sizeSmall / self.sizeLarge
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				}
				self.sizeState = .small
			case .large:
				if self.sizeState == .extraSmall {
					let scale = self.sizeLarge / self.sizeExtraSmall
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				} else if self.sizeState == .small {
					let scale = self.sizeLarge / ORBChatToolbarMicButton.sizeSmall
					self.transform = self.transform.scaledBy(x: scale, y: scale)
				}
				self.sizeState = .large
			}
		})
	}
}
