//
//  Request.swift
//
//  Created by MAC on 27/02/20.
//  Copyright © 2020 MAC. All rights reserved.


import Foundation
import Alamofire

typealias BaseAPICompletion = (Any?, String? , Int) -> Swift.Void

typealias BaseAPIResult = SynchronousDataTaskResult

typealias baseParameters = [String : AnyObject]

typealias SynchronousDataTaskResult = (Any? , URLResponse? , Error?)
typealias FileData = (Data? , String? , Int) -> Void

typealias FinalSuccess = (Bool , String) -> Void
typealias GenericsResult<T: Codable> = (Result<T, GenericErrorResponse>) -> Void

enum GenericErrorResponse: Error {
    case custom(String)
    case unknown
}

func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

extension Data: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self
        return request
    }
}

class BaseAPI: NSObject {
    
    private enum ErrorsApi: Error {
        case unKnown
    }
    
    var task: DataRequest?
    var request : URLRequest?
    var uploadRequest: UploadRequest?
    
    override init() {
        super.init()
        print(#file , "initializer")
    }
    
    
    deinit {
        print(#file , "destructed")
    }
    
    
    func checkForValidation(withData data: Any? , completion: FinalSuccess ) -> Void {
        if  (((data as? [String:Any])?["success"] as? Int) ?? 400) == 200 {
            completion(true , (((data as? [String:Any])?["message"] as? String) ?? "Success"))
        } else {
            completion(false , (((data as? [String:Any])?["message"] as? String) ?? ""))
        }
    }
    
    /**
     Generic Api to get any data modle in return
     this method will work only if data key is present under incoming json
     
     - Need Codeble Type to encode data
     */
    

    func hitGenericsApi<T: Codable>(of type: T.Type,
                                    requests : Request ,
                                    completion: @escaping GenericsResult<T>)  {


        var request = URLRequest(url: URL(string: requests.url)!)

        request.httpMethod = requests.method.rawValue

        request.allHTTPHeaderFields = requests.headers ?? [:]


        if requests.parameters != nil {
            defer{
                print("------------- PARAMETERS---------------")
            }
            print("------------- PARAMETERS---------------")


            // print(requests.parameters)
            do {
                request.httpBody = try? JSONSerialization.data(withJSONObject: requests.parameters ?? [:], options: .prettyPrinted)
            }
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        self.task = AF.request(request as URLRequestConvertible)

        print("---------- GENERICS LOGGER START -------------")
        //  NetworkLogger.log(request: ((self.task?.convertible.urlRequest)!))

        self.task?.responseJSON { [weak self] (responsee) in

            print("---------- GENERICS LOGGER END-------------")
            self?.serializedResponse(withResponse: responsee, clouser: { (receivedData, message, response) in

                if response == 1 {
                    do {


                        //                        if (((receivedData  as? [String:Any])?["success"] as? Int) ?? 400) == 200 {
                        //                            let jsonData = try JSONSerialization.data(withJSONObject: ((receivedData as? [String:Any])?["body"] as Any), options: .prettyPrinted)
                        //                            let decodedJson = try JSONDecoder().decode(T.self, from: jsonData)
                        //
                        //                            completion(.success(decodedJson))
                        //                        }

                        if ((((receivedData  as? [String:Any])?["response"] as? Int) ?? 400)) == 1 {

                            let jsonData = try JSONSerialization.data(withJSONObject: ((receivedData as? [String:Any])?["result"] as Any), options: .prettyPrinted)

                            let decodedJson = try JSONDecoder().decode(T.self, from: jsonData)



                            completion(.success(decodedJson))
                        } else {
                            completion(.failure(.custom((((receivedData  as? [String:Any])?["message"] as? String) ?? "404"))))
                        }

                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.custom(error.localizedDescription)))
                    }

                } else {
                    if let errora = responsee.error {
                        completion(.failure(.custom((errora.errorDescription ?? ""))))
                    } else {
                        completion(.failure(.custom((message ?? ""))))
                    }
                }
            })
        }
    }
    
    //
    //    func hitApiJsonBody(requests : Request , completion : @escaping BaseAPICompletion ) {
    //
    //         // for alamofire v 5.0.0
    //
    //        var req: URLRequest?
    //
    //        do {
    //            req = try URLRequest(url: requests.url, method: requests.method, headers: (requests.headers ?? [:]))
    //
    //            req?.httpBody = try JSONSerialization.data(withJSONObject: (requests.parameters ?? [:]), options: .prettyPrinted)
    //
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //
    //        guard let reqq = req else { return }
    //
    //         self.task = AF.request(reqq)
    //
    //        // NetworkLogger.log(request: ((self.task?.convertible.urlRequest)!))
    //
    //         self.task?.responseJSON { [weak self] (response) in
    //
    //             self?.serializedResponse(withResponse: response, clouser: { (receivedData, message, response) in
    //                 completion(receivedData,message,response)
    //             })
    //         }
    //     }
    
    
    /**
     This is for get , post , patch , put type apis
     - getting data from internet
     - checking status code generated by alamofire
     */
//    func hitApiWithMultipleFile(requests : RequestMultipleFileData , completion : @escaping BaseAPICompletion ) {
//
//
//
//            var request = URLRequest(url: URL(string: requests.url)!)
//
//
//
//            request.httpMethod = requests.method.rawValue
//
//
//
//            request.allHTTPHeaderFields = requests.headers
//
//
//
//            let parameters = requests.parameters ?? [:]
//
//
//
//            if requests.parameters != nil {
//
//                do {
//
//                    request.httpBody = try? JSONSerialization.data(withJSONObject: requests.parameters ?? [:], options: .prettyPrinted)
//
//                }
//
//            }
//
//
//
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//
//
//            dump(request)
//
//
//
//            AF.upload(multipartFormData: { multipart_FormData in
//
//
//
//                for i in 0..<requests.fileData.count {
//
//                    multipart_FormData.append(requests.fileData[i], withName: requests.fileparam[i], fileName: requests.fileName[i], mimeType: requests.fileMimetype[i])
//
//                }
//
//
//
//                for (key, value) in parameters {
//
//
//
//                    if let array = value as? [AnyObject] {
//
//
//
//                        for i in array {
//
//                            multipart_FormData.append(String(describing: i).data(using: String.Encoding.utf8)!, withName: key as String)
//
//                        }
//
//
//
//                        /*   if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
//
//                         multipart_FormData.append(jsonData, withName: key as String)
//
//                         _}
//
//                         _            */
//
//
//
//                    }else if let _ = value as? Parameters {
//
//
//
//                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
//
//                            multipart_FormData.append(jsonData, withName: key as String)
//
//                        }
//
//
//
//                    } else {
//
//                        multipart_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//
//
//
//                    }
//
//
//
//                }
//
//
//
//            },with: request,encodingCompletion: { encodingResult in
//
//
//
//                switch encodingResult {
//
//
//
//                case .success(let upload, let error, let data):
//
//
//
//                    upload.responseJSON { response in
//
//
//
//                        if let json = response.result.value {
//
//
//
//                            switch response.response?.statusCode ?? -91 {
//
//
//
//                            case 0...100 :
//
//                                completion(json, response.result.description , 0)
//
//
//
//                            case 101...199 :
//
//                                completion(json, response.result.description, 0)
//
//
//
//                            case 200...299:
//
//                                print("* * * * * *  SUCCESS * * * * * * ")
//
//                                completion(json, response.result.description ,1)
//
//
//
//                            case 300...399:
//
//                                completion(json, response.result.description ,2)
//
//
//
//                            default :
//
//                                completion(json,response.result.description, 2)
//
//                            }
//
//
//
//
//
//                        }else {
//
//                            completion(nil,response.result.description, 2)
//
//
//
//                        }
//
//                    }
//
//                case .failure(let encodingError):
//
//
//
//                    completion(["Error":encodingError] as Any,"Error", 2)
//
//
//
//                }
//
//            })
//
//        }
    
    func hitApi(requests : Request , completion : @escaping BaseAPICompletion ) {
        
        // for alamofire v 5.0.0
        
        var request = URLRequest(url: URL(string: requests.url)!)
        
        request.httpMethod = requests.method.rawValue
        
        request.allHTTPHeaderFields = requests.headers ?? [:]
        
        
        if requests.parameters != nil {
            defer{
                print("------------- PARAMETERS---------------")
            }
            print("------------- PARAMETERS---------------")
            print(requests.parameters)
            do {
                request.httpBody = try? JSONSerialization.data(withJSONObject: requests.parameters ?? [:], options: .prettyPrinted)
            }
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.task = AF.request(request as URLRequestConvertible)
        
        //   NetworkLogger.log(request: ((self.task?.convertible.urlRequest)!))
        
        self.task?.responseJSON { [weak self] (response) in
            self?.serializedResponse(withResponse: response, clouser: { (receivedData, message, response) in
                completion(receivedData,message,response)
                self?.task = nil
            })
        }
    }
    
    
    /**
     Method to cancel the currently running request
     */
    
    func cancelCurrentRequest() {
        self.task?.cancel()
        self.request = nil
    }
    
    /**
     The below function is used to download images from server and sets to user's profile image.
     */
    
    //
    //    func downloadFile(fileUrls : URLS , completion : @escaping FileData) -> Void{
    //
    //        let finalUrl = fileUrls.getDescription
    //        guard let url = URL(string: finalUrl) else { print("Error in URl");
    //            print(finalUrl)
    //            completion(nil , "", 0)
    //            return
    //        }
    //
    //        print(url)
    //
    //        self.task = AF.request(url).responseData { (response) in
    //
    //            print(response)
    //
    //            if response.response != nil {
    //
    //                if let _data = response.data {
    //
    //                    switch response.response?.statusCode ?? -91 {
    //
    //                    case 0...100 :
    //                        print("* * * * * * * FAILED * * * * * * ")
    //                        completion(_data, "" , 0)
    //
    //                    case 101...199 :
    //                        print("* * * * * * * FAILED * * * * * * ")
    //                        completion(_data, "", 0)
    //
    //                    case 200...299:
    //                        print("* * * * * * * SUCCESS * * * * * * ")
    //                        completion(_data, "" ,1)
    //
    //                    case 300...399:
    //                        print("* * * * * * * FAILED * * * * * * ")
    //                        completion(_data, "" ,2)
    //
    //                    default :
    //                        print("* * * * * * * FAILED * * * * * * ")
    //                        completion(_data,"", 2)
    //                    }
    //
    //                } else {
    //                    completion(nil,"", 2)
    //                }
    //            } else {
    //                completion(nil,"", 2)
    //            }
    //        }
    //    }
    
    
    func hitApiWithMultipleFile(requests : RequestMultipleFileData , completion : @escaping BaseAPICompletion ) {

        var request = URLRequest(url: URL(string: requests.url)!)

        request.httpMethod = requests.method.rawValue


        request.allHTTPHeaderFields = requests.headers ?? [:]

        let parameters = requests.parameters ?? [:]


        if requests.parameters != nil {
            do {
                request.httpBody = try? JSONSerialization.data(withJSONObject: requests.parameters ?? [:], options: .prettyPrinted)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        //  NetworkLogger.log(request: request)

        self.uploadRequest = AF.upload(multipartFormData: { multipart_FormData in

            for i in 0..<requests.fileData.count   {

                multipart_FormData.append(requests.fileData[i], withName: requests.fileparam[i], fileName: requests.fileName[i], mimeType: requests.fileMimetype[i])

                /**
                 UnComment if API is unable to send multiple datas.
                 */

            }

                for (key, value) in parameters {

                    if let array = value as? [AnyObject] {

                        for i in array {
                            multipart_FormData.append(String(describing: i).data(using: String.Encoding.utf8)!, withName: key as String)
                        }

                        /*   if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
                         multipart_FormData.append(jsonData, withName: key as String)
                         _}
                         _            */

                    }else if let _ = value as? Parameters {

                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
                            multipart_FormData.append(jsonData, withName: key as String)
                        }

                    } else {
                        multipart_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)

                    }

                }


        }, with: request).responseJSON { [weak self] (response) in

            // NetworkLogger.log(response: response.response ?? URLResponse())

            self?.serializedResponse(withResponse: response, clouser: { (receivedData, message, response) in
                completion(receivedData,message,response)
                self?.uploadRequest = nil
            })
        }

        self.uploadRequest?.uploadProgress(closure: { (progress) in
            print()
            print("Uploading Data " , ((progress.fractionCompleted) * (100.00) / 1.0) , "%"  , " Total Count " , "100%")
            print()
        })
    }
    /**
     
     This is for post type to upload any single file
     
     - getting data from internet
     - upload data to internet
     
     */
    
//    func hitApiWithSingleFile(requests : Reques , completion : @escaping BaseAPICompletion ) {
//
//        var request = URLRequest(url: URL(string: requests.url)!)
//
//        request.httpMethod = requests.method.rawValue
//
//        request.allHTTPHeaderFields = requests.headers ?? [:]
//
//        let parameters = requests.parameters ?? [:]
//
//        if requests.parameters != nil {
//            do {
//                request.httpBody = try? JSONSerialization.data(withJSONObject: requests.parameters ?? [:], options: .prettyPrinted)
//            }
//        }
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // NetworkLogger.log(request: request)
//
//        self.uploadRequest = AF.upload(multipartFormData: { multipart_FormData in
//
//            multipart_FormData.append(requests.fileData, withName: requests.fileparam, fileName: requests.fileName, mimeType: requests.fileMimetype)
//
//            for (key, value) in parameters {
//
//                if let array = value as? [AnyObject] {
//
//                    for i in array {
//                        multipart_FormData.append(String(describing: i).data(using: String.Encoding.utf8)!, withName: key as String)
//                    }
//
//                    /*   if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
//                     multipart_FormData.append(jsonData, withName: key as String)
//                     _}
//                     _            */
//
//                }else if let _ = value as? Parameters {
//
//                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
//                        multipart_FormData.append(jsonData, withName: key as String)
//                    }
//
//                } else {
//                    multipart_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//
//                }
//
//            }
//
//        }, with: request).responseJSON { [weak self] (response) in
//
//            //  NetworkLogger.log(response: response.response ?? URLResponse())
//
//            self?.serializedResponse(withResponse: response, clouser: { (receivedData, message, response) in
//                completion(receivedData,message,response)
//                self?.uploadRequest = nil
//            })
//        }
//
//        self.uploadRequest?.uploadProgress(closure: { (progress) in
//            print()
//            print("Uploading Data " , ((progress.fractionCompleted) * (100.00) / 1.0) , "%"  , " Total Count " , "100%")
//            print("\(String(describing: progress.fileURL))")
//            print()
//        })
//    }
    
    
    /**
     This function is used to return clouser of serialized response
     - take argument as dataresponse
     - return clouser
     */
    
    func serializedResponse(withResponse response: DataResponse<Any, AFError> , clouser: @escaping BaseAPICompletion) {
        
        // NetworkLogger.log(response: response.response ?? URLResponse())
        
        if response.response != nil {
            
            if let json = response.data {
                
                switch (response.response?.statusCode ?? -91) {
                    
                case 0...100 :
                    print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                    
                    clouser(json, response.error?.localizedDescription , 0)
                    
                case 101...199 :
                    print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                    
                    clouser(json, response.error?.localizedDescription, 0)
                    
                case 200...299:
                    
                    print(" 🎉 🎉 🎉 🎉 🎉 🎉 🍺 🍺 🍺 🍺 🍺 🍺")
                    switch response.result {
                    case .success(let data):
                        print(data)
                        
                        clouser(data, response.description ,1)
                    case .failure(let error):
                        
                        clouser(error, response.description ,0)
                    }
                    
                case 300...399:
                    print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                    
                    clouser(json, response.error?.localizedDescription ,2)
                    
                    
                    case 400...499:
                        

                    print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                    
                    switch response.result {
                    case .success(let data):
                        print(data)
                        
                        clouser(data, (((data as? [String:Any])?["errors"] as? [String:Any])?["msg"] as? String ?? "") ,2)
//                    case .failure(let error):
//
//                        clouser(error, response.description ,0)
                    case .failure(let error):
                         clouser(error, response.description ,2)
                    }
                    
                case 500...599:
                    
                    clouser(json , "Database Error." , 2)
                    
                default :
                    print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                    
                    clouser(json,response.description, 2)
                }
                
            } else {
                print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
                
                clouser(nil,response.description, 2)
            }
        } else {
            
            
            print("🤬 🤬 🤬 🤬 🤬 FAILED 🤬 🤬 🤬 🤬 🤬 ")
            
            clouser(nil,"Unable to connect to the server", 2)
        }
    }
}


extension BaseAPI {
    
    //    public func synchronousDataTask(request : Request) -> SynchronousDataTaskResult {
    //        let semaphore = DispatchSemaphore(value: 0)
    //
    //        var data: Data?
    //        var responses: URLResponse?
    //        var error: Error?
    //
    //        let task = AF.request(request.url, method: request.method, parameters: request.parameters, encoding: JSONEncoding.default, headers: request.headers)

    //        task.responseData { (response) in
    //            data = response.data
    //            error = response.error
    //            responses = URLResponse(url: ((response.request?.url)!), mimeType: "", expectedContentLength: 0, textEncodingName: "default")
    //            semaphore.signal()
    //        }
    //        _ = semaphore.wait(timeout: .distantFuture)
    //
    //        return (data, responses, error)
    //    }
}

