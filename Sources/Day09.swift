import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[[Int]]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0).split(separator: ",").compactMap { Int($0) } }
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    guard let vec = entities.first else { return 0 }
    var maxArea = 0
    for i in 0..<vec.count {
      for j in i+1..<vec.count {
        let a = vec[i]
        let b = vec[j]
        let area = (abs(a[0] - b[0]) + 1) * (abs(a[1] - b[1]) + 1)
        maxArea = max(maxArea, area)
      }
    }
    return maxArea
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let vec = entities.first else { return 0 }
    
    // === 1. 座標圧縮の準備 ===================================
    // すべての赤タイルの x, y を集めてユニーク化
    var xsSet = Set<Int>()
    var ysSet = Set<Int>()
    
    for p in vec {
      xsSet.insert(p[0])
      ysSet.insert(p[1])
    }
    
    var xs = Array(xsSet).sorted()
    var ys = Array(ysSet).sorted()
    
    // 圧縮グリッドの「セル」は [xs[i], xs[i+1]) × [ys[j], ys[j+1]) を表す
    // セル数は (xs.count - 1) × (ys.count - 1)
    if xs.count < 2 || ys.count < 2 {
      return 0
    }
    
    let Wc = xs.count - 1
    let Hc = ys.count - 1
    
    // 元座標 -> 圧縮インデックス
    var xIndex = [Int: Int]()
    for (i, x) in xs.enumerated() {
      xIndex[x] = i
    }
    
    var yIndex = [Int: Int]()
    for (i, y) in ys.enumerated() {
      yIndex[y] = i
    }
    
    // === 2. ポリゴン内判定（連続座標系） =====================
    
    // vec を頂点列とみなして point-in-polygon（レイキャスト法）
    func isInside(_ px: Double, _ py: Double) -> Bool {
      var inside = false
      let n = vec.count
      
      for i in 0..<n {
        let a = vec[i]
        let b = vec[(i + 1) % n]
        
        let x1 = Double(a[0])
        let y1 = Double(a[1])
        let x2 = Double(b[0])
        let y2 = Double(b[1])
        
        // y をまたいでいる辺だけ見る
        if (y1 > py) != (y2 > py) {
          // その y での交点 x
          let xCross = x1 + (py - y1) * (x2 - x1) / (y2 - y1)
          if xCross > px {
            inside.toggle()
          }
        }
      }
      
      return inside
    }
    
    // === 3. 圧縮グリッド上で validMap を作る =================
    
    // validMap[y][x] == true なら、そのセルは「赤 or 緑タイルだけ」の領域
    var validMap = Array(
      repeating: Array(repeating: false, count: Wc),
      count: Hc
    )
    
    for gy in 0..<Hc {
      // セルの y 範囲 [ys[gy], ys[gy+1]) の中央
      let y0 = ys[gy]
      let y1 = ys[gy + 1]
      let cy = Double(y0 + y1) * 0.5
      
      for gx in 0..<Wc {
        // セルの x 範囲 [xs[gx], xs[gx+1]) の中央
        let x0 = xs[gx]
        let x1 = xs[gx + 1]
        let cx = Double(x0 + x1) * 0.5
        
        if isInside(cx, cy) {
          validMap[gy][gx] = true
        }
      }
    }
    
    // === 4. 2D 累積和 (invalidCountMap) =======================
    
    // validMap == false のセルを 1 として 2D 累積和
    var invalidCountMap = Array(
      repeating: Array(repeating: 0, count: Wc + 1),
      count: Hc + 1
    )
    
    for y in 0..<Hc {
      for x in 0..<Wc {
        let v = validMap[y][x] ? 0 : 1
        invalidCountMap[y + 1][x + 1] =
        v
        + invalidCountMap[y][x + 1]
        + invalidCountMap[y + 1][x]
        - invalidCountMap[y][x]
      }
    }
    
    func invalidCount(_ y1: Int, _ x1: Int, _ y2: Int, _ x2: Int) -> Int {
      // y1..y2, x1..x2 (セルインデックスの閉区間)
      return invalidCountMap[y2 + 1][x2 + 1]
      - invalidCountMap[y1][x2 + 1]
      - invalidCountMap[y2 + 1][x1]
      + invalidCountMap[y1][x1]
    }
    
    // === 5. 赤ペア全探索（面積は元座標で計算） ================
    
    var maxArea = 0
    
    for i in 0..<vec.count {
      for j in (i + 1)..<vec.count {
        let a = vec[i]
        let b = vec[j]
        
        // 同じ行 or 列なら長方形にならない
        if a[0] == b[0] || a[1] == b[1] {
          continue
        }
        
        let ax = min(a[0], b[0])
        let bx = max(a[0], b[0])
        let ay = min(a[1], b[1])
        let by = max(a[1], b[1])
        
        // 圧縮座標系でのインデックス取得
        guard let ix1 = xIndex[ax],
              let ix2 = xIndex[bx],
              let iy1 = yIndex[ay],
              let iy2 = yIndex[by] else {
          continue
        }
        
        // セルは [xs[i], xs[i+1]), [ys[j], ys[j+1]) なので、
        // 辺 ax..bx, ay..by に対応するセル範囲は
        //   x: ix1 ..< ix2
        //   y: iy1 ..< iy2
        let x1 = ix1
        let x2 = ix2 - 1
        let y1 = iy1
        let y2 = iy2 - 1
        
        if x1 > x2 || y1 > y2 {
          continue
        }
        
        // この長方形に「invalid セル」が 0 なら OK
        if invalidCount(y1, x1, y2, x2) == 0 {
          // 面積は元座標系のタイル数で計算
          let area = (bx - ax + 1) * (by - ay + 1)
          maxArea = max(maxArea, area)
        }
      }
    }
    
    return maxArea
  }
}
