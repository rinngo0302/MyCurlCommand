//
//  main.swift
//  MyCurlCommand
//
//  Created by 齋藤祐希 on 2025/01/05.
//


@main
class Main
{
    static func main() async
    {
        let args = CommandLine.arguments.dropFirst()

        var curl = MyCurlCommand()
        await curl.execute(query: Array(args))
    }
}
