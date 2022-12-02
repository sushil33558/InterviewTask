//
//  ProductDetailViewController.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 11/30/22.
//
import UIKit
import SDWebImage
//MARK: - class
class ProductDetailViewController: UIViewController {
    //MARK: - iBOutlet
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    @IBOutlet weak var CountLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var cartOutLet: UIButton!
    //MARK: - variables
    var productImage:String?
    var titles: String?
    var Desc: String?
    var Count: String?
    var Price: String?
    
    //MARK: - viewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        cartOutLet.layer.cornerRadius = (cartOutLet.frame.height-2)/2
        navigationItem()
        modelDataSet()
    }
    
    //MARK: - iBAction
    @IBAction func addToCartBtn(_ sender: UIButton) {
    }

    //MARK: - func
    func navigationItem(){
        navigationItem.title = "Product Detail"
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:20, height:20))
        button.tintColor = .black
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.addTarget(self, action: #selector(didTapLeft(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        //rightButton
        let secondButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width:20, height:20))
        secondButton.tintColor = .black
        secondButton.setImage(UIImage(named: "bookmark"), for: .normal)
        secondButton.addTarget(self, action: #selector(didTapRight(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: secondButton)
    }
    func modelDataSet(){
        self.subView.layer.borderColor = UIColor.systemPurple.cgColor
        self.subView.layer.borderWidth = 1
        self.DescLbl.text = "Description:\(Desc ?? "")"
        self.PriceLbl.text = "$:\(Price ?? "")"
        self.titleLbl.text = "Title:\(titles ?? "")"
        self.CountLbl.text = "Count:\(Count ?? "")"
        self.detailImageView.sd_setImage(with: URL(string: "\(productImage ?? "")"))
    }
    
    //MARK: - @objc Func
    @objc func didTapLeft(_ sender:UIButton){
        print("LeftButtonClicked")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapRight(_ sender:UIButton){
        print("rightButtonClicked")
    }
}
//MARK: - extension
