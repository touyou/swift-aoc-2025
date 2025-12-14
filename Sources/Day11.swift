import Algorithms

struct Day11: AdventDay {
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
    guard let entry = entities.first else { return 0 }
    var paths: [String: [String]] = [:]
    for line in entry {
      let p = line.split(separator: " ").compactMap { String($0) }
      let from = String(p.first!.dropLast())
      paths[from] = Array(p.dropFirst())
    }
    
    func bfs(from: String) -> Int {
      if from == "out" {
        return 1
      }
      return paths[from]?.reduce(0) {
        $0 + bfs(from: $1)
      } ?? 0
    }
    
    return bfs(from: "you")
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let entry = entities.first else { return 0 }
    var paths: [String: [String]] = [:]
    for line in entry {
      let p = line.split(separator: " ").compactMap { String($0) }
      let from = String(p.first!.dropLast())
      paths[from] = Array(p.dropFirst())
    }
    
    var memo: [String: Int] = [:]
    
    func bfs(from: String, fftFlag: Bool, dacFlag: Bool) -> Int {
      if from == "out" {
        return fftFlag && dacFlag ? 1 : 0
      }
      if let cached = memo["\(from)_\(fftFlag)_\(dacFlag)"] {
        return cached
      }
      memo["\(from)_\(fftFlag)_\(dacFlag)"] = paths[from]?.reduce(0) {
        $0 + bfs(from: $1, fftFlag: fftFlag || from == "fft", dacFlag: dacFlag || from == "dac")
      } ?? 0
      return memo["\(from)_\(fftFlag)_\(dacFlag)"]!
    }
    
    return bfs(from: "svr", fftFlag: false, dacFlag: false)
  }
}
