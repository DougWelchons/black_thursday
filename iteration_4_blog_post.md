# Black Thursday Iteration 4
## Iteration 4: Merchant Analytics

Which item sold most in terms of quantity and revenue:

* most_sold_item_for_merchant
`sales_analyst.most_sold_item_for_merchant(merchant_id)`

  - helper method `items_sold(item_id)`

  ```ruby
  def items_sold(item_id)
    @engine.find_all_invoice_items_by_item_id(item_id).map do |invoice_item|
      invoice_item.quantity
    end.sum
  end

  def most_sold_item_for_merchant(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    max_item = items_by_merchant.max_by do |item|
      items_sold(item.id)
    end
    items_by_merchant.find_all do |item|
      items_sold(item.id) == items_sold(max_item.id)
    end
  ```

  The `most_sold_item_for_merchant` method will look into our `engine` class in order to find all the items under each merchant with the merchant ID as as a parameter. This information will be saved to our `items_by_merchant` variable.

  For the next portion, we will call our helper method `items_sold`. This helper method will reach into the `engine` class to find all the invoice items that match the item ID that is provided. Then, for every matching item ID, it will get the quantity of that invoice item. Finally, it will sum all the quantities from every invoice item.

  Back to our `most_sold_item_for_merchant`, we will look into every item under each merchant to get the number of items that were sold per item ID.
  Finally, we will look into every item under each merchant, call our `items_sold`, and return the most sold item for the corresponding merchant ID.

  > We have a merchant, find items by merchant. then, with each item, we go thru each item to see which was sold and how many. then find which one sold the most. then we want to say ok, of all items, these are the ones equal to the ones that sold the most.  - Doug W.


* best_item_for_merchant
`sales_analyst.best_item_for_merchant(merchant_id)`

  - helper method `items_revenue(item_id)`

  ```ruby
    def item_revenue(item_id)
      @engine.find_all_invoice_items_by_item_id(item_id).map do |invoice_item|
        invoice_item.quantity * invoice_item.unit_price
      end.sum
    end

    def best_item_for_merchant(merchant_id)
      items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
      max_item = items_by_merchant.max_by do |item|
        item_revenue(item.id)
      end
      items_by_merchant.find_all do |item|
        item_revenue(item.id) == item_revenue(max_item.id)
      end
    end
  ```
The `best_item_for_merchant(merchant_id)` method will once again create the variable `items_by_merchant` by talking to our `engine` class to find all the items under each merchant_id

Then, we will call on our helper method `item_revenue`. This method will find the total sum of the invoice items' revenue by talking to our `engine` class and finding all the invoice items that match the provided item ID. It will use the invoice items' quantity and multiply it by the unit_price of the invoice item.

The `best_item_for_merchant(merchant_id)` will continue with the information above. It will look for every item under every merchant to get the revenue matching the item's ID. Lastly, we use the information stored in the `items_by_merchant` variable to find all the items' revenue that match the best item for each merchant ID.
