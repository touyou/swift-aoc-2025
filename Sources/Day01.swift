import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { rotate in
        if rotate.starts(with: "L") {
          Int("-\(rotate.dropFirst())")
        } else {
          Int(rotate.dropFirst())
        }
      }
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    var dialState = 50
    var answer = 0
    
    guard let firstEntity = entities.first else {
      return 0
    }
    
    firstEntity.forEach { rotate in
      dialState += rotate
      if dialState < 0 {
        repeat {
          dialState += 100
        } while dialState < 0
      } else if dialState >= 100 {
        repeat {
          dialState -= 100
        } while dialState >= 100
      }
      
      if dialState == 0 {
        answer += 1
      }
    }
    
    return answer
  }
  
  func part2() -> Int {
    var dialState = 50
    var answer = 0
    
    guard let firstEntity = entities.first else {
      return 0
    }
    
    firstEntity.forEach { rotate in
      let from = dialState
      let to = dialState + rotate
      // 50 → -18 ... 1
      // 52 → 100(0) ... 1
      // fromは0-99
      // toはどういう数字にもなる
      // toが負の数のとき→-108なら2、-204なら3
      // だけどfromが0なら端の処理はしない
//      print(from, to, answer)
      if to < 0 {
        let diff = abs(to) / 100
        answer += diff + (from == 0 ? 0 : 1)
        dialState = to + 100 * (diff + (abs(to) % 100 == 0 ? 0 : 1))
      } else if 99 < to {
        let diff = to / 100
        answer += diff
        dialState = to - 100 * diff
      } else {
        dialState = to
        if to == 0 {
          answer += 1
        }
      }
    }
    
    return answer
  }
}
