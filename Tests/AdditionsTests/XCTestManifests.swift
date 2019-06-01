import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AdditionsTests.allTests),
				testCase(ObservableTests.allTests),
				testCase(FunctionOperatorTests.allTests),
				testCase(ClosureExtensionsTests.allTests),
    ]
}
#endif
