//
//  NetworkTools.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/29.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import AFNetworking

enum Method:String {
    
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    
    private let clientID      = "2358840009"
    private let  clientSecret = "68073b7f2a27ac60972d13dc52695d86"
    let redirectUri           = "http://www.baidu.com"
    
    /// 单例的下载工具
    static let sharedNetworkToos:NetworkTools = {
        
        let baseURL = "https://api.weibo.com/"
        
        let tools = NetworkTools(baseURL: NSURL(string: baseURL))
        
        let type = NSMutableSet(set: tools.responseSerializer.acceptableContentTypes)
        type.addObject("text/plain")
        type.addObject("text/html")
        
        tools.responseSerializer.acceptableContentTypes = NSSet(set: type) as Set<NSObject>
        
        return tools
    }()
    
/*
    App Key：2358840009
    App Secret：68073b7f2a27ac60972d13dc52695d86

    https://api.weibo.com/oauth2/authorize
    
    https://api.weibo.com/oauth2/access_token
    
    client_id	true	string	申请应用时分配的AppKey。
    client_secret	true	string	申请应用时分配的AppSecret。
    grant_type	true	string	请求的类型，填写authorization_code

*/
    /// 拼接OAuth的token请求地址
    func getAuthorizeURL() -> NSURL {
        
        let authorizeURL = "https://api.weibo.com/oauth2/authorize?client_id=\(clientID)&redirect_uri=\(redirectUri)"
        
        return NSURL(string: authorizeURL)!
    }
    
    /// 请求安全令牌
    func getAccessToken(code:String,completion:(json:[String:AnyObject]?,error:NSError?) -> ()) {
        
        let parameters = ["client_id":clientID,
                          "client_secret":clientSecret,
                          "grant_type":"authorization_code",
                          "code":code,
                        "redirect_uri":redirectUri]
        
        let accessTokenURL = "https://api.weibo.com/oauth2/access_token"
        
        NetworkTools.requesetJSON(.POST, URLString: accessTokenURL, parameters: parameters) { (json, error) -> () in
            
            completion(json: json, error: error)
        } 
    }
    
    /// 获取用户信息
    func getUserInfo(completion:(json:[String:AnyObject]?,error:NSError?) -> ()) {
        
        let userInfoURL = "https://api.weibo.com/2/users/show.json"
        
        let parameters:[String:AnyObject] = ["access_token":userAccount.loadAccount()!.access_token! , "uid":userAccount.loadAccount()!.uid!]
        
        NetworkTools.requesetJSON(.GET, URLString: userInfoURL, parameters:(parameters ) ) { (json, error) -> () in
            
            completion(json: json, error: error)
        }
        
        
    }
    
    /// 封装AFN框架,降低AFN框架和项目的耦合性
    class func requesetJSON(method:Method, URLString:String!, parameters:[String:AnyObject]?, completion:(json:[String:AnyObject]?,error:NSError?) -> () ) {
        
        if method == Method.GET {
            
            sharedNetworkToos.GET(URLString, parameters: parameters, success: { (_, JSON) -> Void in

                completion(json: JSON as? [String:AnyObject], error: nil)
                
            }, failure: { (_, error) -> Void in
                print(error)
                completion(json: nil, error: error)
       
            })
        } else if method == Method.POST {
            
            sharedNetworkToos.POST(URLString, parameters: parameters, success: { (_, JSON) -> Void in

                completion(json: JSON as? [String:AnyObject], error: nil)
                
            }, failure: { (_, error) -> Void in
                print(error)
                completion(json: nil, error: error)
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
