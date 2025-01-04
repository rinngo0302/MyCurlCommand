//
//  OptionSystem.swift
//  OptionSystem
//
//  Created by 齋藤祐希 on 2025/01/04.
//

import XCTest
@testable import MyCurlCommand

final class オプションを認識できるようにする : XCTestCase
{
    func test_oオプションをつけてそれを認識させる() async
    {
        // 準備
        let curl: MyCurlCommand = MyCurlCommand()
        // 実装 & 検証
        let result = await curl.execute(query: ["-o", "https://www.google.com/"])
        if let result = result
        {
            print("result: \(result)")
        }
        XCTAssertNotNil(result, "オプションを認識できていません。")
    }
    
    func test_v_oオプションをつけてそれを認識させる() async
    {
        // 準備
        let curl: MyCurlCommand = MyCurlCommand()
        // 実装 & 検証
        let result = await curl.execute(query: ["-o", "-v", "https://www.google.com/"])
        if let result = result
        {
            print("result: \(result)")
        }
        XCTAssertNotNil(result, "オプションを認識できていません。")
    }
}

final class o_結果をファイルに出力する : XCTestCase
{
    var curl: MyCurlCommand!
    
    override func setUp()
    {
        super.setUp()
        
        curl = MyCurlCommand()
    }
    
