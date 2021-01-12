# Black Thursday Iteration 4
## Iteration 4: Merchant Analytics
### most_sold_item_for_merchant
- `sales_analyst.most_sold_item_for_merchant(merchant_id)`

In order to find the item that was sold the most for a given merchant, we need to evaluate the invoice items for each of the merchants' items to determine the quantity sold. With this information, we can easily determine the merchant's most sold item. The steps to achieve that result may look like this:

  ```ruby
  def most_sold_item_for_merchant(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    items_by_merchant.find_all do |item|
      items_sold(item.id) == items_sold(max_items_sold(merchant_id).id)
    end
  end

  def items_sold(item_id)
    @engine.find_all_invoice_items_by_item_id(item_id).map do |invoice_item|
      invoice_item.quantity
    end.sum
  end

  def max_items_sold(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    max_item = items_by_merchant.max_by do |item|
      items_sold(item.id)
    end
  end

  ```
To find the `most_sold_item_for_merchant` we will need to query our `engine` class and find all the items for a given merchant. Then we will save that information to our variable named `items_by_merchant`. Before we can move on, we need to find the number of each item sold. The helper method `items_sold` will take a specific item ID and query through the` engine` for all the invoice items related to the given item ID and sum the quantities sold accordingly. Moving forward, we will also have to find our item that has sold more than any other. We can achieve this with our `max_item_sold` helper method, which will evaluate a given set of items (provided by our `most_sold_items_for_merchant` method) and return the item which has been sold the most for our given merchant. Since multiple items could have potentially sold the most, we will then need to find all of the items for our given merchant that have sold an equal amount to our `max_item_sold`. That is achieved by iterating over all the items for the given merchant and finding all of the items sold that are equal to our maximum items sold in terms of quantity.


  - Helper methods
   1. `items_sold(item_id)`
   2. `max_items_sold(merchant_id)`

### best_item_for_merchant
  - `sales_analyst.best_item_for_merchant(merchant_id)`

In order to find the best item for a given merchant, we will be following mostly the same steps as in our previous method. For this one, however, we will be focusing on the item's revenue for the given merchant, as opposed to just the quantity of units sold.

  ```ruby
  def best_item_for_merchant(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    items_by_merchant.find_all do |item|
      item_revenue(item.id) == item_revenue(max_item_revenue(merchant_id).id)
    end
  end

  def item_revenue(item_id)
    @engine.find_all_invoice_items_by_item_id(item_id).map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end.sum
  end

  def max_item_revenue(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    max_item = items_by_merchant.max_by do |item|
      item_revenue(item.id)
    end
  end

  ```

  - Helper methods
   1. `items_sold(item_id)`
   2. `max_items_sold(merchant_id)`

To find the `best_item_for_merchant` we will need to, once again, query our `engine` class to find all the items for a given merchant. As before, we will save that information to our `items_by_merchant` variable. Before we can continue with this method, we need to find the total revenue from each item sold. The helper method `item_revenue` will provide us with a sum of each item's revenue. The helper method will iterate over all of our invoice items to find the item's `quantity` and `unit_price`. Then, it will multiply both numbers to calculate the revenue. Next, we will need to find which item has produced the most revenue; that can be achieved by using our second helper method, `max_item_revenue`. The second helper method iterates over all the items for the given merchant and finds the maximum revenue produced by an item belonging to the merchant we are searching for. Last, we then head back to our `best_item_for_merchant` method and once again iterate over all of the items for our given merchant and find all of the items whose revenue is equal to the maximum item revenue calculated in `max_item_revenue`. This will then return us an array of the one or more items that have earned the most revenue for a given merchant.
