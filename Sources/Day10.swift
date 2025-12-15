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
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let inputs = entities.first else { return 0 }
    var answer = 0
    for line in inputs {
      let info = line.split(separator: " ").compactMap { String($0) }
      guard let _ = info.first,
            let requirement = info.last else { continue }
      let buttons = info.dropFirst().dropLast().map {
        let toggles = $0.dropFirst().dropLast().split(separator: "," ).compactMap { Int($0) }
        return (toggles.reduce(0) {
          $0 | 1 << $1
        }, toggles)
      }
      let requireValues = requirement.dropFirst().dropLast().split(separator: ",").compactMap { Int($0) }
      var memo: [[Int]: Int] = [:]
      func solve(_ lights: [Int]) -> Int {
        if let ans = memo[lights] { return ans }
        if lights.allSatisfy({ $0 == 0 }) {
          memo[lights] = 0
          return 0
        }
        var temp = Int.max / 4
        let targetValue = lights.enumerated().reduce(0) {
          $0 | ($1.element % 2 == 1 ? 1 : 0) << $1.offset
        }
        for pattern in 0..<(1 << buttons.count) {
          var value = 0
          var cnt = 0
          var lightsCopy = lights
          
          for (i, button) in buttons.enumerated() {
            if (pattern & (1 << i)) != 0 {
              value ^= button.0
              cnt += 1
              button.1.forEach {
                lightsCopy[$0] -= 1
              }
            }
          }
          if value == targetValue && lightsCopy.allSatisfy({ $0 >= 0 }) {
            temp = min(temp, cnt + solve(lightsCopy.map { $0 / 2 }) * 2)
          }
        }
        memo[lights] = temp
        return temp
      }
      let tempAns = solve(requireValues)
      answer += tempAns
    }
    return answer
  }
}
