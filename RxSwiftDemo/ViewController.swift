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
- First, we have to create a Driver. The general way to do this is to simply convert an Observable to a Driver using the Observable's asDriver()
-  Given that, it doesn’t usually matter where the conversion to a Driver happens in a chain. I could have done it before the scan above, if I preferred. Just remember everything that comes after will be on the main thread.
-
 */

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: ivars
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.button.rx.tap //Start with UIButton Tap
            .scan(0) { (priorValue, _) in //scan all occurences; start with  and add 1 each time
                return priorValue + 1
            }
            .asDriver(onErrorJustReturn: 0) //convert the scan to a Driver to ensure we never fail and are on the main thread
            .map({ currentCount in
                return "You have tapped that button \(currentCount) times" //convert Int to String
            })
            .drive(self.label.rx.text) //push the value onto a UILabel
            .disposed(by: disposeBag)
    }
}


