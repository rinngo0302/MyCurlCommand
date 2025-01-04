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

final class 結果をファイルに出力する_o : XCTestCase
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
