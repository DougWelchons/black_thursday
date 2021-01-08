requinvoice_repoe 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_repository'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  def setup
        @engine = SalesEngine.from_csv({
          :items     => "./data/items.csv",
          :merchants => "./data/merchants.csv",
          :invoices => "./data/invoices.csv", self
          })
      analyst = SalesAnalyst.new(engine)

      @invoice_repo = InvoiceRepository.new("./data/invoices.csv")
  end

  def test_class_exists
    assert_instance_of InvoiceRepository, @invoice_repo
  end

  def test_all
    skip
    assert_equal 4985, @invoice_repo.all.count
  end

  def test_finds_all_by_id
    skip
    assert_equal 1, @invoice_repo.find_by_id(1)
  end

  def test_finds_all_by_customer_id
    skip
    assert_equal 1, @invoice_repo.find_by_id(1).customer_id
  end


  def test_find_by__merchant_id
    assert_equal 12335938, @invoice_repo.find_by_id(1).merchant_id
  end

  def test_find_all_by_merchant_id
    assert_equal (number), @invoice_repo.find_all_by_merchant_id(12335938).count #length
  end

  def find_all_by_status
    assert_equal (number), @invoice_repo.find_all_by_status("pending").length
  end
end
