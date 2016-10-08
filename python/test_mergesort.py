from unittest import TestCase
from mergesort import *


class TestSortedMerge(TestCase):
    def test_empty_first_list(self):
        l1 = []
        l2 = [-5, -2, 0, 1, 6]
        self.assertEquals(sorted_merge(l1, l2), l2)

    def test_empty_second_list(self):
        l2 = []
        l1 = [-5, -2, 0, 1, 6]
        self.assertEquals(sorted_merge(l1, l2), l1)

    def test_one_element_lists(self):
        l1 = [-5]
        l2 = [-7]
        res = [-7, -5]
        self.assertEquals(sorted_merge(l1, l2), res)

    def test_multi_element_lists(self):
        l1 = [-7, -4, -1, 0, 2 , 5, 7]
        l2 = [-5, -2, 0, 1, 6]
        res = [-7, -5, -4, -2, -1, 0, 0, 1, 2, 5, 6, 7]
        self.assertEquals(sorted_merge(l1, l2), res)

    def test_mergesort(self):
        l = [100, -100, 56, -47, 6, 3, 5, 1]
        res = [-100, -47, 1, 3, 5, 6, 56, 100]
        self.assertEquals(mergesort(l), res)

    def test_mergesort_2(self):
        l = [100, -100]
        res = [-100, 100]
        self.assertEquals(mergesort(l), res)

    def test_mergesort_3(self):
        l = [100, -100, 6]
        res = [-100, 6, 100]
        self.assertEquals(mergesort(l), res)
