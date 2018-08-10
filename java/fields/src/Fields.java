import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedDeque;
import java.util.concurrent.ConcurrentLinkedQueue;

public class Fields {
    private int[][] gridWithFieldIdx;

    public int[][] getNeighbours(int rowIdx, int colIdx) {
        int// [][] neighbours = new int[][];
       rowIdx, colIdx +1

    }

    // boolean positionFlag = grid[rowIdx][colIdx];

    public int fieldNumber(boolean[][] grid) {
        Queue<int[]> traversalQ = new ConcurrentLinkedQueue<>();

        int numRows = grid.length;
        int numCols = grid[0].length;

        int currentFieldNumber = 0;

        for (int i = 0; i < numRows; ++i) {
            for (int j = 0; i < numCols; ++j) {
                if (grid[i][j]) {
                    // found a patch
                    ++currentFieldNumber;

                    for (int pairCoordinates[]: getNeighbours(i,j)) {
                        traversalQ.add(pairCoordinates);
                    }
                    grid[i][j] = false;

                    while (traversalQ.size() != 0) {
                        int[] pair = traversalQ.poll();
                        grid[pair[0]][pair[1]] = false;
                        for (int neighbourCoordinates[]: getNeighbours(pair[0], pair[1])) {
                            if (grid[neighbourCoordinates[0]][neighbourCoordinates[1]]){
                                traversalQ.add(neighbourCoordinates);
                            }
                        }

                    }
                }

            }
        }

    }
}
