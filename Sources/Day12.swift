import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0) }
    }
  }
  
  func part1() -> Int {
    let problems = entities.last ?? []
    let baseCount = entities.dropLast().map {
      $0.reduce(0) {
        $0 + $1.filter { $0 == "#" }.count
      }
    }
    
    var answer = 0
    
    for line in problems {
      let problem = line.split(separator: " ").map { String($0) }
      let region = problem[0].dropLast().split(separator: "x").compactMap { Int($0) }
      let counts = problem.dropFirst().compactMap { Int($0) }
      let minCnt = counts.reduce(0, +)
      let maxCnt = baseCount.enumerated().reduce(0) {
        $0 + $1.element * counts[$1.offset]
      }
      if minCnt <= region[0] / 3 * region[1] / 3 && region[0] * region[1] >= maxCnt {
        answer += 1
      }
    }
    
    return answer
  }
  
  func part2() -> Any {
    0
  }
}
