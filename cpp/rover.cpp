#include "rover.h"

// Test data format:
// 1st line is the number of tests
// 1 test per line, space separated:
// e.g.:
// -2 5 W "rrrlllfllfll" -2 5 W
// Initial location: (-2,5) facing WEST. Commands: 3 right-turns, 3 left-turns, forward, 2 left-turns, forward, 2 left-turns.
// Expected final location: same as intial location

bool RoverTests::load() {
    bool first = true;
    long testCount = 1;
    long curTestNum = 1;

    try {
        cout << "Loading rover tests from " << filename << " ..." << endl;
        if (!stream.is_open()) {
            cerr << "FAILED: Could not open file! Ensure file exists and has read permissions set" << endl;
            return false;
        }

        while (!stream.eof() && (curTestNum <= testCount) ) {
            if (first) {
                first = false;
                stream >> testCount;
            }
            else {
                long x, y, eX, eY;
                Direction initialDir, expectedDir;
                string cmds;            
                Location initial, expected;

                stream >> x >> y >> initialDir >> cmds >> eX >> eY >> expectedDir;
                if (cmds.size() < 2) { 
                    cout << "Loaded rover tests: FAILED loading test #" << curTestNum << endl;
                    return false;
                }
                // trim the "" quotes
                cmds = cmds.substr(1, cmds.size() - 2);
                initial.set(x, y, initialDir);
                expected.set(eX, eY, expectedDir);
               
                testData.emplace_back(initial, expected, cmds);
                curTestNum++;
            }
        }
        cout << "Loaded rover tests: OK" << endl;
        return true;
    }
    catch (exception& e) {
        cout << "Loaded rover tests: FAILED loading test #" << curTestNum << endl;
        cout << e.what() << endl;
        return false;
    }
}

bool RoverTests::run() {
    if (!load()) {
        // failed to load
        return false;
    }

    long passed, failed, testnum;
    passed = failed = 0;
    testnum = 1;

    cout << "Running tests..." << endl;
    for_each(testData.begin(), testData.end(), [&passed, &failed, &testnum](const RoverTestData& data) {
        bool testPassed = false;
        Rover r;

        try {
            cout << "Test #" << testnum << ": " << data << endl;
            r.setLocation(data.initial);
            r.exec(data.cmds);
            // NOTE: do not use assert as it call abort and cannot be caught by a catch block!
            testPassed = (r.location() == data.expected);
            
        }
        catch (RoverException &e){
            // thrown by a Rover method
            testPassed = false;
            cout << e.what() << endl;
        }
        if (testPassed) {
            passed++;
            cout << "Test #" << testnum << " PASSED!" << endl;
        }
        else {
            failed++;
            cout << "Test #" << testnum << " FAILED! GOT: " << r.location() << " | EXPECTED: " << data.expected << endl;
        }
        testnum++;
    });

    cout << "TEST SUMMARY: PASSED: " << passed << " FAILED: " << failed << " TOTAL: " << testData.size() << "!" << endl; 
    return (failed == 0);
}

void runInteractive() {
    Rover r;
    cout << r.location() << endl;
    char c;

    while (!cin.eof()) {
        cin >> c;
        r.exec(c);
        cout << r.location() << endl;
    }
}

int main(int argc, char** argv) {
    const string usage = "Usage: rover2 <-t filename> | Use -t filename to run in test mode on the given file. Use no parameters to run interactive mode"; 
    bool interactive = true;
    string filename = "";
    switch (argc) {
        case 3:
            if (string(argv[1]) != "-t") {
                cerr << usage << endl;
                return -1;
            }
            filename = argv[2];
            interactive = false;
            break;

        case 1:
            break;

        default:
            cerr << usage << endl;
            return -1;
    } 

    if (interactive) {
        runInteractive();
        return 0;
    }
    else {
        RoverTests tests(filename);
        return tests.run() ? 0: -1;
    }
}
