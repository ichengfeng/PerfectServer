//
//  GoodsPicture.swift
//  PerfectServer
//
//  Created by mac on 2021/8/16.
//

import StORM

class Goods_Picture: BaseMySQLStORM {
    
    var imgUrl: String = ""
    var itemId: String = ""
    
    override func to(_ this: StORMRow) {
        imgUrl = this.data["imgUrl"] as? String ?? ""
        itemId = this.data["itemId"] as? String ?? ""
    }
    
    func rows() -> [Goods_Picture] {
        var rows = [Goods_Picture]()
        for i in 0..<self.results.rows.count {
            let row = Goods_Picture()
            
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
