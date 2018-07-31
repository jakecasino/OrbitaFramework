//
//  Chatbot.swift
//  
//
//  Created by Jake Casino on 7/31/18.
//

import Efficio

public class ORBChatbotThinkingView: UIView {
	var chatBubble: UIView?
	var thinkingDots = [UIView]()
	
	public convenience init(for tableView: UITableView) {
		self.init(frame: .zero)
		
		let numberOfDots = 5
		let dotSize: CGFloat = 5
		let dotSpacing: CGFloat = 10
		let width = (dotSize * CGFloat(numberOfDots)) + ((CGFloat(numberOfDots) - 1) * dotSpacing) + (padding.medium * 2)
		
		resize(width: tableView.frame.width, height: dotSize + padding.extraLarge * 2)
		addPadding(allAround: padding.medium)
		
		chatBubble = UIView(addTo: self)
		chatBubble!.resize(width: width, height: boundingAreas.heightMinusPadding)
		chatBubble!.move(x: origins.leftMinusPadding, y: origins.middle)
		style(chatBubble!, [.backgroundColor: UIColor(white: 0, alpha: 0.15), .corners: corners.large])
		
		
		for index in 0...(numberOfDots - 1) {
			let dot = UIView(addTo: self)
			dot.resize(width: dotSize, height: dotSize)
			dot.move(x: origins.leftMinusPadding, y: origins.middle)
			dot.move(addToX: padding.medium + (CGFloat(index) * (dotSize + dotSpacing)), addToY: nil)
			style(dot, [.backgroundColor: UIColor.white, .corners: corners.roundByWidth])
			thinkingDots.append(dot)
		}
		startAnimating()
	}
	
	func startAnimating() {
		enum directions {
			case scaleUp
			case scaleDown
		}
		
		func move(_ direction: directions, index: Int, delay: TimeInterval) {
			switch direction {
			case .scaleUp:
				UIView.animate(withDuration: 0.5, delay: delay, options: .curveLinear, animations: {
					self.thinkingDots[index].transform = CGAffineTransform(scaleX: 2, y: 2)
					//self.thinkingDots[index].backgroundColor = UIColor.white
				}) { (_) in
					move(.scaleDown, index: index, delay: 0)
				}
				break
			case .scaleDown:
				UIView.animate(withDuration: 0.5, delay: delay, options: .curveLinear, animations: {
					self.thinkingDots[index].transform = CGAffineTransform(scaleX: 1, y: 1)
					//self.thinkingDots[index].backgroundColor = color(.orbitaBlue)
				}) { (_) in
					move(.scaleUp, index: index, delay: 0)
				}
				break
			}
		}
		
		move(.scaleUp, index: 0, delay: 0)
		move(.scaleUp, index: 1, delay: 0.67)
		move(.scaleUp, index: 2, delay: 1.42)
		move(.scaleUp, index: 3, delay: 0.86)
		move(.scaleUp, index: 4, delay: 0.23)
	}
	
	public override func didMoveToSuperview() {
		super.didMoveToSuperview()
		guard superview == nil else { return }
		
		// thinkingDots.removeAll()
	}
}
