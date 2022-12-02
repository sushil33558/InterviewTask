//
//  ProductListViewController.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 11/30/22.
//
import UIKit
import PageMenu
//MARK: - class
class ProductListBaseViewController: UIViewController{
    //MARK: - iBOutlet
    @IBOutlet weak var workView: UIView!
    //MARK: - variables
    var pageMenu:CAPSPageMenu?
    //MARK: - viewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem()
        pageMenuSetUp()
    }
    //MARK: - func
    func navigationItem(){
        navigationItem.title = "Product List"
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:20, height:20))
        button.tintColor = .black
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.addTarget(self, action: #selector(didTapLeft(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        //rightButton
        let secondButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:20, height:20))
        secondButton.tintColor = .black
        secondButton.setImage(UIImage(named: "filter"), for: .normal)
        secondButton.addTarget(self, action: #selector(didTapRight(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: secondButton)
    }
    
     func pageMenuSetUp(){
            var controllerArray : [UIViewController] = []
            let vc = storyboard?.instantiateViewController(identifier: "ProductList") as! ProductListViewController
            let vc1 = storyboard?.instantiateViewController(identifier: "Clothes") as! ClothesViewController
            let vc2 = storyboard?.instantiateViewController(identifier: "Shoes") as! ShoesViewController
            let vc3 = storyboard?.instantiateViewController(identifier: "Pants") as! PantsViewController
            let vc4 = storyboard?.instantiateViewController(identifier: "Trandes") as! TrandesViewController
            vc.title = "Product"
            controllerArray.append(vc)
            vc1.title = "Clothes"
            controllerArray.append(vc1)
            vc2.title = "Shoes"
            controllerArray.append(vc2)
            vc3.title = "Pants"
            controllerArray.append(vc3)
            vc4.title = "Trands"
            controllerArray.append(vc4)
            
            let parameters: [CAPSPageMenuOption] = [
                .scrollMenuBackgroundColor(.systemPurple),
                        .viewBackgroundColor(.black),
                        .selectionIndicatorColor(.white),
                        .bottomMenuHairlineColor(.white),
                .menuHeight(60.0),
                .menuItemWidth((self.workView.frame.width)/5),
                        .centerMenuItems(true),
                        .selectedMenuItemLabelColor(.white),
                        .unselectedMenuItemLabelColor(.black),
                        .menuMargin(0.0)
            ]
            
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0,y:0,width:self.workView.frame.width ,height:self.workView.frame.height
            ) , pageMenuOptions: parameters)
            
            self.addChild(pageMenu!)
            self.workView.addSubview(pageMenu!.view)
            pageMenu!.didMove(toParent: self)
        }
    
    //MARK: - @objc Func
    @objc func didTapLeft(_ sender:UIButton){
        print("LeftButtonClicked")
        let storyboard = UIStoryboard(name: "APPeNTUS", bundle: nil)
        let firstVC = storyboard.instantiateViewController(identifier: "FirstView") as! FirstViewController
        firstVC.comefrom = true
        navigationController?.pushViewController(firstVC, animated:true)
    }
    
    @objc func didTapRight(_ sender:UIButton){
        print("rightButtonClicked")
    }
}
