//
//  Goods.swift
//  PerfectServer
//
//  Created by mac on 2021/8/16.
//

import StORM

class Goods: BaseMySQLStORM {
    
    var item_name: String = ""
    var item_price: String = ""
    var item_subs: String = ""
    var itemId: String = ""
    
    override func to(_ this: StORMRow) {
        item_name = this.data["item_name"] as? String ?? ""
        item_price = this.data["item_price"] as? String ?? ""
        item_subs = this.data["item_subs"] as? String ?? ""
        itemId = this.data["itemId"] as? String ?? ""
    }
    
    func rows() -> [Goods] {
        var rows = [Goods]()
        for i in 0..<self.results.rows.count {
            let row = Goods()
            
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
