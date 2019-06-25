//
//  RectRadarAnimationView.swift
//  RectRadarAnimationView
//
//  Created by damon on 2019/6/25.
//  Copyright © 2019 damon. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 给View添加雷达动画
    ///
    /// - Parameters:
    ///   - inset: 当前frame加上内边距作为起始Frame
    ///   - fillColor: 渐变填充色
    ///   - increment: 扩展范围
    ///   - beginAlpha: 初始透明度
    func addRadarAnimation(inset: UIEdgeInsets = .zero, fillColor: UIColor = .white, expand increment: CGFloat = 30, beginAlpha: CGFloat = 0.5) {
        removeRadarAnimation()
        let radarView = RectRadarAnimationView(beginFrame: frame.inset(by: inset), expand: increment, fillColor: fillColor, beginAlpha: beginAlpha)
        radarView.targetView = self
        radarView.snp.makeConstraints {
            $0.center.equalTo(self)
            $0.size.equalTo(radarView.frame.size)
        }
        radarView.addAnimation()
    }
    
    /// 移除雷达动画
    func removeRadarAnimation() {
        superview?.subviews.forEach {
            if let radarView = $0 as? RectRadarAnimationView, radarView.targetView === self {
                $0.removeFromSuperview()
            }
        }
    }
}

class RectRadarAnimationView: UIView {
    
    weak var targetView: UIView? {
        didSet {
            guard let targetView = targetView else {
                return
            }
            targetView.superview?.insertSubview(self, belowSubview: targetView)
        }
    }

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
    
    deinit {
        print("deinit success")
    }
    
    func addAnimation() {
        removeAnimation()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(addRadarView), userInfo: nil, repeats: true)
        timer.map { RunLoop.current.add($0, forMode: .common) }
        timer?.fire()
        displayLink = CADisplayLink(target: self, selector: #selector(radarAnimation))
        displayLink?.add(to: RunLoop.current, forMode: .common)
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
