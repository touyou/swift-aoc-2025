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
    guard let entity = entities.first else { return 0 }
    let operations = entity.popLast()?.split(separator: " ")?.filter { $0.isNotEmpty }.compactMap { String($0) } ?? []
    let numbers = entity.map { $0.split(separator: " ").filter { $0.isNotEmpty }.compactMap { Int($0) } }
    var answer = 0
    for i in 0..<operations.count {
      if operations[i] == "*" {
        answer += numbers.reduce(1) { result, array in result *= array[i] }
      } else {
        answer += numbers.reduce(0) { result, array in result += array[i] }
      }
    }

    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}
