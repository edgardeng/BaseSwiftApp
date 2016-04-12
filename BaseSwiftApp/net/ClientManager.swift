//
//  ClientManager.swift
//  BaseSwiftApp
//
// https://github.com/Moya/Moya  对 alamofire的封装

//
//  Created by 邓曦曦 on 16/3/30.
//  Copyright © 2016年 Edgar Deng. All rights reserved.
//

import Foundation
import Alamofire

class ClientManager: AnyObject {
    
    var END_POINT = "https://api.github.com/";
    
    
    /**  以下是对 alamofire 的简单应用 的示例   */
    
    
    func _Get(){
        let request = Alamofire.request(.GET, END_POINT)
        print(request)
        let response = request.response;
        print(response);
    }
    
    func _Get(param:[String : AnyObject]){
        Alamofire.request(.GET, END_POINT, parameters: param)
    }
    
    func _AsynGet(){
        
        Alamofire.request(.GET, END_POINT+"users/edgardeng")
             .response { (request, response, data, error) in
                        print(request)
                        print("\r\n response:")
                        print(response)
                        print("\r\n data:")
                        print(data)
                        print("\r\n eroor:")
                        print(error)
                    }
    }
 
    func _Post(){
        let parameters = [
                 "foo": "bar",
                 "baz": ["a", 1],
                 "qux": [
                     "x": 1,
                     "y": 2,
                     "z": 3
                 ]
             ]
        Alamofire.request(.POST, "http://httpbin.org/post", parameters: parameters)
        //发送body内容：foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3
    }
    
    func _UrlRequest() {
        let URL = NSURL(string: END_POINT)
        var request = NSURLRequest(URL: URL!)
        let parameters = ["foo": "bar"]
        let encoding = Alamofire.ParameterEncoding.URL
//        (request, _) = encoding.encode(request, parameters: parameters)
    }
    
    func _PostJson(){
        let parameters = [
            "foo": "bar",
            "baz": ["a", 1]
        ]
//        Alamofire.request(.POST, END_POINT,
//            parameters: parameters,
//            encoding:.JSON(options: nil))
//              .responseJSON {
//                (request, response, JSON, error) in
//                         println(JSON)
//        }
    }
    
    /** upload */
    func _Upload() {
        
        let fileURL = NSBundle.mainBundle()
            .URLForResource("Default",withExtension: "png")
        //upload a file
        Alamofire.upload(.POST,
                         END_POINT,
                         file: fileURL!)
        //upload w/Progress
        Alamofire.upload(.POST,
            END_POINT,
            file: fileURL!)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print(totalBytesWritten)
            }
            .responseJSON(completionHandler: { (response) in
                  print(response)
            })
//            .responseJSON { (request, response, JSON, error) in
        
        
        
    }
    /** download */
    func _Download() {
        Alamofire.download(.GET,
                           END_POINT,
                           destination: { (temporaryURL, response) in
                            
                                if let directoryURL = NSFileManager.defaultManager()
                                    .URLsForDirectory(.DocumentDirectory,
                                    inDomains: .UserDomainMask)[0]
                                    as? NSURL {
                                    let pathComponent = response.suggestedFilename
                                    return directoryURL.URLByAppendingPathComponent(pathComponent!)
                                }
                                return temporaryURL
                            }
        )
        // Using the Default Download Destination Closure Function
        let destination =
            Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory,
                                                           domain: .UserDomainMask)
        Alamofire.download(.GET,
                           END_POINT,
                           destination: destination)
        
        // #### Downloading a File w/Progress
        Alamofire
            .download(.GET, END_POINT,destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                print(totalBytesRead)
            }
            .response { (request, response, _, error) in
                print(response)
            }
        
    }
    
    /** Authentication **/
    func _Auth() {
        let user = "user"
        let password = "password"
        Alamofire.request(.GET, END_POINT+"\(user)/\(password)")
            .authenticate(user: user, password: password)
            .response {(request, response, _, error) in
                print(response)
            }
        
        //  Authenticating with NSURLCredential & NSURLProtectionSpace
        let credential = NSURLCredential(user: user,
                                         password: password,
                                         persistence: .ForSession)
        let protectionSpace = NSURLProtectionSpace(host: "httpbin.org",
                                                   port: 0,
                                                   protocol: "https",
                                                   realm: nil, authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
        
        Alamofire.request(.GET, END_POINT+"\(user)/\(password)")
            .authenticate(usingCredential: credential)
//            .authenticate(usingCredential: , forProtectionSpace: protectionSpace)
            .response {(request, response, _, error) in
                print(response)
        }
    }
    
}
