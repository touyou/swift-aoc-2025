import Algorithms

struct Day05: AdventDay {
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
    guard let rangesStr = entities.first else { return 0 }
    guard let entity = entities.last else { return 0 }
    
    let ranges = rangesStr.map { $0.split(separator: "-").compactMap {
      Int(String($0))
    } }
    
    return entity.reduce(0) { result, id in
      ranges.contains(where: { $0[0]...$0[1] ~= Int(id)! }) ? result + 1 : result
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let rangesStr = entities.first else { return 0 }
    
    let ranges = rangesStr.map { $0.split(separator: "-").compactMap {
      Int(String($0))
    } }.sorted(by: { $0[0] < $1[0] })
    
    var freshMap = [(Int, Int)]()
    for rn in ranges {
      let l = rn[0]
      let r = rn[1]
      var flag = false
      for i in 0..<freshMap.count {
        if l <= freshMap[i].1 && r >= freshMap[i].1 {
          freshMap[i] = (freshMap[i].0, r)
          flag = true
          break
        } else if l <= freshMap[i].1 {
          flag = true
          break
        }
      }
      if !flag {
        freshMap.append((l, r))
      }
    }
    
    return freshMap.reduce(0) { $0 + ($1.1 - $1.0 + 1) }
  }
}
