

import Foundation



var results = [Int]()

for n in 1...100 {
    if n % 2 != 0 && n % 7 == 0 {
        results.append(n)
    }
}

results

let a = ["a":1,
        "b":2]
let b = ["c":3,
        "d":4]

let array = [a,b]

array[0]
