#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <map>

using namespace std;

// Use 1byte enum for direction
enum class Direction : uint8_t {
    NORTH = 'N',
    WEST = 'W',
    SOUTH = 'S',
    EAST = 'E'
};

bool isValid(const Direction& d) {
    switch(d) {
        case Direction::NORTH:
        case Direction::WEST:
        case Direction::SOUTH:
        case Direction::EAST:
            return true;
        default:
            return false;
    }
}

map<char, Direction> charToDirections = {  
    {'N', Direction::NORTH},
    {'W', Direction::WEST},
    {'S', Direction::SOUTH},
    {'E', Direction::EAST}
};

map<Direction, string> directionToStr = {  
    {Direction::NORTH, "NORTH"},
    {Direction::WEST,  "WEST"},
    {Direction::SOUTH, "SOUTH"},
    {Direction::EAST,  "EAST"}
};

map<Direction, Direction> leftTurn = {  
    {Direction::NORTH, Direction::WEST},
    {Direction::WEST,  Direction::SOUTH},
    {Direction::SOUTH, Direction::EAST},
    {Direction::EAST,  Direction::NORTH}
};

map<Direction, Direction> rightTurn = {  
    {Direction::NORTH, Direction::EAST},
    {Direction::WEST,  Direction::NORTH},
    {Direction::SOUTH, Direction::WEST},
    {Direction::EAST,  Direction::SOUTH}
};


class RoverException : public exception {
private:
    string desc;
public:
    RoverException(const string& description): desc(description) {}
    const char * what() const throw() {
        return desc.c_str();
    }
};

class Location {
private:
    long x, y;
    Direction d;

public:
    friend ostream& operator<<(ostream& out, const Location& l);
    friend class Rover; 

    Location() : Location(0, 0, Direction::NORTH) {}
    Location(long px, long py, Direction dir) : x(px), y(py), d(dir) {}

    bool operator==(const Location &rhs) {
        return x == rhs.x && y == rhs.y && d == rhs.d;
    }

    void set(long px, long py, const Direction& dir) {
        x = px;
        y = py;
        d = dir;
    }
};


class Rover {
private:
    Location l;                     ///< current location
    vector<Location> history;

public:
    friend ostream& operator<<(ostream& out, const Rover& r);

    // default destructor
    Rover(): l() {} 
    Rover(const Location& loc) : l(loc) {}

    Location location() const { return l; }

    // For unit testing!
    void setLocation(const Location& newLoc) { l = newLoc; }

    // Execute a single command
    void exec(char c) {
        switch(c) {
            case 'f':
              advance();
              break;

            case 'l':
            case 'r':
              turn(c);
              break;

            default:
              throw RoverException(string("Unsupported rover command: ") + (char)(c));
        }
    }

    // Execute a series of commands one-by-one
    void exec(const string& s) {
        for (const auto& c: s) {
            exec(c);
        }    
    }


private:
    void advance() {
        switch(l.d) {
            case Direction::NORTH:
                l.y += 1;
                break;
            case Direction::SOUTH:
                l.y -= 1;
                break;
            case Direction::WEST:
                l.x -= 1;
                break;
            case Direction::EAST:
                l.x += 1;
                break;
            default:
                throw RoverException(string("Invalid rover direction: ") + (char)(l.d));
        }
    }

    void turn(char c) {
        switch(c) {
            case 'l':
              l.d = leftTurn[l.d];
              break;
            case 'r':
              l.d = rightTurn[l.d];
              break;
            default:
              throw RoverException(string("Unsupported rover turn command: ") + (char)(c));
        }
    }
};

// read all data from file
// run tests
struct RoverTestData {
    Location initial;
    Location expected;      ///< expected final location
    string cmds;

    RoverTestData(const Location& initialLoc, const Location& expectedLoc, const string& commands) :
        initial(initialLoc), expected(expectedLoc), cmds(commands) {}

};

class RoverTests {
private:
    ifstream stream;
    string filename;
    vector<RoverTestData> testData;

public:
    RoverTests(const string& fname) : stream(fname), filename(fname), testData() {} 
    bool run();

private:
   bool load();
};

// Overloads of stream output operator to print our objects
ostream& operator<<(ostream& os, const Location& l) {
    os << "(" << l.x << "," << l.y << ") facing " << directionToStr[l.d];
    return os;
}

ostream& operator<<(ostream& os, const Rover& r) {
    os << "Rover position " << r.location();
    return os;
}

ostream& operator<<(ostream& os, const RoverTestData& data) {
    os << "Initial: " << data.initial << " | Commands: " << data.cmds << " | Expected: " << data.expected;
    return os;
}


// NOTE: istream does not support using the extract operator>> on enums by default.
// Addded template specialization so that it works for our Direction enum
istream& operator>>(istream& istream, Direction& d) {
    char c;
    istream >> c;
    d = charToDirections[c]; 
    return istream;
} 

