# require_relative 'invoice'
require_relative 'sales_engine'
require 'csv'

class InvoiceRepository
  attr_reader :invoices,
              :sales_engine

  def initialize(engine, file)
    @invoices = []
    @engine = engine
    load_invoices(file)
  end

  def inspect
    "#<#{self.class} #{invoices.size} rows>"
  end

  # def load_invoices(file)
  #   invoice_csv = CSV.open file, headers: true, header_converters: :symbol
  #   invoice_csv.each do |row|
  # => @invoices << Invoice.new(row, self)
  #   end
  # end

  def all
    @invoices
  end

  def find_by_id(id)
    @invoices.find do |invoice|
      invoice.id.to_i == id
  end

  def find_all_by_customer_id(customer_id)
    @invoices.find_all do |invoice|
      invoice.customer_id.to_i == customer_id
  end

  def find_all_by_merchant_id(merchant_id)
    @invoices.find_all do |invoice|
      invoice.merchant_id.to_i == merchant_id
  end

  def find_all_by_status(status)
    @invoices.find_all do |invoice|
      invoice.status == status
  end

  def create(hash, object)
    hash = {}
    @invoice.last.id + 1
      hash[:id] = new_id
      @invoice << object.new(hash)
  end

  def create_stuff(hash, object_class)
    new_id = @invoice.last.id + 1
    hash[:id] = new_id
    @invoice << object_class.new(hash)
  end

  def delete(id)
    @invoice.delete(find_by_id(id))
  end
end
