//
//  ProductListViewModel.swift
//  APPeNTUS
//
//  Created by Sushil Chaudhary on 11/30/22.
//

import Foundation
class ProductViewModel:BaseAPI{
    //MARK: - Variables
    var Model : [ProductElement]?
    
    //MARK: - Api Implement
    func getProductAPi(completion:@escaping(Bool,String)->()){
        let request = Request(url: (URLS.baseUrl,APISuffix.product), method: .get, parameters: nil, headers: false)
        super.hitApi(requests: request){
           (receievedData,message,responseCode) in
            if responseCode == 1{
                if let data = receievedData as? [[String:Any]]{
                            do{
                                let jsonSer = try JSONSerialization.data(withJSONObject: data, options:.prettyPrinted)
                                self.Model = try JSONDecoder().decode([ProductElement].self, from:jsonSer)
                                completion(true,message ?? "")
                            }catch{
                                print(error)
                                completion(false,message ?? "") //8
                            }
                        }else{
                            completion(false,message ?? "") //8
                        }
                    }else{
                        completion(false,message ?? "") //8
                    }
            }
    }
}
