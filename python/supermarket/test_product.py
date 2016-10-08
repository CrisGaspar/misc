from unittest import TestCase

from supermarket import Product


class TestProduct(TestCase):
    def test_get_price(self):
        p = Product()
        self.assertTrue(p.get_price() == 0.0)


