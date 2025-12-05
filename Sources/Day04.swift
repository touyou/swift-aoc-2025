import Algorithms

struct Day04: AdventDay {
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
    guard let paperMap = entities.first else { return 0 }
    
    let adjCoord = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    var answer = 0
    
    for y in 0..<paperMap.count {
      for x in 0..<paperMap[y].count {
        if paperMap[y].dropFirst(x).prefix(1) != "@" { continue }
        let adjPaperCount = adjCoord.reduce(0) { result, coord in
          let nx = x + coord.0
          let ny = y + coord.1
          if ny >= 0 && nx >= 0 && nx < paperMap[y].count && ny < paperMap.count && paperMap[ny].dropFirst(nx).prefix(1) == "@" {
            return result + 1
          } else {
            return result
          }
        }
        if adjPaperCount < 4 {
          answer += 1
        }
      }
    }
    
    return answer
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let paperMap = entities.first else { return 0 }
    
    let adjCoord = [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    var answer = 0
    var flags = Array<Array<Bool>>(repeating: .init(repeating: false, count: paperMap.first!.count), count: paperMap.count)
    
    while true {
      var count = 0
      for y in 0..<paperMap.count {
        for x in 0..<paperMap[y].count {
          if paperMap[y].dropFirst(x).prefix(1) != "@" || flags[y][x] { continue }
          let adjPaperCount = adjCoord.reduce(0) { result, coord in
            let nx = x + coord.0
            let ny = y + coord.1
            if ny >= 0 && nx >= 0 && nx < paperMap[y].count && ny < paperMap.count && paperMap[ny].dropFirst(nx).prefix(1) == "@" && !flags[ny][nx] {
              return result + 1
            } else {
              return result
            }
          }
          if adjPaperCount < 4 {
            flags[y][x] = true
            count += 1
          }
        }
      }
      if count == 0 { break }
      answer += count
    }
    
    return answer
  }
}



