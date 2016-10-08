import java.text.NumberFormat;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import com.google.common.util.concurrent.AtomicDouble;

/**
 * Created by crisoti on 20/05/16.
 */
public class Checkout {
    private class Discount {
        private Long productID;
        private Integer quantity;
        private Double totalCost;  // cost of buying 'quantity' items of this product

        Discount(Long id, Integer count, Double cost) {
            productID = id;
            quantity = count;
            totalCost = cost;
        }

        public Double getTotalCost() { return totalCost;}
        public Integer getQuantity() { return quantity;}
    }

    public class Product {
        private Long id;
        private Double price;

        Product(Long productID, Double productPrice) {
            id = productID;
            price = productPrice;
        }

        public Double getPrice() { return price; }
        public Long getID() { return id; }
    }

    private final List<Long> sampleProductIDs = Arrays.asList(100000L, 100001L, 100002L);
    private final HashMap<Long, ArrayList<Discount>> discountsByProductID = createDiscountsByProductID();
    private final HashMap<Long, Product> productsByID = createProductsByID();

    private Product createProduct(Long id) {
        if (id == 100000L) {
            return new Product(id, 3.99);
        }

        if (id == 100001L) {
            return new Product(id, 1.99);
        }

        throw new NoSuchElementException("Create discount failed: unsupported product ID" +  id);
    }

    private HashMap<Long, Product>  createProductsByID() {
        HashMap<Long, Product> map = new HashMap<>();
        long productID = 100000L;
        map.put(productID, createProduct(productID));

        productID = 100001L;
        map.put(productID, createProduct(productID));
        return map;
    }

    private HashMap<Long, ArrayList<Discount>>  createDiscountsByProductID() {
        HashMap<Long, ArrayList<Discount>> map = new HashMap<>();
        long productID = 100000L;
        map.put(productID, createDiscounts(productID));

        productID = 100001L;
        map.put(productID, createDiscounts(productID));
        return map;
    }


    private ArrayList<Discount> createDiscounts(Long productID) {
        ArrayList<Discount> discountsForID = new ArrayList<>();
        if (productID == 100000L) {
            discountsForID.add(new Discount(productID, 5, 14.99));
            discountsForID.add(new Discount(productID, 3, 9.99));
            discountsForID.add(new Discount(productID, 10, 24.99));
        }
        else if (productID == 100001L) {
            discountsForID.add(new Discount(productID, 10, 0.99));
        }
        else {
            throw new NoSuchElementException("Create discount failed: unsupported product ID" + productID);
        }
        discountsForID.sort((Discount d1, Discount d2) -> d2.getQuantity() - d1.getQuantity());
        return discountsForID;
    }

    public double getCost(Long productID, Integer quantity) {
        Product product = productsByID.get(productID);
        if (product == null) {
            System.err.println("Cannot get cost of order: product ID " + productID + " not found!");
            return 0;
        }

        double regularPrice = product.getPrice();
        final AtomicInteger remainingQuantity = new AtomicInteger(quantity);
        final AtomicDouble cost = new AtomicDouble(0);

        ArrayList<Discount> discountsForProduct = discountsByProductID.getOrDefault(productID, new ArrayList<>());
        discountsForProduct.forEach(discount -> {
            while (remainingQuantity.intValue() >= discount.getQuantity()) {
                cost.addAndGet(discount.getTotalCost());
                remainingQuantity.set(remainingQuantity.intValue() - discount.getQuantity());
            }
        });

        cost.addAndGet(remainingQuantity.intValue() * regularPrice);
        return cost.doubleValue();
    }

    public static void main(String[] args) {
        Checkout checkout = new Checkout();
        NumberFormat formatter = NumberFormat.getCurrencyInstance();
        long productID = 100000L;
        int quantity = 30;
        System.out.println("Checkout: ProductID: " + productID + " quantity: " + quantity + " Cost: " + formatter.format(checkout.getCost(productID, quantity)));

        quantity = 29;
        System.out.println("Checkout: ProductID: " + productID + " quantity: " + quantity + " Cost: " + formatter.format(checkout.getCost(productID, quantity)));
    }
}
