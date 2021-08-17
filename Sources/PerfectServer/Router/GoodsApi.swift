//
//  GoodsApi.swift
//  PerfectServer
//
//  Created by mac on 2021/8/16.
//

import PerfectHTTP

class GoodsApi: BaseApi {

    /// 获取已注册用户列表
    static func getGoodsList() -> RequestHandler {
        
        return {
            request, response in
            
            var res = Result(data: [String: Any]())
            let goods = Goods()
            do {
                try goods.findAll()
                if goods.rows().count > 0 {
                    
                    let goodsPic = Goods_Picture()
                    try goodsPic.findAll()
                    let goodsPicList = goodsPic.rows()
                    
                    var itemArr = goods.objToArrayDict(objArr:goods.rows())
                    
                    for (index,item) in itemArr.enumerated() {
                        var temPic = Array<Goods_Picture>()
                        for pic in goodsPicList {
                            if pic.itemId == item["itemId"] as! String {
                                temPic.append(pic)
                            }
                        }
                        itemArr[index]["pictures"] = goodsPic.objToArrayDict(objArr:temPic)
                    }
                    
                    res = Result(data: itemArr)
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
