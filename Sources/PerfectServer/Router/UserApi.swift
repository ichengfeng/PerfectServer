//
//  UserApi.swift
//  PerfectTemplate
//
//  Created by mac on 2021/8/10.
//

import PerfectHTTP

class UserApi: BaseApi {

    static func register() -> RequestHandler {
        return {
            request, response in
            
            printLog(request.params())
            
            let res = Result(data: [String: Any]())
            
            if !paramsCheckUp(request: request, response: response, result: res, allParams: ["phone", "password", "nickname","name","user_icon"]) {
                return
            }
            
            ///校验手机号
            guard let phoneStr = request.param(name: "phone"), phoneStr.count == 11 else {
                res.failure(code: .parameterError, reasonStr: "手机号必须是11位")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            let checkPhone = User()
            do {
                try checkPhone.find(["phone": phoneStr])
                printLog(checkPhone.rows().count)

                if checkPhone.rows().count > 0 {
                    res.failure(code: .parameterError, reasonStr: "该手机号已被注册")
                    try! response.setBody(json: res.toDict())
                    response.completed()
                    return
                }
            } catch {
                printLog(error)
            }
            
            ///校验密码
            guard let passwordBase64 = request.param(name: "password") else {
                res.failure(code: .parameterError, reasonStr: "密码不能为空")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            var password = String()
            password = "\(passwordBase64)"
//            if let base64Res = passwordBase64.decode(.base64),
//               let base64UTF8 = String(validatingUTF8: base64Res) {
//                password = base64UTF8
//            }
            printLog(password.count)
            if password.count < 6 || password.count > 10 {
                res.failure(code: .parameterError, reasonStr: "密码必须是6~10位")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            ///校验名字
            guard let name = request.param(name: "name"), name.count > 0 && name.count <= 10 else {
                res.failure(code: .parameterError, reasonStr: "名字长度必须大于1")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            let checkName = User()
            do {
                try checkName.find(["name": name])
                if checkName.rows().count > 0 {
                    res.failure(code: .parameterError, reasonStr: "该名称已被使用")
                    try! response.setBody(json: res.toDict())
                    response.completed()
                    return
                }
            } catch {
                print(error)
            }
            
            ///校验昵称
            guard let nickname = request.param(name: "nickname"), nickname.count > 0 && nickname.count <= 10 else {
                res.failure(code: .parameterError, reasonStr: "昵称必须是1~10位")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            let checkNickname = User()
            do {
                try checkNickname.find(["nickname": nickname])
                if checkNickname.rows().count > 0 {
                    res.failure(code: .parameterError, reasonStr: "该昵称已被使用")
                    try! response.setBody(json: res.toDict())
                    response.completed()
                    return
                }
            } catch {
                print(error)
            }
            
            ///校验图片链接
            guard let user_icon = request.param(name: "user_icon"), user_icon.count > 0 else {
                res.failure(code: .parameterError, reasonStr: "图片链接长度需大于0")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            ///创建模型，写入MySQL
            let user = User()
            user.phone = phoneStr
            user.password = passwordBase64
            user.nickname = nickname
            user.name = name
            user.user_create_time = Int64(Tool.timeStamp) ?? 0
            user.user_icon = user_icon
            res.dataDict!["entry"] = user.objToDict()
            printLog(user)
            
            do {
                try user.save()
                try response.setBody(json: res.toDict())
            } catch {
                serverErrorHandle(result: res, response: response)
                printLog(error)
            }
            
            response.completed()
        }
    }
    
    ///登录
    static func login() -> RequestHandler {
        return {
            request, response in
            
            let res = Result(data: [String: Any]())
            
            if !paramsCheckUp(request: request, response: response, result: res, allParams: ["phone", "password"]) {
                return
            }
            
            guard let phoneStr = request.param(name: "phone"), phoneStr.count == 11 else {
                res.failure(code: .parameterError, reasonStr: "手机号必须是11位")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            guard let password = request.param(name: "password") else {
                res.failure(code: .parameterError, reasonStr: "密码不能为空")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
        
            let user = User()
            do {
                
                try user.find(["phone": phoneStr, "password": password])
                                
                if user.password.count < 1 {
                    res.failure(code: .parameterError, reasonStr: "用户名或密码错误")
                } else {
                    res.codeMsg = "登录成功"
                    res.dataDict = user.objToDict()
                }

                try response.setBody(json: res.toDict())
            } catch {
                serverErrorHandle(result: res, response: response)
                printLog(error)
            }
            
            response.completed()
        }
    }
    
    /// 检查手机号码是否有效（已注册的不能再注册，算无效号码）
    static func checkPhoneIsValid() -> RequestHandler {
        
        return {
            request, response in
            
            printLog(request.params())
            
            let res = Result(data: [String: Any]())
            
            if !paramsCheckUp(request: request, response: response, result: res, allParams:["phone"]) {
                return
            }
            
            ///先判断是否是正常的号码
            guard let phoneStr = request.param(name: "phone"), phoneStr.count == 11 else {
                res.failure(code: .parameterError, reasonStr: "非法号码，手机号必须是11位")
                try! response.setBody(json: res.toDict())
                response.completed()
                return
            }
            
            ///然后判断数据库是否已经存在该号码
            let checkPhone = User()
            do {
                try checkPhone.find(["phone": phoneStr])
                printLog(checkPhone.rows().count)

                if checkPhone.rows().count > 0 {
                    res.failure(code: .parameterError, reasonStr: "该手机号已被注册")
                    res.dataArr?.append(checkPhone.objToDict())
                    try! response.setBody(json: res.toDict())
                    response.completed()
                    return
                }else {
                    res.codeMsg = "此号码可以注册"
                    try response.setBody(json: res.toDict())
                    response.completed()
                }
            } catch {
                printLog(error)
            }
            
        }
        
    }
    
    /// 获取已注册用户列表
    static func getUserList() -> RequestHandler {
        
        return {
            request, response in
            
            var res = Result(data: [String: Any]())
            let user = User()
            do {
                try user.findAll()
                if user.rows().count > 0 {
                    res = Result(data: user.objToArrayDict(objArr:user.rows()))
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
