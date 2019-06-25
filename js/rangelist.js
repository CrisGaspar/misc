// Task: Implement a class named 'RangeList'
// A pair of integers define a range, for example: [1, 5). This range includes integers: 1, 2, 3, and 4.
// A range list is an aggregate of these ranges: [1, 5), [10, 11), [100, 201)

//import _ from "lodash";
// Using require as a workaround to run in Visual Studio Code where import does not work. Dev environment only

const _ = require("lodash");

const EXPECTED_RANGE_PARAMETER_COUNT = 2;
const ADD_OPERATION = "add";
const REMOVE_OPERATION = "remove";
const PRINT_OPERATION = "print";

const TEST_DATA =
  "add:1,5$\
print:[1, 5)$\
add:10,20$\
print:[1, 5) [10, 20)$\
add:20,20$\
print:[1, 5) [10, 20)$\
add:20,21$\
print:[1, 5) [10, 21)$\
add:2,4$\
print:[1, 5) [10, 21)$\
add:3,8$\
print:[1, 8) [10, 21)$\
remove:10,10$\
print:[1, 8) [10, 21)$\
remove:10,11$\
print:[1, 8) [11, 21)$\
remove:15,17$\
print:[1, 8) [11, 15) [17, 21)$\
remove:3,19$\
print:[1, 3) [19, 21)$\\";
 
class RangeList {
  constructor() {
    // ranges will contain a list of all the ranges' start and inclusive end values
    // e.g: for ranges [2,3), [5,10) this.ranges is [2, 2, 5, 10]
    this.ranges = [];
  }
 
  /**
   * Adds a range to the list
   * @param {Array<number>} range - Array of two integers that specify beginning and end of range.
   */
  add(range) {
    this.addRemoveHelper(range, true);
  }
 
  /**
   * Removes a range from the list
   * @param {Array<number>} range - Array of two integers that specify beginning and end of range.
   */
  remove(range) {
    this.addRemoveHelper(range, false);
  }
 
  /**
   * Prints out the list of ranges in the range list
   */
  print() {
    var arrayLength = this.ranges.length;
    var result = "";
    for (var i = 0; i < arrayLength; i += 2) {
      var startVal = this.ranges[i];
      var inclusiveEndVal = this.ranges[i + 1];
      // Use +2 to get the range to include the 1st element after the range
      var currentInterval = "[" + startVal + ", " + (inclusiveEndVal + 1) + ")";
      result = result.concat(currentInterval + " ");
    }
    console.log(this.toString());
  }
 
  toString() {
    var arrayLength = this.ranges.length;
    var result = "";
    for (var i = 0; i < arrayLength; i += 2) {
      var startVal = this.ranges[i];
      var inclusiveEndVal = this.ranges[i + 1];
      // Use +2 to get the range to include the 1st element after the range
      var currentInterval = "[" + startVal + ", " + (inclusiveEndVal + 1) + ")";
      if (i > 0) {
        result = result.concat(" ");
      }
      result = result.concat(currentInterval);
    }
    return result;
  }
 
  /*
   ** Based on the range and operation type (add or remove) decides which portion to slice and if needed insert new elements
   **/
  addRemoveHelper(range, isAdd) {
    if (!Array.isArray(range)) {
      console.error("range parameter is not an array! range: ", range);
      return;
    }
 
    if (range.length < EXPECTED_RANGE_PARAMETER_COUNT) {
      console.error(
        "range does not contain at least ",
        EXPECTED_RANGE_PARAMETER_COUNT,
        " elements"
      );
      return;
    }
 
    var startVal = range[0];
    var endVal = range[1];
 
    if (!Number.isInteger(startVal)) {
      console.error("start value ", startVal, " is not an integer!");
      return;
    }
 
    if (!Number.isInteger(endVal)) {
      console.error("end value ", endVal, " is not an integer!");
      return;
    }
 
    if (startVal >= endVal) {
      console.warn(
        "end value: ",
        endVal,
        " has to be greater than start value: ",
        startVal
      );
      return;
    }
 
    var inclusiveEndVal = endVal - 1;
    var spliceParams = this.findSpliceParams(startVal, inclusiveEndVal, isAdd);
    var spliceInsertValues = spliceParams[2];
 
    // replace sublist with the new range
    this.ranges.splice(spliceParams[0], spliceParams[1], ...spliceInsertValues);
  }
 
