//
//  WordFrequencyTests.swift
//  WordFrequencyTests
//
//  Created by Tim Stephenson on 6/19/14.
//  Copyright (c) 2014 Tim Stephenson. All rights reserved.
//

import XCTest
import WordFrequency

class WordFrequencyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    let sampleText = "One string, two string, three string more. That's three. ... ,,, ;;;"
    let longerText = " G minor has been considered the key through which Wolfgang Amadeus Mozart best expressed sadness and tragedy,[1] and many of his minor key works are in G minor, such as the Piano Quartet No. 1 and the String Quintet in G minor. Though Mozart touched on various minor keys in his symphonies, G minor is the only minor key he used as a main key for his numbered symphonies (No. 25, and the famous No. 40). In the Classical period, symphonies in G minor almost always used four horns, two in G and two in B-flat alto.[2] Another convention of G minor symphonies observed in Mozart's No. 25 was the choice of E-flat major for the slow movement, with other examples including Haydn's No. 39 and Johann Baptist Wanhal's G minor symphony from before 1771 (Bryan Gm1).[3] "
    let words = WordFrequency()
    
    // Describe .countedSetFromString(text: String) -> NSCountedSet
    func testCountedSetFromStringReturnsSet(){
        var set = words.countedSetFromString(sampleText)
        assert(set.count == 6, "There should be 6 elements in the set.")
    }
    
    func testCountedSetFromStringContainsWordsWithApostrophes() {
        var set = words.countedSetFromString(sampleText)
        assert(set.countForObject("that's") == 1, "There should be one instance of the word that's, and it should be lower case")
    }
    
    func testCountedSetFromStringRemovesQuotesAroundString() {
        var set = words.countedSetFromString(" Did you eat your 'spinach'?   ")
        assert(set.countForObject("spinach") == 1, "Words wrapped in quotes should exist without quotes.")
    }
    
    // Describe .sortedListWithLimit(unsortedWords: NSMutableArray, limit: Int) -> NSArray
    func testSortedListWithLimitShouldReturnLimitNumberOfItems() {
        var testArray: NSMutableArray = [ [ "word": "zebra", "count": 3 ], [ "word": "test", "count": 5 ], [ "word": "swift", "count": 2 ] ]
        var sortedWords = words.sortedListWithLimit(testArray, limit: 1)
        assert(sortedWords.count == 1, "There should be only one element in the array.")
    }
    
    func testSortedListWithLimitShouldReturnAllItemsWhenLimitIsLarger() {
        var testArray: NSMutableArray = [ [ "word": "zebra", "count": 3 ], [ "word": "test", "count": 5 ], [ "word": "swift", "count": 2 ] ]
        var sortedWords = words.sortedListWithLimit(testArray, limit: 100)
        assert(sortedWords.count == 3, "There should 3 elements in the array.")
    }
    
    func testSortedListWithLimitShouldReturnMostFrequentFirst() {
        var testArray: NSMutableArray = [ [ "word": "zebra", "count": 3 ], [ "word": "test", "count": 5 ], [ "word": "swift", "count": 2 ] ]
        var sortedWords = words.sortedListWithLimit(testArray, limit: 100)
        assert(sortedWords.objectAtIndex(0) as Dictionary == ["count": 5, "word": "test"], "Should return the word test with a count of 5 as the first object.")
    }
    
    
    // Describe .sortedWordFrequency(text: NSString, limit: Int) -> NSArray
    func testSortedWordFrequencyReturnsOnlyLimitNumberOfWords() {
        var sortedWords = words.sortedWordFrequency(sampleText, limit: 1)
        assert(sortedWords.count == 1, "Should only return the most frequenly used word.")
    }
    
    func testSortedWordFrequencyReturnsAllWhenLimitIsLargerThanText() {
        var sortedWords = words.sortedWordFrequency(sampleText, limit: 100)
        assert(sortedWords.count == 6, "Should return all of the words.")
    }
    
    func testSortedWordFrequencyReturnsMostCommonWordFirst() {
        var sortedWords = words.sortedWordFrequency(sampleText, limit: 1)
        assert(sortedWords.objectAtIndex(0) as Dictionary == ["count": 3, "word": "string"], "Should return the word string with a count of 3 as the first object.")
    }
    
    func testSortedWordFrequencyReturnsLimitOfWordsWithLessFrequentLast() {
        var sortedWords = words.sortedWordFrequency(sampleText, limit: 2)
        assert(sortedWords.count == 2, "Should contain the top 2 most fequently used words.")
        assert(sortedWords.objectAtIndex(1) as Dictionary == ["count": 2, "word": "three"], "Should return the word three with a count of 2 as the last object.")
    }
    
    // Describe .arrayOfWordsFromString(text: NSString) -> NSArray
    func testArrayOfWordsFromStringReturnsOnlyWords() {
        var wordArray = words.arrayOfWordsFromString(sampleText)
        assert(wordArray.count == 9, "There should be 9 words in the array.")
    }
    
    func testArrayOfWordsFromStringReturnsWordsWithApostrophes() {
        var wordArray = words.arrayOfWordsFromString("   You're on your way. It's true!   ")
        assert(wordArray.containsObject("you're"), "Words with apostrophes should still exist. But should be lowercase.")
    }
    
    // A side affect of keeping apostrophes is that words and phrases wrapped single quotes will be with the quote.
    // To do: If this is undesirable, implement less naive approach that also handles plural and other edge cases.
    func testArrayOfWordsFromStringReturnsWordsWrappedInSingleQuotes() {
        var wordArray = words.arrayOfWordsFromString(" Did you eat your 'spinach'?   ")
        assert(wordArray.containsObject("'spinach'"), "Words wrapped in quotes should still exist. But should be lowercase.")
    }
    
    // Describe .fasterSorteddWordFrequency(text: NSString, limit: Int) -> NSArray

    func testOrderedWordFrequencyReturnsOnlyLimitNumberOfWords() {
        var sortedWords = words.fasterSorteddWordFrequency(sampleText, limit: 1)
        assert(sortedWords.count == 1, "Should only return the most frequenly used word.")
    }
    
    func testOrderedWordFrequencyReturnsAllWhenLimitIsLargerThanText() {
        var sortedWords = words.fasterSorteddWordFrequency(sampleText, limit: 100)
        assert(sortedWords.count == 6, "Should return all of the words.")
    }
    
    func testOrderedWordFrequencyReturnsMostCommonWordFirst() {
        var sortedWords = words.fasterSorteddWordFrequency(sampleText, limit: 1)
        assert(sortedWords.objectAtIndex(0) as Dictionary == ["count": 3, "word": "string"], "Should return the word string with a count of 3 as the first object.")
    }
    
    func testOrderedWordFrequencyReturnsLimitOfWordsWithLessFrequentLast() {
        var sortedWords = words.fasterSorteddWordFrequency(sampleText, limit: 2)
        assert(sortedWords.count == 2, "Should contain the top 2 most fequently used words.")
        assert(sortedWords.objectAtIndex(1) as Dictionary == ["count": 2, "word": "three"], "Should return the word three with a count of 2 as the last object.")
    }
    
    
    func testPerformanceSortedFunction() {
        var longString: String = ""
        
        for index in 1...10 {
            longString += self.longerText
        }
        self.measureBlock() {
            var sortedWords = self.words.sortedWordFrequency(longString, limit: 5)
        }
    }
    
    func testPerformanceFasterSortedFunction() {
        var longString: String = ""
        
        for index in 1...10 {
            longString += self.longerText
        }
        self.measureBlock() {
            var sortedWords = self.words.fasterSorteddWordFrequency(longString, limit: 5)
        }
    }
    
    /*
    Data from test runs:
    ----------------------------------------------------------------------------
    Tested with a 191,250 character string
    ----------------------------------------------------------------------------

    sortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' measured [Time, seconds] average: 1.002, relative standard deviation: 1.322%, values: [1.016541, 1.021287, 1.021834, 0.988361, 0.984261, 0.995569, 0.991157, 0.997661, 0.994960, 1.009116], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' passed (10.276 seconds).

    fasterSortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' measured [Time, seconds] average: 0.380, relative standard deviation: 2.909%, values: [0.386779, 0.376786, 0.382008, 0.388674, 0.370943, 0.374471, 0.392994, 0.367216, 0.363750, 0.399509], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' passed (4.072 seconds).

    ----------------------------------------------------------------------------
    Tested with a 382,500 character string
    ----------------------------------------------------------------------------

    sortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' measured [Time, seconds] average: 1.990, relative standard deviation: 1.734%, values: [1.976570, 2.017328, 1.972574, 1.971819, 1.992775, 1.972114, 1.995366, 2.080359, 1.949934, 1.975073], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' passed (20.160 seconds).

    fasterSortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' measured [Time, seconds] average: 0.756, relative standard deviation: 3.222%, values: [0.813511, 0.785432, 0.765747, 0.730581, 0.750459, 0.737867, 0.743111, 0.737449, 0.743711, 0.754913], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' passed (7.832 seconds).

    ----------------------------------------------------------------------------
    Tested with a 765,000 character string
    ----------------------------------------------------------------------------

    sortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' measured [Time, seconds] average: 3.914, relative standard deviation: 1.171%, values: [3.822280, 3.877558, 3.854537, 3.961143, 3.909073, 3.928674, 3.959426, 3.932782, 3.965890, 3.926724], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' passed (39.397 seconds).


    fasterSortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' measured [Time, seconds] average: 1.459, relative standard deviation: 2.159%, values: [1.515130, 1.442619, 1.412087, 1.450892, 1.482716, 1.493607, 1.457090, 1.476443, 1.450611, 1.413150], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' passed (14.868 seconds).

    ----------------------------------------------------------------------------
    Tested with a 1,530,000 character string
    ----------------------------------------------------------------------------

    sortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' measured [Time, seconds] average: 8.020, relative standard deviation: 0.658%, values: [8.056669, 8.054256, 7.914557, 8.006360, 8.071031, 8.004312, 7.946460, 8.017376, 8.094148, 8.035664], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' passed (80.464 seconds).


    fasterSortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' measured [Time, seconds] average: 3.013, relative standard deviation: 1.036%, values: [2.991717, 2.971621, 3.013085, 2.992601, 2.995075, 2.989498, 3.007697, 3.038741, 3.048253, 3.079019], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' passed (30.413 seconds).

    ----------------------------------------------------------------------------
    Tested with a 3,060,000 character string
    ----------------------------------------------------------------------------

    sortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' measured [Time, seconds] average: 15.985, relative standard deviation: 1.119%, values: [15.883298, 16.373138, 16.217702, 15.850353, 16.085776, 16.014168, 15.882040, 15.917726, 15.853419, 15.776623], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceSortedFunction]' passed (160.126 seconds).


    fasterSortedWordFrequency performance test results:
    Test Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' measured [Time, seconds] average: 5.991, relative standard deviation: 1.184%, values: [5.905512, 5.952368, 5.957921, 6.074687, 5.888831, 5.997632, 6.087274, 5.946220, 5.997726, 6.098844], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
    XCTestOutputBarrierTest Case '-[_TtC18WordFrequencyTests18WordFrequencyTests testPerformanceFasterSortedFunction]' passed (60.195 seconds).

    */

}
