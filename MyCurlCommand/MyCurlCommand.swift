import Foundation

class MyCurlCommand
{
    init()
    {
    }
    
    public func execute(query query: [String]) async -> String?
    {
        let options = getOption(query: query)
        print("options: \(options)")

        let url = query.last
        guard let url = url else
        {
            print("Cannot get URL");
            return nil
        }
        
        let result = await sendRequest(request: url)
        
        return result
    }

    private func getOption(query: [String]) -> [String]
    {
        var options: [String] = []
        
        for arg in query
        {
            if (arg.first == "-")
            {
                let option = String(arg.dropFirst())
                options.append(option)
            }
        }
        
        return options
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
                return result
            } else {
                if let result = String(data: data, encoding: .utf8)
                {
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
