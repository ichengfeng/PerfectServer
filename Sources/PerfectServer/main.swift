//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import PerfectMySQL
import MySQLStORM
import StORM

func setUpRoutes() -> [Route] {
    
    var routeArray = [Route]()
    ///routeArray.append(Route(methods: [.get, .post], uri: "/helloWorld", handler: TestApi.helloWorld()))
    routeArray.append(Route(methods: [.get], uri: "/img", handler: TestApi.getImg()))
    routeArray.append(Route(method: .post, uri: "/register", handler: UserApi.register()))
    routeArray.append(Route(method: .post, uri: "/login", handler: UserApi.login()))
    routeArray.append(Route(method: .get, uri: "/checkPhoneIsValid", handler: UserApi.checkPhoneIsValid()))
    routeArray.append(Route(method: .get, uri: "/getUserList", handler: UserApi.getUserList()))
    routeArray.append(Route(method: .get, uri: "/getGoodsList", handler: GoodsApi.getGoodsList()))
    
    return routeArray
}

func setupMySQL() {
    
    let serverConfig = ServerConfiguration()

    MySQLConnector.host        = serverConfig.mysqlHost
    MySQLConnector.username    = serverConfig.mysqlUser
    MySQLConnector.password    = serverConfig.mysqlPwd
    MySQLConnector.database    = serverConfig.mysqlDBName

    print("MySql初始化完成")
}

do {
    
    setupMySQL()
    
    let routeArray = setUpRoutes()
    
    let serverConfig = ServerConfiguration()
    
    print("文件存储路径: \(Dir.workingDir.path)")
 
    let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
        (Filter(), HTTPFilterPriority.high)
    ]
    
    let responseFilters: [(HTTPResponseFilter, HTTPFilterPriority)] = [
        (Filter404(), HTTPFilterPriority.high),
        (FilterResult(), HTTPFilterPriority.high)
    ]
    
    let h = HTTPServer.Server(name: serverConfig.name, port: serverConfig.httpPort, routes: Routes(routeArray), requestFilters: requestFilters, responseFilters: responseFilters)
    
    print("===========================================")
    
    try HTTPServer.launch([h])
    
} catch {
    fatalError("\(error)")
}












//let testHost = "127.0.0.1"
//let testUser = "root"
//let testPassword = "feng"
//let testDB = "test_sql"

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
//func handler(request: HTTPRequest, response: HTTPResponse) {
//    // Respond with a simple message.
//    response.setHeader(.contentType, value: "text/html")
//    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
//    // Ensure that response.completed() is called when your processing is done.
//    response.completed()
//}

// Configure one server which:
//    * Serves the hello world message at <host>:<port>/
//    * Serves static files out of the "./webroot"
//        directory (which must be located in the current working directory).
//    * Performs content compression on outgoing data when appropriate.
//var routes = Routes()
//routes.add(method: .get, uri: "/", handler: handler)
//routes.add(method: .get, uri: "/**",
//           handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
//try HTTPServer.launch(name: "localhost",
//                      port: 8181,
//                      routes: routes,
//                      responseFilters: [
//                        (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])

//func setupMySQL() {
//
//    let serverConfig = ServerConfiguration()
//
//    MySQLConnector.host        = serverConfig.mysqlHost
//    MySQLConnector.username    = serverConfig.mysqlUser
//    MySQLConnector.password    = serverConfig.mysqlPwd
//    MySQLConnector.database    = serverConfig.mysqlDBName
//
//    print("MySql初始化完成")
    
//    let serverConfig = ServerConfiguration()
//
//    let mysql = MySQL() // 创建一个MySQL连接实例
//    let connected = mysql.connect(host: serverConfig.mysqlHost, user: serverConfig.mysqlUser, password: serverConfig.mysqlPwd,db: serverConfig.mysqlDBName)
//    guard connected else {
//        // 验证一下连接是否成功
//        print(mysql.errorMessage())
//        return
//    }
//
//    defer {
//        mysql.close() //这个延后操作能够保证在程序结束时无论什么结果都会自动关闭数据库连接
//    }
//    ///选择具体的数据Schema
//    guard mysql.selectDatabase(named: serverConfig.mysqlDBName) else {
//        Log.info(message: "数据库选择失败。错误代码：\(mysql.errorCode()) 错误解释：\(mysql.errorMessage())")
//        return
//    }

//}
