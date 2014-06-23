//
//  ViewController.swift
//  WordFrequency
//
//  Created by Tim Stephenson on 6/19/14.
//  Copyright (c) 2014 Tim Stephenson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView
    @IBOutlet var commonWordsTextView: UITextView

                            
    override func viewDidLoad() {
        super.viewDidLoad()
        var wordFrequency =  WordFrequency()
        var mostFrequentWords = wordFrequency.fasterSorteddWordFrequency(textView.text, limit: 20)
        var sentences = NSMutableArray(capacity: 0)
        
        for (index, word : AnyObject) in enumerate(mostFrequentWords) {
            let wordString = word["word"]
            let frequency = word["count"]
            sentences.addObject("\(index + 1). '\(wordString)' appears \(frequency) times.")
        }
        commonWordsTextView.text = sentences.componentsJoinedByString("\n")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

