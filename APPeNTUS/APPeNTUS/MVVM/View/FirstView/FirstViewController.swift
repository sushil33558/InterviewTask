//
//  FirstViewController.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 11/30/22.
//

import UIKit
class FirstViewController: UIViewController {
    //MARK: - variables
    var comefrom:Bool?
    //MARK: - lifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  "First View"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if comefrom == true{
            navigationItem()
        }
    }
    //MARK: - func
    func navigationItem(){
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:20, height:20))
        button.tintColor = .black
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.addTarget(self, action: #selector(didTapLeft(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    //MARK: - @objc Func
    @objc func didTapLeft(_ sender:UIButton){
        print("LeftButtonClicked")
        self.navigationController?.popViewController(animated: true)
    }
}
