class TicTacToe:
    dim = 0
    board = []
    size = 0
    max_size = 0
    symbols = ['X', 'O']

    def __init__(self, dim):
        self._initialize(dim)

    def _initialize(self, dim):
        self.dim = dim
        self.max_size = self.dim * self.dim
        self.board = [' ' for i in range(self.max_size)]
        self.size = 0

    def reset_game(self, dim):
        self._initialize(dim)

    def get_char(self, index):
        return self.board[index]

    def set_char(self, index, ch):
        if ch not in self.symbols:
            raise ValueError("Character {} not an accepted symbol".format(ch))

        if index < 0 or index >= self.max_size:
            raise ValueError("Index not within bounds")

        board_char = self.board[index]
        if board_char == ' ':
            self.board[index] = ch
        else:
            raise ValueError("Already have a move at this location")

        # success
        self.size += 1

    def set(self, xpos, ypos, player):
        if xpos > self.dim or ypos > self.dim or xpos < 1 or ypos < 1:
            raise ValueError("Invalid location ({},{}): size of board is {}x{}".format(xpos, ypos, self.dim, self.dim))

        # convert to 0-based indices
        index = (xpos-1) * self.dim + (ypos-1)
        if 0 <= player <= 1:
            self.set_char(index, self.symbols[player])
        else:
            raise ValueError('Invalid player: number of players is 2')

    def next_player(cur_player):
        return (cur_player+1) % 2

    def game_finished(self):
        score = None

        dim = self.dim
        # check horizontally
        for i in range(dim):
            ch = self.board[i*dim]
            if ch != ' ' and self.board[i*dim:(i+1)*dim] == [ch for j in range(dim)]:
                score = 1 if ch == self.symbols[0] else -1

        # check vertically
        for j in range(dim):
            ch = self.board[j]
            if ch != ' ':
                foundWinner = True
                for i in range(j, self.max_size, dim):
                    if self.board[i] != ch:
                        foundWinner = False
                        break
                if foundWinner:
                    score = 1 if ch == self.symbols[0] else -1

        # check diagonally
        ch = self.board[0]
        if ch != ' ':
            foundWinner = True
            for index in range(0, self.max_size, dim+1):
                if self.board[index] != ch:
                   foundWinner = False
                   break
            if foundWinner:
                score = 1 if ch == self.symbols[0] else -1

        start_pos = dim-1
        ch = self.board[start_pos]
        if ch != ' ':
            foundWinner = True
            for index in range(start_pos, self.max_size-1, dim-1):
                if self.board[index] != ch:
                    foundWinner = False
                    break
            if foundWinner:
                score = 1 if ch == self.symbols[0] else -1

        if score is None and self.size == self.max_size:
            # no win and board is full, it's a tie
            score = 0

        return score

    def print_board(self):
        print("Board:")
        print("  1 2 3")
        for i in range(self.dim):
            print("{} {}".format(i+1, ' '.join(self.board[i*self.dim:(i+1)*self.dim])))


    def move(self, player):
        while(True):
            try:
                pos = str(input("Player {} turn. Move format: x,y Enter move: ".format(player+1)))
                posList = pos.split(',')
                if posList[0].upper() == 'Q':
                    return False
                self.set(int(posList[0]), int(posList[1]), player)
                return True
            except Exception as e:
                print(e)


    def run(self):
        print("Starting new game...Type Q to quit...")
        player = 0
        while(True):
            self.print_board()
            score = self.game_finished()
            if (score is not None):
                if score == 1:
                    print("RESULT: Player 1 won!")
                elif score == -1:
                    print("RESULT: Player 2 won!")
                elif score == 0:
                    print("RESULT: It's a tie!")
                return
            else:
                if self.move(player) is not True:
                    # quit
                    return
                player = TicTacToe.next_player(player)

if __name__ == "__main__":
    game = TicTacToe(3)
    game.run()
