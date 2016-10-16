import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.stream.IntStream;

/**
 * Created by crisoti on 02/05/16.
 */
@SuppressWarnings("Convert2MethodRef")
public class Board {
    public enum Player { NOT_SET, PLAYER_1, PLAYER_2}

    private int dim = 3;
    private Player[][] positions = new Player[dim][dim];
    private static Random generator = new Random();

    private Board() {
        reset();
    }

    private void reset() {
        generator = new Random();
        positions =
                IntStream.range(0, dim)
                .mapToObj(x -> IntStream.range(0, dim)
                                      .mapToObj(y -> Player.NOT_SET)
                                      .toArray(Player[]::new))
                .toArray(Player[][]::new);
    }

    public Board clone() {
        try {
            super.clone();
        }
        catch(Exception e) {
            e.printStackTrace(System.err);
        }
        Board b = new Board();
        b.setBoard(positions);
        return b;
    }

    private void setBoard(Player[][] source) {
        dim = source.length;
        positions = Arrays.stream(source)
                .map(Player[]::clone)
                .toArray( (int length) ->new Player[length][]);
    }

    public int getDim() {
        return dim;
    }

    public Player get(int x, int y) {
        return positions[x][y];
    }

    public void set(int x, int y, Player p) {
        positions[x][y] = p;
    }

    public static Player getNextPlayer(Player p) {
        switch(p) {
            case PLAYER_1:
                return Player.PLAYER_2;
            case PLAYER_2:
                return Player.PLAYER_1;
            default:
                return null;
        }
    }

    private int getNumMoves() {
        int movesMade = 0;
        for (Player[] boardRow: positions) {
            for (Player p: boardRow) {
                if ((p != null) && (p != Player.NOT_SET)) {
                    ++movesMade;
                }
            }
        }
        return movesMade;
    }

    public void print() {
        for(Player[] boardRow: positions) {
            for (Player p: boardRow) {
                char c;
                switch (p) {
                    case PLAYER_1:
                        c = 'X';
                        break;
                    case PLAYER_2:
                        c = 'O';
                        break;
                    case NOT_SET:
                        c = '_';
                        break;
                    default:
                        c = '!';
                        break;
                }
                System.out.print(c + " ");
            }
            System.out.println();
        }
    }

    private Integer getMatchScore(Player winner, Player current) {
        //pre: called if we have a winner`:
        return winner.equals(current) ? 1: -1;
    }

    private Integer horizontalScore(Player currentPlayer) {
        for (int x = 0; x < dim; ++x) {
            // row i
            Player p = positions[x][0];
            if (p != Player.NOT_SET) {
                int y;
                for (y = 1; y < dim; ++y) {
                    if (positions[x][y] != p) {
                        break;
                    }
                }
                if (y == dim) {
                    return getMatchScore(p, currentPlayer);

                }
            }
        }
        return null;
    }

    private Integer verticalScore(Player currentPlayer) {
        for (int y = 0; y < dim; ++y) {
            // row i
            Player p = positions[0][y];
            if (p != Player.NOT_SET) {
                int x;
                for (x = 1; x < dim; ++x) {
                    if (positions[x][y] != p) {
                        break;
                    }
                }
                if (x == dim) {
                    return getMatchScore(p, currentPlayer);
                }
            }
        }
        return null;
    }

    private Integer diagonalScore(Player currentPlayer) {
        Player p = positions[0][0];
        if (p != Player.NOT_SET) {
            int x;
            for (x = 1; x < dim; ++x) {
                // row i
                if (positions[x][x] != p) {
                    break;
                }
            }
            if (x == dim) {
                return getMatchScore(p, currentPlayer);
            }
        }

        p = positions[0][dim-1];
        if (p != Player.NOT_SET) {
            int x;
            for (x = 1; x < dim; ++x) {
                // row i
                if (positions[x][dim-1-x] != p) {
                    break;
                }
            }
            if (x == dim) {
                return getMatchScore(p, currentPlayer);
            }
        }

        return null;
    }

    public Integer computeMatchScore(Player currentPlayer) {
        Integer score;
        score = horizontalScore(currentPlayer);
        if (score == null) {
            score = verticalScore(currentPlayer);
        }
        if (score == null) {
            score = diagonalScore(currentPlayer);
        }

        if ((score == null) && (getNumMoves() == dim * dim)) {
            // draw
            score = 0;
        }
        return score;
    }

