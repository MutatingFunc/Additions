import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AdditionsTests.allTests),
				testCase(FunctionOperatorTests.allTests),
    ]
}
#endif
