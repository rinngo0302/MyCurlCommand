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
    func test_result_txt_に結果を出力する() async
    {
        
    }
}
