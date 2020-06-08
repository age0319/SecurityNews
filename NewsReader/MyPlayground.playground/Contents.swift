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
