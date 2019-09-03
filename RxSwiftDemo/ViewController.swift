//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Casey Liss on 13/12/16.
//  Copyright © 2016 Casey Liss. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
  - Generally speaking, each class/struct that is doing subscribe()ing gets one shared DisposeBag, and all subscriptions get added to it. That’s it.
  - A ControlEvent is a special kind of something else: an Observable. A control Event is a wrapper of TouchUpInside:
  - Generally speaking, the last operation you’ll perform on an Observable—on a stream—is to take action based on that stream signaling. In our case, how do we take action every time the button is tapped?

 */


class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: ivars
    private let disposeBag = DisposeBag()
    private var count = 0
    
    override func viewDidLoad() {
        self.button.rx.tap
            .debug("button tap")
            .subscribe(onNext: { [unowned self] _ in
                self.onButtonTap()
            }).disposed(by: disposeBag)
    }
    
    @IBAction private func onButtonTap() {
        self.count += 1
        self.label.text = "You have tapped that button \(count) times."
    }
}


