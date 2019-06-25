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
    }

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
}

