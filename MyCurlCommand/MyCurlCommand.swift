import Foundation

class MyCurlCommand
{
    // option index
    private var _optionIndexs: [Int]
    
    // request data
    private var _result: String
    // 文字コード
    private var _encoding: String.Encoding
    
    // オプションのデータ
    private var _optionData: OptionData
    
    protocol OptionDataProtocol {
        var isActive: Bool { get set }
    }
    
    // Option Flag
    private struct OptionData
    {
        public var o: o_Data
        public var v: v_Data
        public var X: X_Data
        public var d: d_Data

        public struct o_Data : OptionDataProtocol
        {
            public var isActive: Bool
            public var filePath: String
            
            init()
            {
                isActive = false
                filePath = ""
            }
            init(filePath path: String)
            {
                isActive = false
                filePath = path
            }
        }
        
        public struct v_Data : OptionDataProtocol
        {
            public var isActive: Bool
            
            init()
            {
                isActive = false
            }
        }
        
        public struct X_Data : OptionDataProtocol
        {
            public var isActive: Bool
            public var method: String
            
            init()
            {
                isActive = false
                method = "GET"
            }
        }
        
        init()
        {
            o = o_Data()
            v = v_Data()
            X = X_Data()
            d = d_Data()
        }
        
        public struct d_Data : OptionDataProtocol
        {
            public var isActive: Bool
            public var contentType: String
            public var data: String
            
            init()
            {
                isActive = false
                contentType = ""
                data = ""
            }
        }
    }
    
    
    init()
    {
        _optionIndexs = []
        
        _optionData = OptionData()
        _optionData.o = OptionData.o_Data()
        
        _result = ""
        _encoding = .shiftJIS
    }
    
    public func execute(query query: [String]) async -> String?
    {
        
        let url = query.last
        guard let url = url else
        {
            print("Cannot get URL");
            return nil
        }
        
        // Option
        _optionIndexs = getOptionIndexs(query: query)
        executeOptions(query: query)
        
        // Request
        let result = await sendRequest(request: url)
        if let result = result
        {
            _result = result
        }
        
        if (_optionData.o.isActive)
        {
            // -oオプションがついているときはファイルに出力
            do
            {
                try _result.write(toFile: _optionData.o.filePath, atomically: true, encoding: _encoding)
            } catch {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        } else {
            // -oがないのでターミナル上に出力
            print(_result)
        }
        
        return _result
    }

    private func getOptionIndexs(query: [String]) -> [Int]
    {
        var optionsIndexs: [Int] = []
        
        for i in 0 ..< query.count
        {
            if (query[i].first == "-")
            {
                optionsIndexs.append(i)
            }
        }
        
        return optionsIndexs
    }
    
    private func executeOptions(query: [String])
    {
        for optionindex in _optionIndexs
        {
            switch (query[optionindex])
            {
            case "-o":
                let filePath = query[optionindex + 1]
                if (filePath.first == "-")
                {
                    print("Warning: The file name argument '\(filePath)' looks like a flag.")
                }
                
                try? executeOption_o(resultFilePath: filePath)
                
            case "-v":
                executeOption_v()
                
            case "-X":
                executeOption_X(method: query[optionindex + 1])
                
            case "-d":
                executeOption_d(arg: query[optionindex + 1])
                
            default:
                print("not exist this option (\(query[optionindex]))")
                return;
            }
        }
    }
    
    private func executeOption_o(resultFilePath filePath: String) throws
    {
        let fileMgr = FileManager.default

        // check is exist file
        if !(fileMgr.fileExists(atPath: filePath))
        {
            // create file
            let hasCreated = fileMgr.createFile(atPath: filePath, contents: nil, attributes: nil)
            if (!hasCreated)
            {
                throw NSError(domain: "FileCreationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot create file"])
            }
        }
        
        // activate -o
        _optionData.o.isActive = true
        _optionData.o.filePath = filePath
    }
    
    private func executeOption_v()
    {
        _optionData.v.isActive = true
    }
    
    private func executeOption_X(method method: String)
    {
        _optionData.X.isActive = true
        _optionData.X.method = method
    }
    
    private func executeOption_d(arg data: String)
    {
        if let data = data.data(using: .utf8)
        {
            let contentType = detectContentType(arg: data)
            
            _optionData.d.isActive = true
            _optionData.d.contentType = contentType
        }
        
        _optionData.d.data = data
    }
    
    private func detectContentType(arg data: Data) -> String
    {
        if let text = String(data: data, encoding: .utf8) {
            // JSON形式を検出
            if text.hasPrefix("{") && text.hasSuffix("}") {
                return "application/json"
            }
            
            // HTML形式を検出
            if text.contains("<html>") || text.contains("<body>") {
                return "text/html"
            }
            
            // XML形式を検出
            if text.contains("<?xml") || text.contains("<") && text.contains(">") {
                return "application/xml"
            }
            
            // URLエンコードされたデータを検出
            let urlEncodedRegex = try! NSRegularExpression(pattern: "([a-zA-Z0-9%]+=[a-zA-Z0-9%]+(&[a-zA-Z0-9%]+=[a-zA-Z0-9%]+)*)")
            let matches = urlEncodedRegex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
            if matches.count > 0 {
                return "application/x-www-form-urlencoded"
            }
        }
        
        return "text/plain"
    }
    
    private func sendRequest(request url: String) async -> String?
    {
        guard let url = URL(string: url) else { return nil }
        
        var request = URLRequest(url: url)
        
        // -Xが指定されているときmethodを指定する
        request.httpMethod = (_optionData.X.isActive) ? _optionData.X.method : "GET"
        
        // -dが指定されているとき、method=POST
        if (_optionData.d.isActive)
        {
            request.httpMethod = "POST"
            request.setValue(_optionData.d.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = _optionData.d.data.data(using: .utf8)
        }
        
        do
        {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else
            {
                return nil
            }
                        
            // すべての文字コード
            let encodings: [String.Encoding] = [
                .shiftJIS, .utf8, .utf16, .utf32, .ascii, .isoLatin1, .windowsCP1250, .windowsCP1251, .windowsCP1252, .macOSRoman, .nonLossyASCII
            ]
            
            // すべての文字コードで試す
            for encoding in encodings
            {
                if var result = String(data: data, encoding: encoding)
                {
                    _encoding = encoding
                    
                    // -vが指定されているとき
                    if (_optionData.v.isActive)
                    {
                        let headers = httpResponse.allHeaderFields
                        
                        var headerString: String = ""
                        for (key, value) in headers
                        {
                            headerString += "\(key): \(value)\n"
                        }
                        
                        result = headerString + "-------------------------\n" + result
                    }
                    
                    return result
                }
            }
            
            print("Cannot convert data to String");
            return nil
            
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
