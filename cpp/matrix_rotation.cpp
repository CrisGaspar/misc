#include <iostream>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <algorithm>
using namespace std;

long getColsNumAndParseFirstRow(vector<long> &v) {
    long cols = 0;
    long MAX_SIZE = 1000000; // 21 should be enough for 64bit int (- for negatives)
    char line[MAX_SIZE];

    // Get 1st row ints. Use space as delimeter
    cin.getline(line, MAX_SIZE);
    istringstream ostr(line);

    long val;

    while (!ostr.eof()) {
        ostr >> val;        
        v.push_back(val);
        ++cols;
    }

    return cols;
}

void readMatrix(long rows, long cols, vector<long> &v) {
    long val;

    for (long i = 0; i < rows; ++i) {
        for (long j = 0; j < cols; ++j) {
            cin >> val;
            v.push_back(val);
        }
    }
}

enum Direction {
    EAST = 0,
    SOUTH,
    WEST,
    NORTH,
    DIRECTIONS_COUNT
};

// irows and icols are intial matrix number of rows and columns
void rotate(long originIdx, long rows, long cols, long irows, long icols, vector<long> &v) {
    if (rows != cols) {
        // not a square matrix
        return;
    }

    if (rows < 2) {
        // nothing to do
        return;
    }


    // rotate along the 4 sides of the square
    long idx = originIdx;
    long stopIdx = originIdx;
    int dir = Direction::EAST;
    long offset = 1;
    long newVal = v[originIdx];
    long tmp;

    for (dir = Direction::EAST; dir < Direction::DIRECTIONS_COUNT; ++dir, idx = stopIdx) {
        switch (dir) {
            case Direction::EAST:
                offset = 1;
                stopIdx += cols - 1; 
                break;
            case Direction::WEST:
                offset = -1;
                stopIdx -= cols - 1;
                break;
            case Direction::SOUTH:
                offset = icols;
                stopIdx += (rows-1) * icols;
                break;
            case Direction::NORTH:
                offset = -icols;
                stopIdx -= (rows-1) * icols;
                break;
        }
        
        for (long i = idx; i != stopIdx; i += offset) {
            tmp = v[i]; 
            v[i] = newVal;
            newVal = tmp;
        }
    }  
    
    // now overwrite initial index val with the last one
    v[originIdx] = newVal;


    rotate(originIdx + icols +1, rows-2, cols-2, rows, cols, v);
} 

int main() {

    try {
        long rows = 0;
        cin >> rows;

        if (rows < 1) {
            cout << "Invalid number of rows!" << endl;
            return -2;
        }

        // skip the newline after row number
        char newline;
        cin.get(newline);

        vector<long> v;
        auto cols = getColsNumAndParseFirstRow(v); 

        // read all other rows
        readMatrix(rows - 1, cols, v);

        if (rows != cols) {
            // not a square matrix
            cerr << "Not a square matrix. Number of rows: " << rows << " is not equal to number of columns: " << cols << endl;
            return -3;
        }

        rotate(0, rows, cols, rows, cols, v);
        for(long i = 0; i < rows; ++i) { 
            for (long j = 0; j < cols; ++j) {
                cout << v[i * cols + j] << " ";
            }
            cout << endl;
        }
    }
    catch (exception& e)
    {
        cerr << e.what() << endl;
        return -1;
    }
    
    return 0;
}
