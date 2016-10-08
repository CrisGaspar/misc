#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

vector<int> filter(const vector<int>& v) {
    auto t = v;
    sort(t.begin(), t.end());

    const int THRESHOLD = 100;
    vector<int> t2;

    auto f = [](const int& i) { return i > THRESHOLD; };
    copy_if(t.begin(), t.end(), back_inserter(t2), f);

    return t2;
}

int main(int argc, char** argv) {
    vector<int> v = { 101, 0, -100, 203, 50, 99, 100 };

    auto res = filter(v);
    for_each(res.begin(), res.end(), [](const int&i) { cout << i << " "; });
   
    cout << endl; 
    return 0;
}
