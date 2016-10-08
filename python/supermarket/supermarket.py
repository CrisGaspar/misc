class Product:
    price = 0.0
    id = 0
    name = ""

    def __init__(self, price = 0.0, id = id, name = name):
        self.price = price
        self.id = id
        self.name = name

    def get_price(self):
        return self.price


class Discount:
    discounts = []

    def __init__(self, discounts = []):
        self.discounts = discounts
        self.discounts.sort(reverse = True)
        print self.discounts


    def add(self, count = 0, total_price = 0.0):
        if count == 0:
            return
        self.discounts.append((count,total_price))

p1 = Product(id=5019, name="Can of beans", price = 0.65)
p2 = Product(id=30, name="Bag of socks", price = 9.99)
d1 = [(3,1.0), (5, 1.5), (10, 2.5)]
d3For1 = Discount(discounts = d1)

class Checkout:
    id_to_counts = {}
    id_to_product = { p1.id: p1, p2.id: p2}
    id_to_discounts = { p1.id: d3For1}

    def add(self, id = 0, count = 1):
        cur_count = self.id_to_counts.get(id, 0)
        self.id_to_counts[id] = cur_count + count

    def _calculate_product_price(self, count, product):
        d = self.id_to_discounts.get(product.id, Discount())
        total = 0

        for cnt,discount_price in d.discounts:
            if count >= cnt:
                mult = count // cnt
                total += mult * discount_price
                count -= mult * cnt
            elif count == 0:
                break

        if count > 0:
            total += count * product.get_price()
        return total


    def get_total(self):
        total = 0.0
        for id,count in self.id_to_counts.iteritems():
            p = self.id_to_product[id]
            total += self._calculate_product_price(count = count, product = p)
        return total


if __name__ == "__main":
    p = Product(price = 1.99)
    print p.get_price()