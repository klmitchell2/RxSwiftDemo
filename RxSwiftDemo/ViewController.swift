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
    private lazy var viewModel: ViewModel = {
        return ViewModel(buttonTapped: self.button.rx.tap
            .asObservable()
            .debug("after asObservable"))
    }()

    override func viewDidLoad() {
        setupBindings()
    }

    func setupBindings() {
        self.viewModel.count
            .asDriver(onErrorJustReturn: 0)
            .debug("After asDriver")
            .map { currentCount in
                return "taps coming from viewModel: \(currentCount)"
            }
            .debug("After map")
            .drive(self.label.rx.text)
            .disposed(by: disposeBag)
    }
}

class ViewModel {
    let count: Observable<Int>

    init(buttonTapped: Observable<Void>) {
        self.count = buttonTapped.scan(0, accumulator: { (prevValue, _) in
            return prevValue + 1
        })
        .debug("After scan")
    }
}
