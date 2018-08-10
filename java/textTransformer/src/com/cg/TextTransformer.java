package com.cg;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/******
 * NOTES:
 * 1. In a production environment for efficiency I would split text file into smaller files of size <= 10 MBs and then kick off
 *    Spark processing jobs in Spark cluster locally or on AWS for maximum parallelism.
 * 2. Since this is not a paid exercise, I did not include unit tests.
 *****/
public class TextTransformer {
    private Path transformationsFilePath;
    private Path textFilePath;

    private List<String> transformationSequence;
    private Map<Character, Character> tranformationMappings = new HashMap<>();

    private static final char[] initialState = {
            '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
            'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
            'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
            'z', 'x', 'c', 'v', 'b', 'n', 'm', ',' ,'.', '/'};

    private static final int TRANSFORMATION_ROW_NUM = 4;
    private static final int TRANSFORMATION_COL_NUM = 10;
    private static final int NUM_TRANSFORMATION_CHARS = initialState.length;

    public TextTransformer(String transformationsFile, String textFile) {
        transformationsFilePath = Paths.get(transformationsFile);
        textFilePath = Paths.get(textFile);

        loadTransformationSequence();
        computeTransformationMappings();
    }

    private void loadTransformationSequence() {
        try {
            // read transformation sequence from file and remove whitespace
            String transformationSeq = Files.lines(transformationsFilePath).findFirst().orElse("").replaceAll("\\s+","");

            transformationSequence = simplifyTransformation(transformationSeq);
        }
        catch(IOException ex) {
            System.err.println("ERROR: " + ex.toString());
            return;
        }
    }

    private void computeTransformationMappings() {
        char[] finalState = getFinalState();

        // store the final mappings
        IntStream.range(0, finalState.length).forEach( idx -> tranformationMappings.put(initialState[idx], finalState[idx]));
    }


    private static List<String> simplifyTransformation(String transformationSeq) {
        List<String> transformations = Arrays.asList(transformationSeq.split(","));

        int numHorizontal = 0;
        int numVertical = 0;
        int numShift = 0;

        List<String> simplifiedTransformations = new ArrayList<>();

        for (String transformation: transformations) {
            switch (transformation) {
                case "H":
                    if (numShift != 0) {
                        // previous run of shifts. write both previous run of H/V and run of shifts

                        // The run of "H" and/or "V", order doesn't matter and each 2 Vs or 2Hs cancel each other
                        if (numHorizontal % 2 == 1) {
                            simplifiedTransformations.add("H");
                        }
                        if (numVertical % 2 == 1) {
                            simplifiedTransformations.add("V");
                        }
                        // reset H and V count
                        numHorizontal = 1;
                        numVertical = 0;

                        // add shift transformation
                        simplifiedTransformations.add(String.valueOf(numShift % NUM_TRANSFORMATION_CHARS));
                    }
                    else {
                        ++numHorizontal;
                    }

                    // reset shift count
                    numShift = 0;
                    break;

                case "V":
                    if (numShift != 0) {
                        // previous run of shifts. write both previous run of H/V and run of shifts

                        // The run of "H" and/or "V", order doesn't matter and each 2 Vs or 2Hs cancel each other
                        if (numHorizontal % 2 == 1) {
                            simplifiedTransformations.add("H");
                        }
                        if (numVertical % 2 == 1) {
                            simplifiedTransformations.add("V");
                        }
                        // reset H and V count
                        numHorizontal = 0;
                        numVertical = 1;

                        // add shift transformation
                        simplifiedTransformations.add(String.valueOf(numShift % NUM_TRANSFORMATION_CHARS));
                    }
                    else {
                        ++numVertical;
                    }

                    // reset shift count
                    numShift = 0;
                    break;

                default:
                    // Should be a shift step. Consecutive shift steps can be added together
                    numShift += Integer.parseInt(transformation);
                    break;
            }
        }

        // Last subsequence of transformations
        if (numHorizontal % 2 == 1) {
            simplifiedTransformations.add("H");
        }
        if (numVertical % 2 == 1) {
            simplifiedTransformations.add("V");
        }
        if (numShift != 0) {
            // previous run of shifts
            simplifiedTransformations.add(String.valueOf(numShift % NUM_TRANSFORMATION_CHARS));
        }

        return simplifiedTransformations;
    }

