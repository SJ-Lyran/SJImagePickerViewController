//
//  SJLoadingIndicator.swift
//  SJImagePickerController
//
//  Created by sheng on 2020/10/19.
//  Copyright © 2020 sheng. All rights reserved.
//

import UIKit

private let kCircleMargin: CGFloat = 3

class SJLoadingIndicator: UIView {
    var progress: CGFloat = 0 {
        didSet {
            progress = progress > 1.0 ? 1 : progress
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let centerX = rect.size.width * 0.5
        let centerY = rect.size.width * 0.5
        let aCenter = CGPoint(x: centerX, y: centerY)
        let radius = min(rect.size.width, rect.size.height) * 0.5 - kCircleMargin
        let path = UIBezierPath()
        path.lineWidth = kCircleMargin
        path.addArc(withCenter: aCenter, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        UIColor.white.set()
        path.stroke()
        let endAngle = -.pi * 0.5 + (progress * .pi * 2)
        context?.setLineWidth(1)
        context?.move(to: aCenter)
        context?.addLine(to: CGPoint(x: centerX, y: 0))
        context?.addArc(center: aCenter, radius: radius, startAngle: -.pi * 0.5, endAngle: endAngle, clockwise: false)
        context?.fillPath()
    }
}
