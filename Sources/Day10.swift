import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0) }
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    guard let inputs = entities.first else { return 0 }
    var answer = 0
    for line in inputs {
      let info = line.split(separator: " ").compactMap { String($0) }
      guard let target = info.first,
            let _ = info.last else { continue }
      let buttons = info.dropFirst().dropLast().map {
        let toggles = $0.dropFirst().dropLast().split(separator: "," ).compactMap { Int($0) }
        return toggles.reduce(0) {
          $0 | 1 << (target.count - 2 - $1 - 1)
        }
      }
      let targetValue = target.dropFirst().dropLast().enumerated().reduce(0) {
        $0 | ($1.element == "#" ? 1 : 0) << (target.count - 2 - $1.offset - 1)
      }
      var tempAnswer = Int.max
      for pattern in 0..<(1 << buttons.count) {
        var value = 0
        var cnt = 0
        for (i, button) in buttons.enumerated() {
          if (pattern & (1 << i)) != 0 {
            value ^= button
            cnt += 1
          }
        }
        if value == targetValue {
          tempAnswer = min(tempAnswer, cnt)
        }
      }
      answer += tempAnswer
    }
    return answer
  }
  
  struct Button {
      let idxs: [Int]        // 増やすカウンタ
      let degree: Int
  }

  func solveMachine(target: [Int], rawButtons: [[Int]]) -> Int? {
      let m = target.count
      var buttons = rawButtons.map { Button(idxs: $0.sorted(), degree: $0.count) }

      // --- ボタン順序：まず degree 降順（必要なら希少カウンタ優先も追加）
      buttons.sort { $0.degree > $1.degree }

      // 残りボタンで各カウンタが増やせるかの事前表（suffix cover）
      var suffixCover = Array(repeating: Array(repeating: false, count: m), count: buttons.count + 1)
      for k in stride(from: buttons.count - 1, through: 0, by: -1) {
          suffixCover[k] = suffixCover[k + 1]
          for i in buttons[k].idxs { suffixCover[k][i] = true }
      }

      // 下界計算に使う：suffixでの max degree
      var suffixMaxDeg = Array(repeating: 0, count: buttons.count + 1)
      for k in stride(from: buttons.count - 1, through: 0, by: -1) {
          suffixMaxDeg[k] = max(suffixMaxDeg[k + 1], buttons[k].degree)
      }

      // メモ化キー：k と d を文字列化（高速化するならパック推奨）
      func key(_ k: Int, _ d: [Int]) -> String {
          var s = "\(k)|"
          for v in d { s.append("\(v),") }
          return s
      }

      var memo: [String: Int] = [:]
      var best = Int.max

      func lowerBound(_ k: Int, _ d: [Int]) -> Int {
          let mx = d.max() ?? 0
          let sum = d.reduce(0, +)
          let maxDeg = max(1, suffixMaxDeg[k])
          let lb2 = (sum + maxDeg - 1) / maxDeg
          return max(mx, lb2)
      }

      func dfs(_ k: Int, _ d: [Int], _ used: Int) {
          // 既にベスト超え
          if used >= best { return }

          // 需要ゼロなら更新
          if d.allSatisfy({ $0 == 0 }) {
              best = min(best, used)
              return
          }

          // これ以上増やせないカウンタが残ってたら不可能
          for i in 0..<m {
              if d[i] > 0 && !suffixCover[k][i] { return }
          }

          // 下界で枝刈り
          let lb = lowerBound(k, d)
          if used + lb >= best { return }

          // メモ（ここからの最小追加が既知なら）
          let memoKey = key(k, d)
          if let known = memo[memoKey], used + known >= best { return }

          // ボタンが尽きた
          if k == buttons.count { return }

          // 最後のボタンの強い判定
          if k == buttons.count - 1 {
              let S = Set(buttons[k].idxs)
              var required: Int? = nil
              for i in 0..<m {
                  if S.contains(i) {
                      if required == nil { required = d[i] }
                      else if d[i] != required! { return }
                  } else {
                      if d[i] != 0 { return }
                  }
              }
              let add = required ?? 0
              best = min(best, used + add)
              memo[memoKey] = add
              return
          }

          let btn = buttons[k]
          // 押せる最大回数
          var maxPress = Int.max
          for i in btn.idxs { maxPress = min(maxPress, d[i]) }
          if maxPress < 0 { return }

          // できるだけ早く best を小さくしたいので、多めに押す方から試すのが効くことが多い
          // （ケース次第なので 0..maxPress の順でもOK）
          for x in stride(from: maxPress, through: 0, by: -1) {
              var nd = d
              if x > 0 {
                  for i in btn.idxs { nd[i] -= x }
              }
              // オーバーしてたら無効（理屈上は起きないが安全）
              if nd.contains(where: { $0 < 0 }) { continue }

              dfs(k + 1, nd, used + x)
          }

          // memo：この状態からの最小追加押下の近似（bestが更新された場合にのみ保存でもOK）
          memo[memoKey] = max(0, best - used)
      }

      dfs(0, target, 0)
      return best == Int.max ? nil : best
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let inputs = entities.first else { return 0 }
    var answer = 0
    for line in inputs {
      let info = line.split(separator: " ").compactMap { String($0) }
      guard let _ = info.first,
            let requirement = info.last else { continue }
      let buttons = info.dropFirst().dropLast().map {
        $0.dropFirst().dropLast().split(separator: "," ).compactMap { Int($0) }
      }
      let requireValues = requirement.dropFirst().dropLast().split(separator: ",").compactMap { Int($0) }
      answer += solveMachine(target: requireValues, rawButtons: buttons) ?? 0
    }
    return answer
  }
}
