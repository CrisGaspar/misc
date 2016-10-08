/**
 *
 * Created by crisoti on 04/05/16.
 */
import java.util.*;

public class Parentheses {
    private static final HashSet<Character> openParens = new HashSet<Character>(Arrays.asList(
            new Character('('), new Character('{'), new Character('[')));
    private static final HashSet<Character> closeParens = new HashSet<Character>(Arrays.asList(
            new Character(')'), new Character('}'), new Character(']')));

    private static final HashMap<Character, Character> closeToOpenParens = buildCloseToOpenParensMap();

    private static final HashMap<Character, Character> buildCloseToOpenParensMap() {
        HashMap<Character, Character> map = new HashMap<>();
        map.put(new Character(']'), new Character('['));
        map.put(new Character(')'), new Character('('));
        map.put(new Character('}'), new Character('{'));
        return map;
    }

    public static int mismatch(String s) {
        Stack<Character> unmatchedOpenParens = new Stack<Character>();
        int curIdx = 0;
        for (char c: s.toCharArray()) {
            if (openParens.contains(c)) {
                unmatchedOpenParens.push(c);
            }
            else if (closeParens.contains(c)) {
                if (unmatchedOpenParens.empty()) {
                    // found mismatch;
                    return curIdx;
                }
                char lastUnmatched = unmatchedOpenParens.pop();
                Character ch = closeToOpenParens.getOrDefault(c, null);
                if (ch == null || (!ch.equals(lastUnmatched))){
                    // found mismatch
                    return curIdx;
                }
            }
            ++curIdx;
        }
        if (!unmatchedOpenParens.empty()) {
            // more open parens than close ones
            return -1;
        }
        return s.length();
    }

    public static void main(String[] args) {
        HashSet<String> inputs = new HashSet<String>(Arrays.asList(
                "a(b[c(d[f][[g]])h]i)j[",
                "([([()]())]",
                "(()(([][])[[()]]){()])",
                "(()(([][])[[()]]){()})"

        ));

        for (String s : inputs) {
            System.out.println("Checking mismatches in " + s);
            int pos = Parentheses.mismatch(s);
            if (pos == s.length()) {
                System.out.println("No parens mismatch found!");
            } else if (pos == -1) {
                System.out.println("Parens mismatch found: more open parens than closed!");
            } else {
                System.out.println("Parens mismatch " + s.charAt(pos) + " at position " + pos);
            }
        }
    }
}