  /**
   * Determines the slice start, count, and which elements to add (if any)
   * @param {} startVal - beginning of range to add/remove
   * @param {*} inclusiveEndVal - inclusive end of range to add/remove
   * @param {*} isAdd - boolean to indicate it's an add or remove operation
   */
  findSpliceParams(startVal, inclusiveEndVal, isAdd) {
    var spliceItemsToAdd = [];
 
    var start = this.ranges.findIndex(val => val >= startVal);
    var end = this.ranges.findIndex(val => val > inclusiveEndVal);
 
    if (start === -1) {
      // all values smaller than start value
      start = this.ranges.length;
      if (isAdd) {
        if (startVal === this.ranges[start - 1] + 1) {
          // need to merge these 2 consecutive intervals, include previous range end in splice removal range
          start = start - 1;
        } else {
          // nothing to merge
          spliceItemsToAdd.push(startVal);
        }
      }
    } else if (start % 2 === 1) {
      // odd index so end of a range
      if (isAdd) {
        // extend to beginning of this range
        start = start - 1;
        spliceItemsToAdd.push(this.ranges[start]);
      } else {
        // remove operation inside a range: shrink that range by inserting the new range end
        spliceItemsToAdd.push(startVal - 1);
      }
    } else if (isAdd) {
      // even index so begining of range
      if (startVal === this.ranges[start - 1] + 1) {
        // need to merge these 2 consecutive intervals, include previous range end in splice removal range
        start = start - 1;
      } else {
        spliceItemsToAdd.push(startVal);
      }
    }
 
    if (end === -1) {
      // all values smaller then inclusiveEndVal
      if (start === this.ranges.length) {
        // they're also smaller than start values, no ranges to replace
        // since end is inclusive, set to start - 1 so that count is 0
        end = start - 1;
        if (isAdd) {
          spliceItemsToAdd.push(inclusiveEndVal);
        }
      } else {
        // the end of the ranges to replace is last element (end of last range)
        end = this.ranges.length - 1;
        if (isAdd) {
          spliceItemsToAdd.push(inclusiveEndVal);
        } else {
          // remove: insert new range start
          spliceItemsToAdd.push(inclusiveEndVal + 1);
        }
      }
    } else if (end % 2 === 1) {
      // odd index so it's the end of a range. the end of the splice is the begining of this range
      end = end - 1;
      if (!isAdd) {
        // remove: insert new range start
        spliceItemsToAdd.push(inclusiveEndVal + 1);
      }
    } else {
      // even index so inclusiveEndVal comes before new range
      // choose previous subrange end
      end = end - 1;
      if (isAdd) {
        if (this.ranges[end + 1] === inclusiveEndVal + 1) {
          // the 2 consecutive intervals are to be merged, extend removal to start of next interval
          end = end + 1;
        } else {
          spliceItemsToAdd.push(inclusiveEndVal);
        }
      }
    }
 
    var spliceCount = end - start + 1;
    var spliceParams = [start, spliceCount, spliceItemsToAdd];
    return spliceParams;
  }
 
  test(filename) {
    const rl = new RangeList();
    var success = true;
 
    TEST_DATA.split("$").forEach(line => {
      var lineParts = line.split(":");
      var operation = lineParts[0];
      var value = lineParts[1];
      var range = [];
 
      if (operation === ADD_OPERATION) {
        range = this.parseRange(value);
        rl.add(range);
      } else if (operation === REMOVE_OPERATION) {
        range = this.parseRange(value);
        rl.remove(range);
      } else if (operation === PRINT_OPERATION) {
        var stringRepresentation = rl.toString();
        if (stringRepresentation !== value) {
          success = false;
          console.error(
            "TEST failure: Expected: ",
            value,
            " Actual: ",
            stringRepresentation
          );
        }
      }
    });
 
    if (success) {
      console.log("TESTS: All tests PASSED...");
    } else {
      console.log("TESTS: Some tests FAILED... See previous console loglines");
    }
 
    return success;
  }
 
  parseRange(value) {
    var rangeValues = value.split(",");
    var startVal = parseInt(rangeValues[0], 10);
    var endVal = parseInt(rangeValues[1], 10);
    return [startVal, endVal];
  }
}
 
const rangeList = new RangeList();
rangeList.test();
 
/*
// Example run
const rl = new RangeList();
 
rl.add([1, 5]);
rl.print();
// Should display: [1, 5)
 
rl.add([10, 20]);
rl.print();
// Should display: [1, 5) [10, 20)
 
rl.add([20, 20]);
rl.print();
// Should display: [1, 5) [10, 20)
 
rl.add([20, 21]);
rl.print();
// Should display: [1, 5) [10, 21)
 
rl.add([2, 4]);
rl.print();
// Should display: [1, 5) [10, 21)
 
rl.add([3, 8]);
rl.print();
// Should display: [1, 8) [10, 21)
 
rl.remove([10, 10]);
rl.print();
// Should display: [1, 8) [10, 21)
 
rl.remove([10, 11]);
rl.print();
// Should display: [1, 8) [11, 21)

rl.remove([15, 17]);
rl.print();
// Should display: [1, 8) [11, 15) [17, 21)

rl.remove([3, 19]);
rl.print();
// Should display: [1, 3) [19, 21)
*/

