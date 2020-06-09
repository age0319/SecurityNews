import UIKit

var str = "Hello, playground"

//func deleteAction(at indexPath:IndexPath) -> UIContextualAction{
//       let action = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view,completion) in
//        //選択された行のデータを消す
//        self.dataSource.remove(at: indexPath.row)
//        //選択された行を消す
//        self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        // 処理が完了したことを返す
//        completion(true)
//       })
//        // スワイプ時の背景色を赤色に
//        action.backgroundColor = .red
//        // スワイプ時の画像をゴミ箱に
//        action.image = UIImage(systemName: "trash")
//
//       return action
//   }
//
//override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//     let delete = deleteAction(at: indexPath)
//     return UISwipeActionsConfiguration(actions: [delete])
// }

let arr = ["FOO", "FOO", "BAR", "FOOBAR"]
var counts: [String: Int] = [:]

arr.forEach { counts[$0, default: 0] += 1 }

print(counts)  // "["FOOBAR": 1, "FOO": 2, "BAR": 1]"

class Foo{
    var name = ""
    init(name:String) {
        self.name = name
    }
}

let foo1 = Foo(name: "ue")
let foo2 = Foo(name: "nobu")
let foo3 = Foo(name: "hoge")

let FooArray = [foo1, foo2, foo3]
let count = FooArray.reduce(0) { $0 + ($1.name.count ) }
print(count)

var xmlSource = [
    ("SecurityNext","http://www.security-next.com/feed","security-next.com"),
    ("TrendMicro","http://feeds.trendmicro.com/TM-Securityblog/","trendmicro"),
    ("CCSI","https://ccsi.jp/category/%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3%E3%83%8B%E3%83%A5%E3%83%BC%E3%82%B9/feed/","ccsi.jp"),
    ("IPA","https://www.ipa.go.jp/security/rss/info.rdf","ipa.go.jp"),
    ("ScanNetSecurity","https://scan.netsecurity.ne.jp/rss/index.rdf","scan.netsecurity"),
    ("LAC","https://www.lac.co.jp/lacwatch/feed.xml","lac.co.jp"),
    ("TechCrunch","https://jp.techcrunch.com/news/security/feed/","techcrunch.com"),
    ("Gigazine","https://gigazine.net/news/rss_2.0/","gigazine.net"),
    ("ITMedia","https://rss.itmedia.co.jp/rss/2.0/news_security.xml","itmedia.co.jp")
]

var siteList = [String]()
for i in xmlSource{
    print(i.0)
    siteList.append(i.0)
}

