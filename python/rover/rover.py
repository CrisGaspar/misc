import os
import sys

from os.path import isfile, join


class RoverException(Exception):
    def __init__(self, msg):
        self.msg = msg
    def __str__(self):
        return "Unexpected: " + self.msg

class Rover:
    """ Single rover representation"""

    left_turn = {
        'N': 'W',
        'W': 'S',
        'S': 'E',
        'E': 'N'
    }
    right_turn = {
        'N': 'E',
        'E': 'S',
        'S': 'W',
        'W': 'N'
    }
    advance_delta = {
        'N': (0, 1),
        'E': (1, 0),
        'S': (0, -1),
        'W': (-1, 0)
    }
    turn_commands = ['L', 'R']
    commands = turn_commands + ['M']

    # index in position tuple that indicates current direction
    direction_index = 2

    def __init__(self, current_position, rover_id, rover_limits):
        self.position = current_position
        self.id = rover_id
        self.limits = rover_limits

    def check_position(self, new_position):
        (lowerLeft, upper_right) = self.limits

        if (new_position[0] < lowerLeft[0] or new_position[1] < lowerLeft[0] or
            new_position[0] > upper_right[0] or new_position[1] > upper_right[1]):
            raise RoverException("Rover {} new position {} will be out of the allowed exploration area"
                                 .format(self.id, new_position))

        for other_rover in self.other_rovers:
            other_position = other_rover.position
            if other_position[0] == new_position[0] and other_position[1] == new_position[1]:
                raise RoverException("Rover {} new position {} is the same one as position of rover {}"
                                     .format(self.id, new_position, other_rover.id))

    def advance(self):
        direction = self.position[self.direction_index]
        delta = self.advance_delta[direction]
        x = self.position[0] + delta[0]
        y = self.position[1] + delta[1]
        new_position = (x, y, direction)
        self.check_position(new_position)
        self.position = new_position

    def turn(self, where):
        if where == 'L':
            new_direction = self.left_turn[self.position[self.direction_index]]
            self.position = (self.position[0], self.position[1], new_direction)
        else:
            new_direction = self.right_turn[self.position[self.direction_index]]
            self.position = (self.position[0], self.position[1], new_direction)

    def execute(self, commands, rovers):
        self.other_rovers = rovers
        # check current position is not occupied
        self.check_position(self.position)
        for cmd in commands:
            if cmd in self.turn_commands:
                self.turn(cmd)
            elif cmd in commands:
                self.advance()
            else:
                raise RoverException("Rover {}: unknown rover command: {}!".format(self.id, cmd))

class RoverExploration:
    """ Used to deploy rovers one by one on a rectangular grid

        Lower right corner is (0,0)
        Upper right corner given by caller.

        In real NASA conditions extensive error checking would be used instead and exceptions would be handled
        as close as possible to the code that raises them.
    """

    def __init__(self, filename):
        # limits tuple is (lower_left_coordinates_tuple, upper_right_coordinates_tuple)
        self.limits = [(0,0), (0,0)]
        self.rovers = []

        # Rover data: for each rover a tuple (T1,T2) where T1=(x,y,dir) is a position tuple and T2 is the commands string
        self.rovers_input_data = []
        self.load_rover_data(filename)

    def run(self):
        """ Deploy each rover to its given start position and execute its navigation commands."""
        success = True
        for index, data in enumerate(self.rovers_input_data):
            (position, commands) = data
            try:
                rover = Rover(position, index+1, self.limits)
                rover.execute(commands, self.rovers)
            except RoverException as e:
                # we leave rovers in the last valid position
                print(e)
                success = False
            self.rovers.append(rover)
        return success

    def _position_line_to_tuple(self, line):
        position = [s.rstrip() for s in line.split(' ')]
        position[0] = int(position[0])
        position[1] = int(position[1])
        return tuple(position)

    def load_rover_data(self, filename):
        with open(filename, 'r') as f:
            lines = f.readlines()
            self.limits[1] = self._position_line_to_tuple(lines[0])

            if len(lines) % 2 != 1:
                raise RoverException("Incorrect input: rover data input file has even number of lines")

            rovers_count = (len(lines) - 1) // 2
            for i in range(0, rovers_count):
                position_tuple = self._position_line_to_tuple(lines[2*i+1])
                commands = lines[2*i+2].rstrip()
                self.rovers_input_data.append((position_tuple, commands))

    def get_expected_final_positions(self, filename):
        positions =  []
        with open(filename, 'r') as f:
            for line in f.readlines():
                positions.append(self._position_line_to_tuple(line))
        return positions


def run_test(filename_pair, test_num):
    (input_filename, expected_results_filename) = filename_pair
    exploration = RoverExploration(input_filename)
    test_header = "TEST {}: ".format(test_num)
    print(test_header + "Running Rover Explorer using rover data from {}".format(input_filename))
    print(test_header + "Relaying rover commands to Mars. Please wait...")

    try:
        success = exploration.run()
        expected_positions = exploration.get_expected_final_positions(expected_results_filename)
        msg = ""
        for rover in exploration.rovers:
            expected_position = expected_positions[rover.id-1]
            if rover.position != expected_position:
                msg += "Rover {} final position {} differs from its expected position {}\n" \
                    .format(rover.id, rover.position, expected_position)

        if len(msg) == 0:
            if success:
                msg = test_header + "Successfully deployed and executed all rover commands! Open the champagne."
                print(msg)
            # As long the final positions match the expected position, we consider this a pass.
            # The rover is smart enough that any move that cause errors/exceptions will not be performed
            success = True
        else:
            success = False
            print(msg)
    except RoverException as e:
        success = False
        print(e)
    finally:
        return success

if __name__ == "__main__":
    args = sys.argv[1:]
    input_filename = "rover_functional_test_4_input.txt"
    expected_results_filename = "rover_functional_test_4_expected.txt"
    all_tests = False

    if len(args) == 1:
        if args[0] == "ALL":
            all_tests = True
        else:
            input_filename = args[0]
    elif len(args) >= 2:
        input_filename = args[0]
        expected_results_filename = args[1]

    files = []
    if all_tests:
        input_files = [f for f in os.listdir() if isfile(f) and f.endswith("input.txt")]
        for input_file in input_files:
            expected_results_file = input_file.rstrip("input.txt") + "expected.txt"
            files.append((input_file, expected_results_file))
    else:
        files.append((input_filename, expected_results_filename))

    passed = 0
    failed = 0
    files = sorted(files)
    for index,file_pair in enumerate(files):
        if run_test(file_pair, index+1):
            passed +=1
        else:
            failed +=1

    print("***** SUMMARY: Ran {} tests. PASS: {} FAIL: {}".format(len(files), passed, failed))
