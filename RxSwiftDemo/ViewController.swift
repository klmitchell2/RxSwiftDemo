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
 - Can use Scan() instead of Reduce(), accomplishes the same thing.
 - This branch shows the removal of ALL stored state in this class
 */

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: ivars
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.button.rx.tap
            .debug("Button Tap")
            .scan(0) { (priorValue, _) in
                return priorValue + 1
            }
            .debug("after scan")
            .map({ currentCount in
                return "You have tapped that button \(currentCount) times"
            })
            .debug("after debug")
            .subscribe(onNext: { [weak self] newText in
                return self?.label.text = newText
            })
            .disposed(by: disposeBag)
    }
}


