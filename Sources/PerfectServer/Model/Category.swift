//
//  Category.swift
//  PerfectServer
//
//  Created by mac on 2021/8/18.
//

import StORM

class Category: BaseMySQLStORM {
    
    var categoryName: String = ""
    var categoryId: String = ""
    var iconUrl: String = ""
    
    override func to(_ this: StORMRow) {
        categoryName = this.data["categoryName"] as? String ?? ""
        categoryId = this.data["categoryId"] as? String ?? ""
        iconUrl = this.data["iconUrl"] as? String ?? ""
    }
    
    func rows() -> [Category] {
        var rows = [Category]()
        for i in 0..<self.results.rows.count {
            let row = Category()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
}
