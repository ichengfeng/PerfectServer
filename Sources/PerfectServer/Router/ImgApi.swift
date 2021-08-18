//
//  TestApi.swift
//  PerfectTemplate
//
//  Created by mac on 2021/8/10.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib

let imageFilePath = "//Users/mac/Documents/resource"

class ImgApi: BaseApi {
    
    static func helloWorld() -> RequestHandler {
        return { requst,response in
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
            response.completed()
        }
    }
    
    static func getImg() -> RequestHandler {
        return {
            request, response in
            ///let docRoot = request.documentRoot
            ///获取用户上传的get参数
            let name = request.param(name: "name");
            
            do {
                let cat = File(String.init(format: "%@/%@" ,imageFilePath,name!));
                let imageSize = cat.size
                let imageBytes = try cat.readSomeBytes(count: imageSize)
                response.setHeader(.contentType, value: MimeType.forExtension("jpg"))
                response.setHeader(.contentLength, value: "\(imageBytes.count)")
                response.setBody(bytes: imageBytes)
            } catch {
                response.status = .internalServerError
                response.setBody(string: "请求处理出现错误： \(error)")
            }
            response.completed()
        }
    }
    
}


