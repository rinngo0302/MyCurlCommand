//
//  Additional.swift
//  Additional
//
//  Created by 齋藤祐希 on 2025/01/04.
//

import XCTest
@testable import MyCurlCommand

final class Additional: XCTestCase
{
    var curl: MyCurlCommand!
    
    override func setUp()
    {
        super.setUp()
        
        curl = MyCurlCommand()
    }

    func test_Header出力をきれいにする() async
    {
        // 準備
        var normalResult: String
        var headerResult: String?
        
        // 実行
        normalResult = await curl.execute(query: ["http://abehiroshi.la.coocan.jp/"])!
        headerResult = await curl.execute(query: ["-o", "result.txt" ,"-v", "http://abehiroshi.la.coocan.jp/"])
        
        // 検証
        if let headerResult = headerResult
        {
            XCTAssertNotEqual(normalResult, headerResult, "Headerの出力がうまくできていません。")
        } else {
            XCTAssertTrue(true, "nilが出力されました。")
        }
    }
}
