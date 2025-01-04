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
