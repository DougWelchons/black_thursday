class SalesAnalyst
  include Math
  def initialize(engine)
    @engine = engine
  end

  def items_per_merchant
    @engine.all_merchants.map do |merchant|
      @engine.find_all_items_by_merchant_id(merchant.id).count
    end
  end

  def average_items_per_merchant
    (items_per_merchant.sum / @engine.all_merchants.count.to_f).round(2)
  end

  def merchants_with_high_item_count
    aipmsd = average_items_per_merchant_standard_deviation
    aipm = average_items_per_merchant
    @engine.all_merchants.find_all do |merchant|
      @engine.find_all_items_by_merchant_id(merchant.id).count >
      (aipm + aipmsd)
    end
  end

  def average_item_price_for_merchant(id)
    prices = @engine.find_all_items_by_merchant_id(id).map do |item|
      item.unit_price
    end
    (prices.sum / prices.count).round(2)
  end

  def standard_deviation(average, count, array)
    standard = array.map do |number|
      (number - average) ** 2
    end.sum
    Math.sqrt(standard / (count - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    average = average_items_per_merchant
    count = @engine.all_merchants.count
    ipm = items_per_merchant
    standard_deviation(average, count, ipm)
  end

  def average_average_price_per_merchant
    avg = @engine.all_merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (avg.sum / avg.count).round(2)
  end

  def prices
    @engine.all_items.map do |item|
      item.unit_price
    end
  end

  def average_price
    (prices.sum / prices.count).round(2)
  end

  def average_price_standard_deviation
    average = average_price
    item_count = @engine.all_items.count
    price = prices
    standard_deviation(average, item_count, price)
  end

  def golden_items
    ap = average_price
    apsd = average_price_standard_deviation
    @engine.all_items.find_all do |item|
      item.unit_price > (ap + (apsd * 2))
    end
  end

  def invoices_per_merchant
    @engine.all_merchants.map do |merchant|
      @engine.find_all_invoices_by_merchant_id(merchant.id).count
    end
  end

  def average_invoices_per_merchant
    (invoices_per_merchant.sum / @engine.all_merchants.count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    average = average_invoices_per_merchant
    ipm = invoices_per_merchant
    count = @engine.all_merchants.count
    standard_deviation(average, count, ipm)
  end

  def top_merchants_by_invoice_count
    aipm = average_invoices_per_merchant
    aipmsd = average_invoices_per_merchant_standard_deviation
    @engine.all_merchants.find_all do |merchant|
      @engine.find_all_invoices_by_merchant_id(merchant.id).count > (aipm + (aipmsd * 2))
    end
  end

  def bottom_merchants_by_invoice_count
    aipm = average_invoices_per_merchant
    aipmsd = average_invoices_per_merchant_standard_deviation
    @engine.all_merchants.find_all do |merchant|
      @engine.find_all_invoices_by_merchant_id(merchant.id).count < (aipm - (aipmsd * 2))
    end
  end

  def invoices_per_day
    @engine.all_invoices.group_by do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

  def average_invoices_per_day
    count = invoices_per_day.map do |key, value|
      value.count
    end
    count.sum / 7
  end

  def average_invoices_per_day_standard_deviation
    average = average_invoices_per_day
    ipd_count = invoices_per_day.map do |key, value|
      value.count
    end
    standard_deviation(average, 7, ipd_count)
  end

  def top_days_by_invoice_count_with_invoices
    aipd = average_invoices_per_day
    aipdsd = average_invoices_per_day_standard_deviation
    invoices_per_day.find_all do |key, value|
      value.count > (aipd + aipdsd)
    end
  end

  def top_days_by_invoice_count
    top_days_by_invoice_count_with_invoices.map do |day|
      day[0]
    end
  end

  def invoice_status(status)
    status_count = @engine.all_invoices.find_all do |invoice|
      (invoice.status == status)
    end
    ((status_count.count / @engine.all_invoices.count.to_f) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    transactions = @engine.find_transaction_by_invoice_id(invoice_id)
    transactions.any? do |transaction|
      transaction.result == :success
    end
  end

  def invoices_by_date(date)
    @engine.all_invoices.find_all do |invoice|
      Time.parse(invoice.created_at.strftime('%Y-%m-%d')) == date
    end
  end

  def invoice_total(invoice_id)
    total = 0
    invoice_items = @engine.find_invoice_items_by_invoice_id(invoice_id)
    return nil if invoice_items == []
    invoice_items.each do |invoice_item|
      total += (invoice_item.unit_price * invoice_item.quantity)
    end
    total
  end

  def total_revenue_by_date(date)
    total = 0
    invoices_by_date(date).each do |invoice|
      if invoice_paid_in_full?(invoice.id)
        total += invoice_total(invoice.id)
      end
    end
    total
  end

  def revenue_by_merchant(merchant_id)
    total = 0
    @engine.find_all_invoices_by_merchant_id(merchant_id).each do |invoice|
      if invoice_paid_in_full?(invoice.id)
        total += invoice_total(invoice.id)
      end
    end
    total
  end

  def top_revenue_earners(x = 20)
    sorted_merchant_revenue = @engine.all_merchants.sort_by do |merchant|
      revenue_by_merchant(merchant.id)
    end.reverse
    sorted_merchant_revenue[0..(x - 1)]
  end

  def merchants_with_pending_invoices
    @engine.all_merchants.find_all do |merchant|
      @engine.find_all_invoices_by_merchant_id(merchant.id).any? do |invoice|
        invoice_paid_in_full?(invoice.id) == false
      end
    end
  end

  def merchants_with_only_one_item
    @engine.all_merchants.find_all do |merchant|
      @engine.find_all_items_by_merchant_id(merchant.id).count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month_name)
    merchants_with_only_one_item.find_all do |merchant|
      Time.parse(merchant.created_at).strftime('%B') == month_name
    end
  end

  def items_sold(item_id)
    @engine.find_all_invoice_items_by_item_id(item_id).map do |invoice_item|
      invoice_item.quantity
    end.sum
  end

  def max_items_sold(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    items_by_merchant.max_by do |item|
      items_sold(item.id)
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    items_by_merchant.find_all do |item|
      items_sold(item.id) == items_sold(max_items_sold(merchant_id).id)
    end
  end

  def max_item_revenue(merchant_id)
    items_by_merchant = @engine.find_all_items_by_merchant_id(merchant_id)
    items_by_merchant.max_by do |item|
      item_revenue(item.id)
    end
  end

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
end
