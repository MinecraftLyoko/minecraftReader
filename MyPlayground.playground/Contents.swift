import Foundation

let testData = NSData(bytes: [0xff, 0xff, 0xff, 0xe0] as [UInt8], length: 4)


let goal = -32

let lengthData = [
    testData.subdataWithRange(NSRange(location: 0, length: 1)),
    testData.subdataWithRange(NSRange(location: 1, length: 1)),
    testData.subdataWithRange(NSRange(location: 2, length: 1)),
    testData.subdataWithRange(NSRange(location: 3, length: 1))
]
var len1: Int32 = 0
let ld = NSMutableData()
ld.appendData(lengthData[3])
ld.appendData(lengthData[2])
ld.appendData(lengthData[1])
ld.appendData(lengthData[0])
ld.getBytes(&len1, length: 4)
len1

let truthyData = NSData(bytes: [0x01], length: 1)
let falsyData = NSData(bytes: [0x10], length: 1)

var truthy: Bool?
falsyData.getBytes(&truthy, length: 1)
truthy

truthy = Bool(10)