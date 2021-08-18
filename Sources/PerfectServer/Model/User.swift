//
//  User.swift
//  BBS-ServerPackageDescription
//
//  Created by pengpeng on 2017/12/9.
//

import StORM

class User: BaseMySQLStORM {
    var id : Int = 0
    var phone: String = ""
    var password: String = ""
    var name: String = ""
    var nickname: String = ""
    var user_create_time: Int64 = 0
    var user_icon: String = ""
    
    override func to(_ this: StORMRow) {
        phone = this.data["phone"] as? String ?? ""
        password = this.data["password"] as? String ?? ""
        name = this.data["name"] as? String ?? ""
        nickname = this.data["nickname"] as? String ?? ""
        user_create_time = this.data["user_create_time"] as? Int64 ?? 0
        user_icon = this.data["user_icon"] as? String ?? ""
    }
    
    func rows() -> [User] {
        var rows = [User]()
        for i in 0..<self.results.rows.count {
            let row = User()
            
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
    
    override func objToDictIgnoreVarArray() -> [String]? {
        return ["password"]
    }
}
