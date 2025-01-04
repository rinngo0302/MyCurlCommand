import Foundation

class MyCurlCommand
{
    // option index
    private var _optionIndexs: [Int]
    
    // request data
    private var _result: String
    // 文字コード
    private var _encoding: String.Encoding
    
    // Option Flag
    private struct OptionData
    {
        public var o: o_Data

        public struct o_Data
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
        
        init()
        {
            // -o
            o = o_Data()
        }
    }
    private var _optionData: OptionData
    
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
            print(result)
        }
        
        return result
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
                try? executeOption_o(resultFilePath: query[optionindex + 1])
                
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
    
    private func sendRequest(request url: String) async -> String?
    {
        guard let url = URL(string: url) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type")

        do
        {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse
            {
                print("Status Code: \(httpResponse)")
            }
            
            if let result = String(data: data, encoding: .shiftJIS)
            {
                // 文字コードの設定
                _encoding = .shiftJIS
                
                return result
            } else {
                if let result = String(data: data, encoding: .utf8)
                {
                    // 文字コードの設定
                    _encoding = .utf8
                    
                    return result
                }
                
                print("Cannot convert data to String")
                return nil
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
