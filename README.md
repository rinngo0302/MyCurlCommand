# MyCurlCommand

## 課題

> Swift を利用して、次の機能を満たすアプリケーションを作る
> 1. curl https://example.com 相当のことができる機能
> 2. curl -o file https://example.com 相当のことができる機能
> 3. curl -v  https://example.com 相当のことができる機能
> 4. curl -X POST https://example.com 相当のことができる機能
> 5. curl -X POST -d "key=value" https://example.com 相当のことができる機能
> 
> コマンドオプションは (1) ~ (5) に記載された組み合わせだけではなく、
> 任意の組み合わせができるようにしてください。

## 機能
- GET送信で指定したURLからデータを取得する。
- 結果をファイルに出力する。(-o)
- Headerも出力する。(-v)
- POST送信をする。(-X POST)
- データを送信する。(-d)
- これらを任意の組み合わせでも実行できるようにする。

## TODO
- [x] GET送信で指定したURLからデータを取得する
    - [x] "https://www.google.com"のデータを取得する。
- [ ] オプションの実装
    - [x] オプションを認識できるようにする
        - [x] -oオプションをつけてそれを認識させる
        - [x] -oと-vオプションをつけてそれを認識させる
    - [x] 結果をファイルに出力する。(-o)
        - [x] result.txtファイルの生成
        - [x] "result.txt"のファイルに取得したデータを出力する。(-o)
    - [ ] Headerも出力する。(-v)
        - [ ] Googleに-vをつけてヘッダーも出力する。(-v)
    - [ ] HTTPメソッドを指定してリクエストを送信する。(-X)
        - [ ] HTTPメソッドを指定してGET送信をする。(-X Get)
        - [ ] HTTPメソッドを指定してPOST送信をする。(-X POST)
    - [ ] データを送信する。(-d)
        - [ ] "key=value"のデータをGET送信する(-d)
