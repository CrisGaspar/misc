import unittest
from unittest import TestCase

from rover import Rover, RoverException

class TestRover(TestCase):
    rover_limits = [(0,0), (3,4)]

    def test_check_position(self):
        id = 1
        position = (0, 0, 'N')
        new_position = (-1, 0, 'N')
        rover = Rover(position, id, self.rover_limits)

        with self.assertRaises(RoverException):
            rover.check_position(new_position)

        position1 = (3, 4, 'N')
        position2 = (3, 3, 'N')
        rover1 = Rover(position1, id, self.rover_limits)
        rover2 = Rover(position2, id+1, self.rover_limits)
        rover2.other_rovers = [rover1]

        with self.assertRaises(RoverException):
            rover2.check_position(position1)

    def test_advance(self):
        id = 1
        position = (0, 0, 'N')
        expected_new_position = (0, 1, 'N')
        rover = Rover(position, id, self.rover_limits)
        rover.other_rovers = []
        rover.advance()
        self.assertEqual(rover.position, expected_new_position)

        position1 = (0, 0, 'N')
        expected_new_position = position2 = (0, 1, 'S')
        rover1 = Rover(position1, id, self.rover_limits)
        rover2 = Rover(position2, id+1, self.rover_limits)
        rover2.other_rovers = [rover1]
        with self.assertRaises(RoverException):
            rover2.advance()
        self.assertEqual(rover2.position, expected_new_position)

    def test_turn(self):
        id = 1
        position = (2, 1, 'N')
        expected_new_position = (2, 1, 'S')
        rover = Rover(position, id, self.rover_limits)
        rover.turn('L')
        rover.turn('L')
        self.assertEqual(rover.position, expected_new_position)

        position = (2, 1, 'N')
        expected_new_position = (2, 1, 'S')
        rover = Rover(position, id, self.rover_limits)
        rover.turn('R')
        rover.turn('R')
        self.assertEqual(rover.position, expected_new_position)

        position = (2, 1, 'N')
        expected_new_position = (2, 1, 'W')
        rover = Rover(position, id, self.rover_limits)
        rover.turn('R')
        rover.turn('R')
        rover.turn('R')
        self.assertEqual(rover.position, expected_new_position)

        position = (2, 1, 'N')
        rover = Rover(position, id, self.rover_limits)
        rover.turn('L')
        rover.turn('L')
        rover.turn('L')
        rover.turn('L')
        self.assertEqual(rover.position, position)

    def test_execute(self):
        id = 1
        position = (1, 1, 'E')
        commands = "LLMRMRM"
        new_position = (1, 2, 'E')
        rover = Rover(position, id, self.rover_limits)
        rover.execute(commands, [])
        self.assertEqual(rover.position, new_position)

        position1 = (1, 1, 'E')
        commands1 = "LLMRMRM"
        new_position1 = (1, 2, 'E')
        rover1 = Rover(position1, id, self.rover_limits)
        rover1.execute(commands,[])
        self.assertEqual(rover1.position, new_position1)

        position2 = (2, 2, 'E')
        commands2 = "RRM"
        new_position2 = (2, 2, 'W')
        rover2 = Rover(position2, id+1, self.rover_limits)
        with self.assertRaises(RoverException):
            rover2.execute(commands2, [rover1])
        self.assertEqual(rover2.position, new_position2)

        rover3 = Rover(position2, id+2, self.rover_limits)
        commands3 = "M"
        with self.assertRaises(RoverException):
            rover3.execute(commands3, [rover1, rover2])
        self.assertEqual(rover3.position, position2)


if __name__ == '__main__':
    unittest.main()