    private static int score(final Board b, final Player p) {
        // stopping recursion: either
        // 1. there is a win/loss right now
        Integer score = b.computeMatchScore(p);
        if (score != null) {
            return score;
        }

        int totalScore = 0;
        Player nextPlayer = Board.getNextPlayer(p);
        ArrayList<Board> possibleConfigurations = getPossibleBoards(b, p);

        for (Board possibleConfig: possibleConfigurations) {
            score = possibleConfig.computeMatchScore(p);
            if (score != null) {
                if (score == 1) {
                    return score;
                }
                // draw or loss
                totalScore += score;
                continue;
            }
            totalScore += -score(possibleConfig, nextPlayer);
        }
        return totalScore;
    }

    private static ArrayList<Board> getPossibleBoards(Board board, Player p) {
        int dim = board.getDim();
        // list of all possible board configurations after 1 move
        ArrayList<Board> possibleConfigurations = new ArrayList<>();
        IntStream.range(0, dim * dim).forEach(
                n -> {
                    int x = n / dim;
                    int y = n % dim;
                    Player pCur = board.get(x, y);
                    if (pCur == Player.NOT_SET) {
                        Board nextBoard = board.clone();
                        nextBoard.set(x, y, p);
                        possibleConfigurations.add(nextBoard);
                    }
                }
        );
        return possibleConfigurations;
    }

    public static Board bestMove(final Board board, final Player p) {
        Integer score = board.computeMatchScore(p);
        if (score != null) {
            // no more moves
            return null;
        }

        ArrayList<Board> possibleNextConfigurations = getPossibleBoards(board, p);

        final Player nextPlayer = Board.getNextPlayer(p);
        ArrayList<Board> bestConfigs = new ArrayList<>();
        int maxScore = Integer.MIN_VALUE;

        for (Board b: possibleNextConfigurations) {
            // check if there is a win/loss right now
            Integer curScore = b.computeMatchScore(p);
            if (curScore != null) {
                if (curScore == 1) {
                    return b;
                }

                // final move, can only be a draw
                if (curScore > maxScore) {
                    bestConfigs.clear();
                    bestConfigs.add(b);
                    maxScore = curScore;
                }
                else if (curScore == maxScore) {
                    bestConfigs.add(b);
                }
                continue;
            }

            curScore = -score(b, nextPlayer);
            if (curScore > maxScore) {
                bestConfigs.clear();
                bestConfigs.add(b);
                maxScore = curScore;
            }
            else if (curScore == maxScore) {
                bestConfigs.add(b);
            }
        }
        return bestConfigs.get(generator.nextInt(bestConfigs.size()));
    }

    public static void main(String[] args) {
        Board board = new Board();
        Player[][] b = {
                {Player.PLAYER_1, Player.NOT_SET, Player.PLAYER_2},
                {Player.PLAYER_1, Player.NOT_SET, Player.PLAYER_2},
                {Player.NOT_SET, Player.NOT_SET, Player.NOT_SET}
        };
        board.setBoard(b);
        System.out.println("Initial state:");
        board.print();

        Board bestConfiguration = Board.bestMove(board, Player.PLAYER_2);
        System.out.println("Player 1's best move:");
        if (bestConfiguration != null) {
            bestConfiguration.print();
        }
        else {
            System.err.println("Game over. No more moves");
        }


        board = new Board();
        System.out.println("Auto-play...");
        System.out.println("Initial state:");
        board.print();

        Player player = Player.PLAYER_1;
        bestConfiguration = board;
        Board tmpConfig;

        while(true) {
            tmpConfig = Board.bestMove(bestConfiguration, player);
            if (tmpConfig == null) {
                break;
            }

            bestConfiguration = tmpConfig;

            System.out.println(player + "'s turn. New state: ");
            bestConfiguration.print();

            player = Board.getNextPlayer(player);

        }

        switch (bestConfiguration.computeMatchScore(Player.PLAYER_1)) {
            case 1:
                System.out.println("PLAYER 1 won!");
                break;

            case -1:
                System.out.println("PLAYER 2 won!");
                break;

            case 0:
                System.out.println("It's a draw!");
                break;
        }
    }
}

