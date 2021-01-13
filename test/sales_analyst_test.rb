require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_analyst'
require './lib/sales_engine'
require 'pry'

class SalesAnalystTest < Minitest::Test
  def setup
    @csv_data = {
                  :items         => './data/items.csv',
                  :merchants     => './data/merchants.csv',
                  :invoices      => './data/invoices.csv',
                  :customers     => './data/customers.csv',
                  :transactions  => './data/transactions.csv',
                  :invoice_items => './data/invoice_items.csv'
                }
  end

  def test_it_exists_and_has_attributes
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of SalesAnalyst, analyst
  end

  def test_it_can_find_all
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of Array, analyst.items_per_merchant
    assert_equal 475, analyst.items_per_merchant.count
  end

  def test_it_can_give_average_items_per_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 2.88, analyst.average_items_per_merchant
  end

  def test_we_can_find_average_items_per_merchant_standard_deviation
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 3.26, analyst.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of Array, analyst.merchants_with_high_item_count
    assert_equal 52, analyst.merchants_with_high_item_count.count
  end

  def test_average_item_price_for_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of BigDecimal, analyst.average_item_price_for_merchant(12334159)
    assert_equal 0.315e2, analyst.average_item_price_for_merchant(12334159)
  end

  def test_it_can_find_average_average_price_per_merchants
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of BigDecimal, analyst.average_average_price_per_merchant
    assert_equal 0.35029e3, analyst.average_average_price_per_merchant
  end

  def test_golden_items
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of Array, analyst.golden_items
    assert_equal 5, analyst.golden_items.count
  end

  def test_average_price
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_instance_of BigDecimal, analyst.average_price
    assert_equal 0.25106e3, analyst.average_price
  end

  def test_average_price_standard_deviation
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 0.290099e4, analyst.average_price_standard_deviation
  end

  def test_invoices_per_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 475, analyst.invoices_per_merchant.count
  end

  def test_average_invoices_per_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 10.49, analyst.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 3.29, analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 12, analyst.top_merchants_by_invoice_count.count
  end

  def test_bottom_merchants_by_invoice_count
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 4, analyst.bottom_merchants_by_invoice_count.count
  end

  def test_top_days_by_invoice_count
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal ['Wednesday'], analyst.top_days_by_invoice_count
  end

  def test_invoice_status
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 29.55, analyst.invoice_status(:pending)
    assert_equal 56.95, analyst.invoice_status(:shipped)
    assert_equal 13.5, analyst.invoice_status(:returned)
  end

  def test_it_can_return_invoices_per_day
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    days_of_the_week = [
                        'Saturday',
                        'Friday',
                        'Wednesday',
                        'Monday',
                        'Sunday',
                        'Tuesday',
                        'Thursday'
                       ]

    assert_instance_of Hash, analyst.invoices_per_day
    assert_equal days_of_the_week, analyst.invoices_per_day.keys
  end

  def test_it_can_return_average_invoices_per_day
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 712, analyst.average_invoices_per_day
  end

  def test_it_can_return_average_invoices_per_day_standard_deviation
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 18.06, analyst.average_invoices_per_day_standard_deviation
  end

  def test_invoice_paid_in_full_with_invoice_id_arg
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal true, analyst.invoice_paid_in_full?(1)
    assert_equal false, analyst.invoice_paid_in_full?(3)
  end

  def test_invoice_total_with_invoice_id_arg
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_nil analyst.invoice_total(100000000000)
    assert_equal 0.528913e4, analyst.invoice_total(2)
    assert_instance_of BigDecimal, analyst.invoice_total(2)
  end

  def test_item_invoices_by_date
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 1, analyst.invoices_by_date(Time.parse('2009-02-07')).count
  end

  def test_total_revenue_by_date
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 0.2106777e5, analyst.total_revenue_by_date(Time.parse('2009-02-07'))
  end

  def test_it_can_find_total_revenue_by_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 73777.17, analyst.revenue_by_merchant(12334105)
  end

  def test_top_revenue_earners
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 10, analyst.top_revenue_earners(10).count
    assert_equal 20, analyst.top_revenue_earners.count
  end

  def test_merchants_with_pending_invoices
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)


    assert_instance_of Array, analyst.merchants_with_pending_invoices
    assert_equal 467, analyst.merchants_with_pending_invoices.count
  end

  def test_merchants_with_only_one_item
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 243, analyst.merchants_with_only_one_item.count
  end

  def test_it_can_find_merchants_with_only_one_item_registered_in_month
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 19, analyst.merchants_with_only_one_item_registered_in_month("January").count
  end

  def test_max_items_sold
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)
    expected = engine.items.find_by_id(263400329)

    assert_equal expected, analyst.max_items_sold(12334145)
  end

  def test_it_can_find_items_sold
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 97, analyst.items_sold(263542298)
  end

  def test_max_item_revenue
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)
    expected = engine.items.find_by_id(263401045)

    assert_equal expected, analyst.max_item_revenue(12334145)
  end

  def test_it_can_find_most_sold_item_for_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    expected = [engine.items.find_by_id(263400329)]

    assert_equal expected, analyst.most_sold_item_for_merchant(12334145)
  end

  def test_it_can_find_item_revenue
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 0.5216849e5, analyst.item_revenue(263395237)
  end

  def test_it_can_find_best_item_for_merchant
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    expected = [engine.items.find_by_id(263401045)]

    assert_equal expected, analyst.best_item_for_merchant(12334145)
  end

  def test_invoice_item_revenue
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 0.1315873e5, analyst.invoice_item_revenue(engine.invoice_items.find_by_id(10))
  end

  def test_invoice_item_revenue_for_customer
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    assert_equal 0.1754386e5, analyst.invoice_item_revenue_for_customer(engine.customers.find_by_id(15))
  end

  def test_customer_top_buyers
    engine = SalesEngine.from_csv(@csv_data)
    # analyst = SalesAnalyst.new(engine)

    expected = [
                engine.customers.find_by_id(595),
                engine.customers.find_by_id(370)
                ]

    assert_equal 2, analyst.top_buyers(2).count
    assert_equal expected, analyst.top_buyers(2)
    assert_equal 20, analyst.top_buyers.count
  end

  def test_top_merchant_for_customer
    engine = SalesEngine.from_csv(@csv_data)
    analyst = SalesAnalyst.new(engine)

    # require "pry"; binding.pry

    assert_equal 0, analyst.top_merchant_for_customer(1)
  end
end