    private static void swap(char[] source, int lowerIndex, int higherIndex) {
        char aux = source[lowerIndex];
        source[lowerIndex] = source[higherIndex];
        source[higherIndex] = aux;
    }

    // For efficiency transformations overwrite the source with final result
    private static void verticalFlipColumn (char[] source, int colNum) {
        // swap each element of the row with its right end counterpart, stop in the middle (same as reverse row but in place)
        IntStream.range(0, TRANSFORMATION_ROW_NUM/2).forEach(rowNum -> {
            int lowerIndex = rowNum * TRANSFORMATION_COL_NUM + colNum;
            int higherIndex = (TRANSFORMATION_ROW_NUM-rowNum-1) * TRANSFORMATION_COL_NUM + colNum;
            swap(source, lowerIndex, higherIndex);
        });
    }

    private static void verticalFlip(char[] source) {
        IntStream.range(0, TRANSFORMATION_COL_NUM).forEach(i -> verticalFlipColumn(source, i));
    }

    private static void horizontalFlipRow(char[] source, int rowNum) {
        // swap each element of the row with its right end counterpart, stop in the middle (same as reverse row but in place)
        IntStream.range(0, TRANSFORMATION_COL_NUM/2).forEach(colNum -> {
            int lowerIndex = rowNum * TRANSFORMATION_COL_NUM + colNum;
            int higherIndex = (rowNum+1) * TRANSFORMATION_COL_NUM - 1 - colNum;
            swap(source, lowerIndex, higherIndex);
        });
    }

    private static void horizontalFlip(char[] source) {
        IntStream.range(0, TRANSFORMATION_ROW_NUM).forEach(i -> horizontalFlipRow(source, i));
    }

    private static void shift(char[] source, int n) {
        if (n == 0) {
            // no shift
            return;
        }
        // copy state
        int stateSize =  source.length;
        char[] newState = new char[stateSize];
        System.arraycopy(source, 0, newState, 0, stateSize);

        IntStream.range(0, NUM_TRANSFORMATION_CHARS).forEach(index -> {
            // Note need to add NUM_TRANSFORMATION_CHARS below to handle the case when (index - n) is negative and
            // needs to wrap back to end of the transformation array
            newState[index] = source[(index - n + NUM_TRANSFORMATION_CHARS) % NUM_TRANSFORMATION_CHARS];
        });

        // overwrite source
        System.arraycopy(newState, 0, source, 0, stateSize);
    }


    private char[] getFinalState() {
        // copy initial state
        char[] currentState = new char[initialState.length];
        System.arraycopy(initialState, 0, currentState, 0, initialState.length);

        for(String transformation: transformationSequence) {
            switch(transformation) {
                case "H":
                    horizontalFlip(currentState);
                    break;
                case "V":
                    verticalFlip(currentState);
                    break;
                default:
                    int n = Integer.parseInt(transformation);
                    shift(currentState, n);
                    break;
            }

        }
        return currentState;
    }

    private String transformLine(String line) {
        String result =  line.codePoints().mapToObj(ch -> {
            Character character = (char)ch;
            String tmp = String.valueOf(tranformationMappings.getOrDefault(character, (char) ch));
            return tmp;
        }).collect(Collectors.joining());
        return result;
    }

    private void transform() {
        try {
            Files.lines(textFilePath)
                    .map(line -> transformLine(line))
                    .forEachOrdered(System.out::println);
        }
        catch (IOException ex) {
            System.err.println("ERROR: " + ex.toString());
        }
    }

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("ERROR: Correct usage: TextTransformer <transformation_filename> <text_filename>");
            return;
        }

        TextTransformer transformer = new TextTransformer(args[0], args[1]);
        transformer.transform();
    }
}
