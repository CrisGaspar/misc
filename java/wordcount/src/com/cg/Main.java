package com.cg;
// IMPORT LIBRARY PACKAGES NEEDED BY YOUR PROGRAM
// SOME CLASSES WITHIN A PACKAGE MAY BE RESTRICTED
// DEFINE ANY CLASS AND METHOD NEEDED
import com.sun.beans.editors.IntegerEditor;

import java.util.*;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

public class Main {

    // CLASS BEGINS, THIS CLASS IS REQUIRED
    public class Solution
    {
        public static final String SPLIT_REGEX = "\\w*";
        // METHOD SIGNATURE BEGINS, THIS METHOD IS REQUIRED

        List<String> retrieveMostFrequentlyUsedWords(String literatureText,
                                                     final List<String> wordsToExclude)
        {
            // split by whitespace
            List<String> words = Arrays.asList(literatureText.split(SPLIT_REGEX));

            // 1. Filter to exclude required words
            // 2. Collect using sum function t
            // Parallel to maximize efficiency
            ConcurrentMap<String, Integer> wordCounts = words.parallelStream()
                    .filter(word -> !wordsToExclude.contains(word))
                    .collect(Collectors.toConcurrentMap(word -> word,   //key mapper,
                                                        word -> 1,      //value mapper
                                                        Integer::sum));  //function to merge/reduce

            // 3. Look for largest counts and extract all ties
            Integer mostFrequentCount = wordCounts.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getValue);

            List<String> mostFrequentWords = wordCounts.entrySet().stream()
                    .filter(entry -> entry.getValue() == mostFrequentCount)
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());
            return mostFrequentWords;
        }
        // METHOD SIGNATURE ENDS
    }

    public static void main(String[] args) {
	// write your code here
    }


}
