@main
struct Main
{
    static func main() async
    {
        let args = CommandLine.arguments.dropFirst()

        var curl = MyCurlCommand()
        await curl.execute(query: Array(args))
    }
}
