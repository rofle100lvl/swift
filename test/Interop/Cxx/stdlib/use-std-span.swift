// RUN: %target-run-simple-swift(-I %S/Inputs -Xfrontend -enable-experimental-cxx-interop -Xcc -std=c++20)
// RUN: %target-run-simple-swift(-I %S/Inputs -Xfrontend -enable-experimental-cxx-interop -Xcc -std=c++20 -Xcc -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST)

// FIXME swift-ci linux tests do not support std::span
// UNSUPPORTED: OS=linux-gnu

// REQUIRES: executable_test

import StdlibUnittest
#if !BRIDGING_HEADER
import StdSpan
#endif
import CxxStdlib

var StdSpanTestSuite = TestSuite("StdSpan")

func takesSpanOfInt(_ s: Span) {
  expectEqual(s.size(), 3)
  expectFalse(s.empty())

  expectEqual(s[0], 1)
  expectEqual(s[1], 2)
  expectEqual(s[2], 3)
}

func takesSpanOfString(_ s: SpanOfString) {
  expectEqual(s.size(), 3)
  expectFalse(s.empty())

  expectEqual(s[0], "")
  expectEqual(s[1], "ab")
  expectEqual(s[2], "abc")
}

// func returnsSpanOfInt() -> Span {
//   let arr: [Int32] = [1, 2, 3]
//   return arr.withUnsafeBufferPointer { ubpointer in
//     return Span(ubpointer)
//   }
// }

// func returnsSpanOfInt(_ arr: [Int32]) -> Span {
//   return arr.withUnsafeBufferPointer { ubpointer in
//     return Span(ubpointer)
//   }
// }

// func returnsSpanOfString() -> SpanOfString {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   return arr.withUnsafeBufferPointer { ubpointer in
//     return SpanOfString(ubpointer)
//   }
// }

// func returnsSpanOfString(_ arr: [std.string]) -> SpanOfString {
//   return arr.withUnsafeBufferPointer { ubpointer in
//     return SpanOfString(ubpointer)
//   }
// }

// func accessSpanAsGenericParam<T: RandomAccessCollection>(_ col: T) 
//                                               where T.Index == Int, T.Element == Int32 {
//   expectEqual(col.count, 3)                     
//   expectFalse(col.isEmpty)

//   expectEqual(col[0], 1)
//   expectEqual(col[1], 2)
//   expectEqual(col[2], 3)
// }

// // TODO redo this func
// func accessSpanAsSomeGenericParam(_ col: some CxxRandomAccessCollection) {
//   expectEqual(col.count, 3)                     
//   expectFalse(col.isEmpty)

//   // if (accessInvalid) {
//   //     // FIXME this does not trap
//   //     print("> Invalid element...")
//   //     print(col[5]);
//   // }
// }

StdSpanTestSuite.test("EmptySpan") {
  // let s = Span()
  // expectEqual(s.size(), 0)
  // expectTrue(s.empty())

  let cs = ConstSpan()
  expectEqual(cs.size(), 0)
  expectTrue(cs.empty())
}

StdSpanTestSuite.test("Init SpanOfInt") {
  // let s = initSpan()
  // expectEqual(s.size(), 3)
  // expectFalse(s.empty())

  let cs = initSpan()
  expectEqual(cs.size(), 3)
  expectFalse(cs.empty())
}

StdSpanTestSuite.test("Access static SpanOfInt") {
  expectEqual(ispan.size(), 3)
  expectFalse(ispan.empty())

  expectEqual(Int(ispan[0]), 1)
  // expectEqual(ispan[1], 2)
  // expectEqual(ispan[2], 3)
}

// StdSpanTestSuite.test("Access static SpanOfString") {
//   expectEqual(sspan.size(), 3)
//   expectFalse(sspan.empty())

//   expectEqual(sspan[0], "")
//   expectEqual(sspan[1], "ab")
//   expectEqual(sspan[2], "abc")
// }

// StdSpanTestSuite.test("SpanOfInt as Param") {
//   takesSpanOfInt(ispan)
// }

// StdSpanTestSuite.test("SpanOfString as Param") {
//   takesSpanOfString(sspan)
// }

// StdSpanTestSuite.test("Return SpanOfInt") {
//   let s1 = returnsSpanOfInt()
//   expectEqual(s1.size(), 3)
//   expectFalse(s1.empty())

//   let arr: [Int32] = [4, 5, 6, 7]
//   let s2 = returnsSpanOfInt(arr)
//   expectEqual(s2.size(), 4)
//   expectFalse(s2.empty())

//   expectEqual(s2[0], 4)
//   expectEqual(s2[1], 5)
//   expectEqual(s2[2], 6)
//   expectEqual(s2[3], 7)
// }

// StdSpanTestSuite.test("Return SpanOfString") {
//   let s1 = returnsSpanOfString()
//   expectEqual(s1.size(), 4)
//   expectFalse(s1.empty())

//   let arr: [std.string] = ["", "a", "ab"]
//   let s2 = returnsSpanOfString(arr)
//   expectEqual(s2.size(), 3)
//   expectFalse(s2.empty())

//   expectEqual(s2[0], "")
//   expectEqual(s2[1], "a")
//   expectEqual(s2[2], "ab")
// }

