//
//  RequestBuilder.swift
//  TUWI
//
//  Created by MAC on 27/02/20.
//  Copyright © 2020 MAC. All rights reserved.
//


import Foundation
import Alamofire


class RequestFileData {

    let url: String

    var method: HTTPMethod = .post

    let parameters: baseParameters?

    var headers: [String : String]?

    let fileData: Data

    let fileName : String

    let fileMimetype : String

    let fileparam  :String

    

    init(url: (URLS , APISuffix), method: HTTPMethod, parameters: baseParameters? = nil, headers: Bool , fileData: Data , fileName : String , fileMimetype : String , fileParam : String) {

        self.url = url.0.getDescription() + url.1.getDescription()

        self.method = method

        self.parameters = parameters

        if let token = UserDefaults.standard.string(forKey: "token") {

            print(token)

            if(headers){

                

                self.headers = [

                    "authorization": "\(token)",

                ]

                

            }

        }

        self.fileData = fileData

        self.fileMimetype = fileMimetype

        self.fileName = fileName

        self.fileparam = fileParam

    }

    

    deinit {

        print(#file , "destructor called")

    }

}



class RequestMultipleFileData {

    let url: String

    var method: HTTPMethod = .post

    let parameters: baseParameters?

    var headers: [String : String]?

    let fileData: [Data]

    let fileName : [String]

    let fileMimetype : [String]

    let fileparam  :[String]

    

    init(url: (URLS , APISuffix), method: HTTPMethod, parameters: baseParameters? = nil, headers: Bool , fileData: [Data] , fileName : [String] , fileMimetype : [String] , fileParam : [String]) {

        self.url = url.0.getDescription() + url.1.getDescription()

        self.method = method

        self.parameters = parameters

        if let token = UserDefaults.standard.string(forKey: "token") {

            print(token)

            if(headers){

                self.headers = [

                    "authorization": "\(token)",

                ]

            }

        }

        self.fileData = fileData

        self.fileMimetype = fileMimetype

        self.fileName = fileName

        self.fileparam = fileParam

    }

    

    deinit {

        print(#file , "destructor called")

    }

}



class Request {

    var url: String

    var method: HTTPMethod = .get

    var parameters: baseParameters?

    var headers: [String : String]?

    var body: Data?

    

    init(url: (URLS , APISuffix), method: HTTPMethod, parameters: baseParameters? = nil, headers: Bool , body: Data? = nil) {

        self.url = url.0.getDescription() + url.1.getDescription()

        self.method = method

        self.parameters = parameters

        if let token = UserDefaults.standard.string(forKey: "token") {

            print(token)

            if(headers){

                self.headers = [

                    "authorization": "\(token)",

                ]

            }

        }

        self.body = body

    }

    

    deinit {

        print(#file , "destructor called")

    }

}

