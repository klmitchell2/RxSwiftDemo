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

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: ivars
    private let disposeBag = DisposeBag()


    let viewModel = ViewModel()

    override func viewDidLoad() {
        setupBindings()
    }

    func setupBindings() {
        button.rx.tap.bind(to: viewModel.buttonTapped).disposed(by: disposeBag)
        viewModel.labelText.drive(label.rx.text).disposed(by: disposeBag)
    }
}

class ViewModel {
    //private let count = BehaviorRelay<Int>(value: 0) //is mutable even though not var, changing the value property within the BehaviorRelay.
    private let count: Observable<Int>
    let labelText: Driver<String>
    let buttonTapped = PublishRelay<Void>()

    init() {
        count = buttonTapped.scan(0) { (preValue, _) in
            return preValue + 1
        }

        labelText = count.map{ "taps coming from viewModel: \($0)" }.asDriver(onErrorJustReturn: "error")

        /*Can use this approach, but is a bit more fragile with having to subscribe, worry about retain cycles, and disposing of the subscription */
//        buttonTapped.subscribe(onNext: { [weak self] in
//            guard let strongself = self else { return }
//            strongself.count.accept(strongself.count.value + 1)
//        }).disposed(by: disposeBag) //need dispose bage because we are subscribing

    }
}


