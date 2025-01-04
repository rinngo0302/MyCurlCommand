//
//  BaseCurlTest.swift
//  BaseCurlTest
//
//  Created by 齋藤祐希 on 2024/12/29.
//

import XCTest
@testable import MyCurlCommand

final class BaseCurlTest: XCTestCase
{
    func test_https_www_google_com_のデータを取得する() async
    {
        // 準備
        let curl: MyCurlCommand = MyCurlCommand()
        
        // 実行 & 検証
        let result = await curl.execute(query: "https://www.google.com/")
        if let result = result
        {
            print("result: \(result)")
        }
        XCTAssertNotNil(result, "HTTP送信ができていません。")
    }
}
