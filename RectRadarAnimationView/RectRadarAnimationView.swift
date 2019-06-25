//
//  RectRadarAnimationView.swift
//  RectRadarAnimationView
//
//  Created by damon on 2019/6/25.
//  Copyright © 2019 damon. All rights reserved.
//

import UIKit

extension UIView {
    func addRadarAnimation(fillColor: UIColor = .white, expand increment: CGFloat = 30, inset: UIEdgeInsets = .zero, beginAlpha: CGFloat = 0.5) {
        guard let superView = self.superview else {
            return
        }
        let radarView = RectRadarAnimationView(beginFrame: frame.inset(by: inset), expand: increment, fillColor: .white, beginAlpha: beginAlpha)
        superView.insertSubview(radarView, belowSubview: self)
        radarView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.size.equalTo(radarView.frame.size)
        }
        radarView.addAnimation()
    }
}

class RectRadarAnimationView: UIView {

    private var displayLink: CADisplayLink?
    
    private var timer: Timer?
    
    private var maxIncrement: CGFloat
    
    private var fillColor: UIColor

    private var beginAlpha: CGFloat
    
    init(beginFrame frame: CGRect,  expand increment: CGFloat, fillColor: UIColor, beginAlpha: CGFloat) {
        self.maxIncrement = increment
        self.fillColor = fillColor
        self.beginAlpha = beginAlpha
        super.init(frame: frame.inset(by: UIEdgeInsets(-increment)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAnimation() {
        removeAnimation()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(addRadarView), userInfo: nil, repeats: true)
        timer.map {
            RunLoop.current.add($0, forMode: .common)
        }
        displayLink = CADisplayLink(target: self, selector: #selector(radarAnimation))
        displayLink?.add(to: RunLoop.current, forMode: .default)
    }
    
    func removeAnimation() {
        timer?.invalidate()
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc
    func radarAnimation() {
        subviews.forEach {
            if let radarView = $0 as? RadarView {
                radarView.progress += 0.005
                if radarView.progress >= 1.0 {
                    radarView.removeFromSuperview()
                }
            }
        }
    }
    
    @objc
    func addRadarView() {
        let radarView = RadarView(beginFrame: bounds.inset(by: UIEdgeInsets(maxIncrement)), expand: maxIncrement, fillColor: fillColor, beginAlpha: beginAlpha)
        addSubview(radarView)
    }
    
    override func removeFromSuperview() {
        removeAnimation()
        super.removeFromSuperview()
    }

}

extension RectRadarAnimationView {
    private class RadarView: UIView {
        
        /// 进度 0.0...1.0
        var progress: CGFloat = 0 {
            didSet {
                setNeedsDisplay()
            }
        }
        
        /// 开始的矩形位置
        private var beginFrame: CGRect
        
        /// layer最大扩展范围
        private var increment: CGFloat
        
        /// 填充色
        private var fillColor: UIColor
        
        /// 初始透明度
        private var beginAlpha: CGFloat
        
        init(beginFrame: CGRect, expand increment: CGFloat, fillColor: UIColor, beginAlpha: CGFloat) {
            self.beginFrame = beginFrame
            self.increment = increment
            self.fillColor = fillColor
            self.beginAlpha = beginAlpha
            super.init(frame: beginFrame.inset(by: UIEdgeInsets(-increment)))
            self.backgroundColor = .clear
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let currnetIncrement = increment * progress
            let drawRect = beginFrame.inset(by: UIEdgeInsets(-currnetIncrement))
            let ctx = UIGraphicsGetCurrentContext()
            let path = UIBezierPath(roundedRect: drawRect, cornerRadius: min(drawRect.width, drawRect.height) * 0.5).cgPath
            ctx?.addPath(path)
            ctx?.setFillColor(fillColor.withAlphaComponent((1 - progress) * beginAlpha).cgColor)
            ctx?.fillPath()
        }
    }
}

private extension UIEdgeInsets {
    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}
