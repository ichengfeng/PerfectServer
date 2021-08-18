//
//  CategoryApi.swift
//  PerfectServer
//
//  Created by mac on 2021/8/18.
//

import PerfectHTTP

class CategoryApi: BaseApi {
    
    static func getCategoryList() -> RequestHandler {
        
        return {
            request, response in
            
            var res = Result(data: [String: Any]())
            let category = Category()
            do {
                
                try category.findAll()
                if category.rows().count > 0 {
                    res = Result(data: category.objToArrayDict(objArr:category.rows()))
                    try response.setBody(json: res.toDict())
                }else {
                    res.codeMsg = "暂无数据"
                    res.dataArr = Array()
                    try response.setBody(json: res.toDict())
                }
                    
            } catch {
                serverErrorHandle(result: res, response: response)
                printLog(error)
            }
            response.completed()
        }
        
    }
    
}
