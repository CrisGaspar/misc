import java.util.HashMap;

public class Anagrams {

    public boolean areAnagrams(String word1, String word2) {
        HashMap<Character, Integer> letterCount1 = letterFrequencyHelper(word1);
        HashMap<Character, Integer> letterCount2 = letterFrequencyHelper(word2);

        for(HashMap.Entry<Character, Integer> entry : letterCount1.entrySet()) {
            int currentLetterCount1 = entry.getValue();
            int currentLetterCount2 = letterCount2.getOrDefault(entry.getKey(), 0);

            if (currentLetterCount1 != currentLetterCount2) {
                return false;
            }
        }

        for(HashMap.Entry<Character, Integer> entry : letterCount2.entrySet()) {
            int currentLetterCount2 = entry.getValue();
            int currentLetterCount1 = letterCount1.getOrDefault(entry.getKey(), 0);

            if (currentLetterCount1 != currentLetterCount2) {
                return false;
            }
        }

        return true;
    }

    private HashMap<Character, Integer> letterFrequencyHelper(String word) {
        HashMap<Character, Integer> letterCount = new HashMap<>();

        word.codePoints().map(ch -> {
           int currentCount = letterCount.getOrDefault(ch, 0);
           ++currentCount;

           letterCount.put(Character.valueOf((char) ch), currentCount);
           return ch;
        });

        return letterCount;
    }



}
