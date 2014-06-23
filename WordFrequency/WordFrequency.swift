//
//  WordFrequency.swift
//  WordFrequency
//
//  Created by Tim Stephenson on 6/19/14.
//  Copyright (c) 2014 Tim Stephenson. All rights reserved.
//

import UIKit

class WordFrequency {
    
    let sortDescriptor = NSSortDescriptor(key: "count", ascending: false)

    init() {
        
    }
    
    /*
    
    There are two implementations of the sortedWordFrequency method.
    
    Both methods take two parameters:
    (1) a String representing the contents of a text document
    (2) an integer providing the number of items to return
    
    Both methods return a sorted array of dictionary objects that contains the Strings ordered by word frequency, 
    the most frequently occurring word first.
    
    The first, sortedWordFrequency uses an enumerator to iterate over the string and add words
    to a NSCounted set.
    
    
    The second, fasterSortedWordFrequency splits the words into an array using NSMutableCharacterSet 
    as separators, and then adds the array to the NSCounted set, eliminating a high level enumeration.
    
    While the second approach is faster, words wrapped in single quotes will be added with the quotes,
    and phrases with single quotes may create words with a leading or trailing single quote. I'm sure this
    could be over come given a little extra time. In many cases this may be acceptable, so I'm leaving 
    both methods in the class for additional exploration.
    
    See tests for more information.

    */
    
    func sortedWordFrequency(text: String, limit: Int) -> NSArray {
        var wordsSubset: NSArray
        var unsortedWords = NSMutableArray(capacity: 0)
        let countedWords = countedSetFromString(text)
        
        countedWords.enumerateObjectsUsingBlock({ object, stop in
            unsortedWords.addObject([ "word": object, "count": countedWords.countForObject(object) ])
        })
        
        return sortedListWithLimit(unsortedWords, limit: limit)
        
    }
    
    /*
    countedSetFromString(text: String) -> NSCountedSet 
    
    Takes a string paramter and returns a NSCountedSet object.
    Enumerates over a string adding words to the counted set.
    */

    func countedSetFromString(text: String) -> NSCountedSet {
        var countedWords = NSCountedSet()
        let enumerationOptions: NSStringEnumerationOptions = .ByWords | .Localized
        let range = Range(start: text.startIndex, end: text.endIndex)
        let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        text.enumerateSubstringsInRange(range, options: enumerationOptions, { substring, _, _, _ in
            let trimmedString = substring.stringByTrimmingCharactersInSet(characterSet)
            if !trimmedString.isEmpty {
                countedWords.addObject(trimmedString.lowercaseString)
            }
        })
        return countedWords
    }
    
    
    
    /*
    This approach uses a character set to split the string into an array.
    Reducing enumeration should improve performance.
    */
    
    func fasterSorteddWordFrequency(text: NSString, limit: Int) -> NSArray {
        
        var countedSetOfWords: NSCountedSet
        var unsortedWords = NSMutableArray(capacity: 0)
        
        countedSetOfWords = NSCountedSet(array: arrayOfWordsFromString(text))
    
        countedSetOfWords.enumerateObjectsUsingBlock({ object, stop in
            unsortedWords.addObject([ "word": object, "count": countedSetOfWords.countForObject(object) ])
        })
        
        return sortedListWithLimit(unsortedWords, limit: limit)
    }
    
    /*
    Takes one argument, text as an NSString and
    builds an array removing whitespace and punctuation, except for single quotes.
    */
    func arrayOfWordsFromString(text :NSString) -> NSArray {
        
        var separators = NSMutableCharacterSet.alphanumericCharacterSet()
        separators.formUnionWithCharacterSet(NSCharacterSet(charactersInString: "'"))
        
        // Split the text into an array using the characterset separators.
        // Remove empty strings from the array
        var words: NSArray = text.lowercaseString.componentsSeparatedByCharactersInSet(separators.invertedSet)
        return words.filteredArrayUsingPredicate( NSPredicate(format: "self <> ''") )
    }
    
    // Expects two argumennts 
    // 1. an array of dictionary objects 
    // 2. An intger to limit the number of items returned.
    // The array is sorted according to the sortDescriptor.
    // If the resulting arrya is longer than the limit, a range of the array is returned.
    func sortedListWithLimit(unsortedWords: NSMutableArray, limit: Int) -> NSArray {
        var wordsSubset: NSArray
        wordsSubset = unsortedWords.sortedArrayUsingDescriptors( [ self.sortDescriptor ] )
        
        if wordsSubset.count < limit {
            return wordsSubset
        } else {
            return wordsSubset.subarrayWithRange(NSMakeRange(0, limit))
        }
    }
}
