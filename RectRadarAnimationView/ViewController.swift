//
//  ViewController.swift
//  RectRadarAnimationView
//
//  Created by damon on 2019/6/25.
//  Copyright © 2019 damon. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .gray
        
        view.addSubview(rectView1)
        view.addSubview(rectView2)
        view.addSubview(rectView3)
        view.addSubview(clearButton)
        view.addSubview(startButton)
        
        rectView1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(rectView2).offset(-200)
            $0.size.equalTo(rectView1.frame.size)
        }
        
        rectView2.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(rectView2.frame.size)
        }
        
        rectView3.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(rectView2).offset(200)
            $0.size.equalTo(rectView3.frame.size)
        }
        
        startButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.bottom.equalTo(-30)
            $0.size.equalTo(startButton.frame.size)
        }
        
        clearButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-50)
            $0.bottom.equalTo(-30)
            $0.size.equalTo(clearButton.frame.size)
        }
        
        startRadarAnimation()
    }
    
    @objc
    private func clearRadarAnimation() {
        rectView1.removeRadarAnimation()
        rectView2.removeRadarAnimation()
        rectView3.removeRadarAnimation()
    }
    
    @objc
    private func startRadarAnimation() {
        rectView1.addRadarAnimation(fillColor: .blue)
        rectView2.addRadarAnimation(fillColor: .orange, expand: 50, beginAlpha: 0.8)
        rectView3.addRadarAnimation()
    }
    
    // MARK: - lazy

    private lazy var rectView1: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .cyan
        return view
    }()
    
    private lazy var rectView2: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .purple
        return view
    }()
    
    private lazy var rectView3: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 150))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .yellow
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        btn.setTitle("开始动画", for:.normal)
        btn.addTarget(self, action: #selector(startRadarAnimation), for: .touchUpInside)
        return btn
    }()
    
    private lazy var clearButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        btn.setTitle("清楚动画", for:.normal)
        btn.addTarget(self, action: #selector(clearRadarAnimation), for: .touchUpInside)
        return btn
    }()
}

