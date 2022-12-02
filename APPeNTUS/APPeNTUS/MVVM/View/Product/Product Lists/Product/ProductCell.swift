//
//  ProductCell.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 12/1/22.
//

import UIKit
class ProductCell: UICollectionViewCell {
    //MARK: - iBOutlet
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var bookMarkBtn: UIButton!
    @IBOutlet weak var productNameLbl: UILabel!
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
