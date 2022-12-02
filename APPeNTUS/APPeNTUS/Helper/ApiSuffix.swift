//
//  ApisSuffix.swift
//
//  Created by Varjeet on 9/17/21.
//  Copyright © 2021 Temp. All rights reserved.
//

import Foundation
//MARK: - enums(endPoint)
enum APISuffix {
    case product
    func getDescription() -> String
    {
        switch self {
        case .product:
            return "products"
        }
    }
}
//MARK: - enums(url)
enum URLS {
    case baseUrl
    func getDescription() -> String {
        switch self {
        case .baseUrl :
            return "https://fakestoreapi.com/"
        }
    }
}
//MARK: -
class UnifonicSmsGateway {
    
    var messageBody: String = ""
    let recipient: String
    let appSid: String = "evxaORfSlxgB7t3_NbAGclushgrQPl"
        
    
    init(otp: String , recipient: String) {
        self.messageBody = "Dear user, " + "\n" + otp + " is your one time password(OTP)." + "\n" + "Please enter the otp to proceed." + "\n" + "Thank you," + "\n" + "Team TAJR."
        self.recipient = recipient
    }
    
    deinit {
        print(#file , "UniFormSmsgateway Destructed")
    }
}
