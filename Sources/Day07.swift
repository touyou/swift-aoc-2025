import Algorithms

struct Day07: AdventDay {
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
    guard let stage = entities.first else { return 0 }
    var answer = 0
    
    // Sからビームが出て
    // ^ではビームが分岐
    // 分岐する数=^と|が縦に並ぶ数
    let width = stage[0].count
    var beamFlags = Array(repeating: false, count: width)
    
    for line in stage {
      var tempFlags = Array(repeating: false, count: width)
      for i in 0..<width {
        if line[i] == "S" {
          tempFlags[i] = true
        } else if line[i] == "^" && beamFlags[i] {
          answer += 1
          if i - 1 >= 0 {
            tempFlags[i - 1] = true
          }
          if i + 1 < width {
            tempFlags[i + 1] = true
          }
        } else if beamFlags[i] {
          tempFlags[i] = true
        }
      }
      beamFlags = tempFlags
    }
    
    return answer
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let stage = entities.first else { return 0 }
    let width = stage[0].count
    var beamMap = Array(repeating: Array(repeating: 0, count: width), count: stage.count)
    for y in 0..<stage.count {
      for x in 0..<width {
        if stage[y][x] == "S" {
          beamMap[y][x] = 3
        } else if stage[y][x] == "^" && beamMap[y - 1][x] == 1 {
          beamMap[y][x] = 2
          if x - 1 >= 0 {
            beamMap[y][x - 1] = 1
          }
          if x + 1 < width {
            beamMap[y][x + 1] = 1
          }
        } else if y >= 1 && (beamMap[y - 1][x] == 1 || beamMap[y - 1][x] == 3) {
          beamMap[y][x] = 1
        }
      }
    }
    
    var answer = 0
    var dp = Array(repeating: Array(repeating: 0, count: width), count: stage.count)
    dp[stage.count - 1] = beamMap[stage.count - 1]
    for y in stride(from: stage.count - 2, through: 0, by: -1) {
      for x in 0..<width {
        if beamMap[y][x] == 1 {
          dp[y][x] = dp[y + 1][x]
        } else if beamMap[y][x] == 2 {
          if x - 1 >= 0 {
            dp[y][x] += dp[y + 1][x - 1]
          }
          if x + 1 < width {
            dp[y][x] += dp[y + 1][x + 1]
          }
        } else if beamMap[y][x] == 3 {
          dp[y][x] = dp[y + 1][x]
          answer = dp[y][x]
        }
      }
    }
    
    return answer
  }
}