    func test_result_txt_の生成() async
    {
        // 準備
        let fileMgr = FileManager.default
        let filePath = "result.txt"
        
        // 実行
        await curl.execute(query: ["-o", "result.txt", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        XCTAssertTrue(fileMgr.fileExists(atPath: filePath), "ファイルの生成がうまくできていません。")
    }
    
    func test_result_txt_に書き込み() async
    {
        // 準備
        let filePath = "result.txt"
        
        // 実行
        await curl.execute(query: ["-o", filePath, "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        do
        {
            let result = try String(contentsOfFile: filePath, encoding: .shiftJIS)
            XCTAssertNotNil(result, "ファイルの書き込みができていません。")
        } catch {
            print("Error: \(error)")
        }
    }
}

final class v_Headerも出力する : XCTestCase
{
    var curl: MyCurlCommand!
    
    override func setUp()
    {
        super.setUp()
        
        curl = MyCurlCommand()
    }
    
    func test_阿部寛にvをつけてヘッダーも出力する() async
    {
        // 準備
        var normalResult: String
        var headerResult: String?
        
        // 実行
        normalResult = await curl.execute(query: ["http://abehiroshi.la.coocan.jp/"])!
        headerResult = await curl.execute(query: ["-v", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        if let headerResult = headerResult
        {
            XCTAssertNotEqual(normalResult, headerResult, "Headerの出力がうまくできていません。")
        } else {
            XCTAssertTrue(true, "nilが出力されました。")
        }
    }
    
    func test_vと_oをつける() async
    {
        // 準備
        var normalResult: String
        var headerResult: String?
        
        // 実行
        normalResult = await curl.execute(query: ["http://abehiroshi.la.coocan.jp/"])!
        headerResult = await curl.execute(query: ["-v", "-o", "result.txt", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        if let headerResult = headerResult
        {
            XCTAssertNotEqual(normalResult, headerResult, "Headerの出力がうまくできていません。")
        } else {
            XCTAssertTrue(true, "nilが出力されました。")
        }
        
        do
        {
            let result = try String(contentsOfFile: "result.txt", encoding: .shiftJIS)
            XCTAssertNotNil(result, "ファイルの書き込みができていません。")
        } catch {
            print("Error: \(error)")
        }
    }
}

final class X_HTTPメソッドを指定してリクエストを送信する : XCTestCase
{
    var curl: MyCurlCommand!
    
    override func setUp()
    {
        super.setUp()
        
        curl = MyCurlCommand()
    }
    
    func test_HTTPメソッドを指定してGET送信をする() async
    {
        // 準備

        // 実装
        let result = await curl.execute(query: ["-X", "GET", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        if let result = result
        {
            print("result: \(result)")
        }
        XCTAssertNotNil(result, "メソッドの指定ができていません。")
    }
    
    func test_HTTPメソッドを指定してPOST送信をする() async
    {
        // 準備

        // 実装
        let result = await curl.execute(query: ["-X", "POST", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        if let result = result
        {
            print("result: \(result)")
        }
        XCTAssertNotNil(result, "メソッドの指定ができていません。")
    }
    
    func test_v_o_Xをつける() async
    {
        // 準備
        let filePath = "test.txt"

        // 実装
        let result = await curl.execute(query: ["-v", "-o", filePath, "-X", "POST", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        do
        {
            let result = try String(contentsOfFile: filePath, encoding: .shiftJIS)
            XCTAssertNotNil(result, "ファイルの書き込みができていません。")
        } catch {
            print("Error: \(error)")
        }
    }
}

final class d_データを送信する : XCTestCase
{
    var curl: MyCurlCommand!
    
    override func setUp()
    {
        super.setUp()
        
        curl = MyCurlCommand()
    }
    
    
    struct ResponseData: Codable {
        let args: [String: String]
        let data: String
        let files: [String: String]
        let form: [String: String]
        let headers: Headers
        let json: String?
        let origin: String
        let url: String
        
        struct Headers: Codable {
            let accept: String
            let contentLength: String
            let contentType: String
            let host: String
            let userAgent: String
            let xAmznTraceId: String
            
            enum CodingKeys: String, CodingKey {
                case accept = "Accept"
                case contentLength = "Content-Length"
                case contentType = "Content-Type"
                case host = "Host"
                case userAgent = "User-Agent"
                case xAmznTraceId = "X-Amzn-Trace-Id"
            }
        }
    }
    
    func test_key_valueのデータをPOST送信する() async
    {
        // 準備
        
        // 実行
        var result = await curl.execute(query: ["-d", "key1=value1", "-X", "POST", "https://httpbin.org/post"])
        
        // 検証
        if let result = result, let jsonData = result.data(using: .utf8)
        {
            do
            {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                
                XCTAssertEqual(responseData.headers.contentType, "application/x-www-form-urlencoded", "application/x-www-form-urlencodedの検出ができていません。")
            } catch {
                XCTAssertTrue(true, "Error decoding JSON: \(error)")
            }
        } else {
            XCTAssertTrue(true, "cannot to convert")
        }
    }
    
    func test_key_valueのJSONデータをPOST送信する() async
    {
        // 準備
        
        // 実行
        var result = await curl.execute(query: ["-d", "{key: value}", "-X", "POST", "https://httpbin.org/post"])
        
        // 検証
        if let result = result, let jsonData = result.data(using: .utf8)
        {
            do
            {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                
                XCTAssertEqual(responseData.headers.contentType, "application/json", "application/jsonの検出ができていません。")
            } catch {
                XCTAssertTrue(true, "Error decoding JSON: \(error)")
            }
        } else {
            XCTAssertTrue(true, "cannot to convert")
        }
    }
    
    func test_HTMLデータをPOST送信する() async
    {
        // 準備
        
        // 実行
        var result = await curl.execute(query: ["-d", "<html><body><h1>Hello, world!!</h1></body></html>", "-X", "POST", "https://httpbin.org/post"])
        
        // 検証
        if let result = result, let jsonData = result.data(using: .utf8)
        {
            do
            {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                
                XCTAssertEqual(responseData.headers.contentType, "text/html", "text/htmlの検出ができていません。")
            } catch {
                XCTAssertTrue(true, "Error decoding JSON: \(error)")
            }
        } else {
            XCTAssertTrue(true, "cannot to convert")
        }
    }
    
    func test_XMLデータをPOST送信する() async
    {
        // 準備
        
        // 実行
        var result = await curl.execute(query: ["-d", "<root><item>Hello,world!!</item></root>", "-X", "POST", "https://httpbin.org/post"])
        
        // 検証
        if let result = result, let jsonData = result.data(using: .utf8)
        {
            do
            {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                
                XCTAssertEqual(responseData.headers.contentType, "application/xml", "application/xmlの検出ができていません。")
            } catch {
                XCTAssertTrue(true, "Error decoding JSON: \(error)")
            }
        } else {
            XCTAssertTrue(true, "cannot to convert")
        }
    }
}