StdSpanTestSuite.test("SpanOfInt.init(addr, count)") {
  let arr: [Int32] = [1, 2, 3]
  arr.withUnsafeBufferPointer { ubpointer in
    // TODO the below probably doesn't work because we have to have a constructor with UnsafeMutableBufferPointer for nonconst spans
    // let s = Span(ubpointer.baseAddress!, ubpointer.count)
    let s = ConstSpan(ubpointer.baseAddress!, ubpointer.count)
    
    expectEqual(s.size(), 3)
    expectFalse(s.empty())

    

    print(s[0])
    expectEqual(Int(s[0]), 1)
    // expectEqual(s[1], 2)
    // expectEqual(s[2], 3)
  }
}

// StdSpanTestSuite.test("ConstSpanOfInt.init(addr, count)") {
//   let arr: [Int32] = [1, 2, 3]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = ConstSpan(ubpointer.baseAddress!, ubpointer.count)

//     print("Got here")
    // print(s[0])
    
    // expectEqual(s.size(), 3)
    // expectFalse(s.empty())

    // expectEqual(s[0], 1)
    // expectEqual(s[1], 2)
    // expectEqual(s[2], 3)
//   }
// }

// StdSpanTestSuite.test("SpanOfInt.init(ubpointer)") {
//   let arr: [Int32] = [1, 2, 3]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = Span(ubpointer)
    
//     expectEqual(s.size(), 3)
//     expectFalse(s.empty())

//     expectEqual(s[0], 1)
//     expectEqual(s[1], 2)
//     expectEqual(s[2], 3)
//   }
// }

// StdSpanTestSuite.test("SpanOfString.init(addr, count)") {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = SpanOfString(ubpointer.baseAddress!, ubpointer.count)
    
//     expectEqual(s.size(), 4)
//     expectFalse(s.empty())

//     expectEqual(s[0], "")
//     expectEqual(s[1], "a")
//     expectEqual(s[2], "ab")
//     expectEqual(s[3], "abc")
//   }
// }

// StdSpanTestSuite.test("SpanOfString.init(ubpointer)") {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = SpanOfString(ubpointer)
    
//     expectEqual(s.size(), 4)
//     expectFalse(s.empty())

//     expectEqual(s[0], "")
//     expectEqual(s[1], "a")
//     expectEqual(s[2], "ab")
//     expectEqual(s[3], "abc")
//   }
// }

// StdSpanTestSuite.test("SpanOfInt for loop") {
//   let arr: [Int32] = [1, 2, 3]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = Span(ubpointer)

//     var count: Int32 = 1
//     for e in s {
//       expectEqual(e, count)
//       count += 1
//     }

//     expectEqual(count, 4)
//   }
// }

// StdSpanTestSuite.test("SpanOfString for loop") {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = SpanOfString(ubpointer)
    
//     var count = 0
//     for e in s {
//       count += e.length();
//     }

//     expectEqual(count, 6)
//   }
// }

// StdSpanTestSuite.test("SpanOfInt.map") {
//   let arr: [Int32] = [1, 2, 3]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = Span(ubpointer)
//     let result = s.map { $0 + 5 }
//     expectEqual(result, [6, 7, 8])
//   }
// }

// StdSpanTestSuite.test("SpanOfString.map") {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = SpanOfString(ubpointer)
//     let result = s.map { $0.length() }
//     expectEqual(result, [0, 1, 2, 3])
//   }
// }

// StdSpanTestSuite.test("SpanOfInt.filter") {
//   let arr: [Int32] = [1, 2, 3, 4, 5]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = Span(ubpointer)
//     let result = s.filter { $0 > 3 }
//     expectEqual(result.count, 2)
//     expectEqual(result, [4, 5])
//   }
// }

// StdSpanTestSuite.test("SpanOfString.filter") {
//   let arr: [std.string] = ["", "a", "ab", "abc"]
//   arr.withUnsafeBufferPointer { ubpointer in
//     let s = SpanOfString(ubpointer)
//     let result = s.filter { $0.length() > 1}
//     expectEqual(result.count, 2)
//     expectEqual(result, ["ab", "abc"])
//   }
// }

// StdSpanTestSuite.test("Initialize Array from SpanOfInt") {
//   let arr: [Int32] = [1, 2, 3]
//   let span: Span = returnsSpanOfInt(arr)
//   let newArr = Array(span)

//   expectEqual(arr.count, newArr.count)
//   expectEqual(arr, newArr)
// }

// StdSpanTestSuite.test("Initialize Array from SpanOfString") {
//   let arr: [std.string] = ["", "a", "ab"]
//   let span: SpanOfString = returnsSpanOfString(arr)
//   let newArr = Array(span)

//   expectEqual(arr.count, newArr.count)
//   expectEqual(arr, newArr)
// }

// TODO remove this test and the code added for this test in std-span.h
// StdSpanTestSuite.test("rdar://126570011") {
//   var cp = CppApi()

//   let span = cp.getSpan()
//   print(span[0])
//   print(span[1])
//   // TODO this DOESN'T trap
//   print(span[3])

//   let constSpan = cp.getConstSpan()
//   print(constSpan[0])
//   print(constSpan[1])
//   // TODO this traps
//   // print(constSpan[3])
// }

// StdSpanTestSuite.test("Span as arg to generic func") {
//   accessSpanAsGenericParam(ispan)
//   accessSpanAsSomeGenericParam(ispan)
// }

StdSpanTestSuite.test("Span non const") {
  let span1 = Span()
  let span2 = ConstSpan()
}

runAllTests()
