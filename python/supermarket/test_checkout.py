from unittest import TestCase

from supermarket import Checkout

class TestCheckout(TestCase):
    def test_add(self):
        c = Checkout()
        id1 = 5019
        id2 = 30
        c.add(id1)
        c.add(id1, 11)
        c.add(id2, 2)
        self.assertTrue(c.id_to_counts[id1] == 12)
        self.assertTrue(c.id_to_counts[id2] == 2)


    def test_get_total(self):
        c = Checkout()
        id1 = 5019
        id2 = 30
        c.add(id1)
        c.add(id1, 11)
        c.add(id2, 2)
        total = c.get_total()

        # total for id1 is 2.5 (for 10) + 2 * 0.65 = 3.8
        # total for id2 is 2*9.99 = 19.98
        self.assertEquals(total, 23.78)





