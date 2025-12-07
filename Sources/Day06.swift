import Algorithms

struct Day06: AdventDay {
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
    guard var entity = entities.first else { return 0 }
    let operations = entity.popLast()?.split(separator: " ").compactMap { String($0) } ?? []
    let numbers = entity.map { $0.split(separator: " ").compactMap { Int($0) } }
    var answer = 0
    for i in 0..<operations.count {
      if operations[i] == "*" {
        answer += numbers.reduce(1) { result, array in result * array[i] }
      } else {
        answer += numbers.reduce(0) { result, array in result + array[i] }
      }
    }

    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard var entity = entities.first else { return 0 }
    let operations = entity.popLast() ?? ""
    let numbers = entity
    var answer = 0
    var tempAnswer = 0
    var lastOp = ""
    for i in 0..<operations.count {
      var numStr = ""
      let op = String(operations.dropFirst(i).prefix(1))
      for j in 0..<numbers.count {
        let char = String(numbers[j].dropFirst(i).prefix(1))
        if !char.isEmpty {
          numStr += char
        }
      }
      let num = Int(numStr.trimmingCharacters(in: .whitespacesAndNewlines))
      if num == nil {
        answer += tempAnswer
        tempAnswer = 0
        continue
      }
      if op == "*" {
        tempAnswer = num ?? 1
        lastOp = "*"
      } else if op == "+" {
        tempAnswer = num ?? 0
        lastOp = "+"
      } else if lastOp == "*" {
        tempAnswer *= num ?? 1
      } else if lastOp == "+" {
        tempAnswer += num ?? 0
      }
    }
    if tempAnswer != 0 {
      answer += tempAnswer
    }
    return answer
  }
}
