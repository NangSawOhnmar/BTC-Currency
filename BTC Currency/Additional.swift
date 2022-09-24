//
//  Additional.swift
//  BTC Currency
//
//  Created by nang saw on 24/09/2022.
//

import Foundation

func generatePrimes(to n: Int) -> [Int] {
    if n <= 5 {
        return [2, 3, 5].filter { $0 <= n }
    }
    var arr = Array(stride(from: 3, through: n, by: 2))
    let squareRootN = Int(Double(n).squareRoot())
    for index in 0... {
        if arr[index] > squareRootN { break }
        let num = arr.remove(at: index)
        arr = arr.filter { $0 % num != 0 }
        arr.insert(num, at: index)
    }
    arr.insert(2, at: 0)
    return arr
}

func fibonacciSequence (n: Int) -> [Int]  {
    var fibonacciArray = [Int]()
    for n in 0 ... n {
        if n == 0 {
            fibonacciArray.append(0)
        }
        else if n == 1 {
            fibonacciArray.append(1)
        }
        else {
            fibonacciArray.append (fibonacciArray[n-1] + fibonacciArray[n-2] )
        }
    }
    return fibonacciArray
}

func filterArray(first_array: [Int], second_array: [Int]) -> [Int]{
    var array = [Int]()
    for i in first_array{
        array.append(second_array.first(where: { $0 == i })!)
    }
    return array
}
