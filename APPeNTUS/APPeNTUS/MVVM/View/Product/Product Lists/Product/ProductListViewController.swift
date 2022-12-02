//
//  ProductListViewController.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 12/1/22.
//
import UIKit
import ANActivityIndicator
import SDWebImage
class ProductListViewController: UIViewController {
    //MARK: - iBOutlet
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    //MARK: - variables
    var viewModel = ProductViewModel()
    
    //MARK: - viewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        productCollectionView.register(UINib(nibName:"ProductCell", bundle:nil), forCellWithReuseIdentifier: "ProductCell")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - func
    func apiCall(){
        showIndicator()
        viewModel.getProductAPi { (isSuccess, message) in
            self.hideIndicator()
            if isSuccess{
                print("----------------------Api Succeed.-----------------------")
                self.productCollectionView.reloadData()
            }else{
                print("----------------------Api not Been Succeed.-----------------------")
            }
        }
    }
    
    //MARK: - @objc Func
    @objc func DidTapBookMarkBtn(_ sender:UIButton){
        print("AddBookMark func Called.")
    }
    
}
//MARK: - extension
extension ProductListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   //DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.Model?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier:
            "ProductCell", for: indexPath) as! ProductCell
        cell.bookMarkBtn.tag = indexPath.row
        cell.bookMarkBtn.addTarget(self, action: #selector(DidTapBookMarkBtn(_:)), for: .touchUpInside)
        cell.productImageView.sd_setImage(with: URL(string: "\(viewModel.Model?[indexPath.row].image ?? "")"))
        cell.productPriceLbl.text = "$:\(viewModel.Model?[indexPath.row].price ?? 0)"
        cell.productNameLbl.text = "Name: \(viewModel.Model?[indexPath.row].title ?? "")"
        cell.layer.borderColor = UIColor.systemPurple.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 7
        return cell
    }
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "APPeNTUS", bundle: nil)
        let ProductDetail = storyboard.instantiateViewController(identifier: "ProductDetail") as! ProductDetailViewController
        ProductDetail.Count = "\(viewModel.Model?[indexPath.row].rating?.count ?? 0)"
        ProductDetail.Price = "\(viewModel.Model?[indexPath.row].price ?? 0)"
        ProductDetail.titles = "\(viewModel.Model?[indexPath.row].title ?? "")"
        ProductDetail.Desc = "\(viewModel.Model?[indexPath.row].productDescription ?? "")"
        ProductDetail.productImage = "\(viewModel.Model?[indexPath.row].image ?? "")"
        navigationController?.pushViewController(ProductDetail, animated: true)
    }
    
    //Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(productCollectionView.frame.width+7)/2.1, height:productCollectionView.frame.height/3)
    }
}
