// Let's just use C++11
#include <array>
#include <algorithm>
#include <cassert>


using namespace std;

int triples(const string& s) {
    int triplesCount = 0;
    char runChar = '\0';
    int runLength = 0;
    for_each(s.begin(), s.end(), [&triplesCount, &runLength, &runChar](char ch) {
       if (ch == '\0') {
           // first char
           runLength = 1;
           runChar = ch;
           return;
       }

       if (ch == runChar) {
           runLength++;
       }
       else {
           if (runLength >= 3) {
                triplesCount += (runLength - 2);
           }
           runChar = ch;
           runLength = 1;
       }
    });
    return triplesCount;
}


int main(int argc, char* argv[]) {
   string s = "xxxabyyyycd";
   assert(triples(s) == 3);
}
