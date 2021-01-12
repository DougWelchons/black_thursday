require_relative 'invoice_item'
require_relative 'repository'

class InvoiceItemRepository < Repository
  attr_reader :invoice_items

  def initialize(file_path, engine)
    @invoice_items = create_repository(file_path)
    @engine = engine
    @repo = @invoice_items
  end

  def create_repository(file_path)
    file = CSV.readlines(file_path, headers: true, header_converters: :symbol)
    file.map do |row|
      InvoiceItem.new(row)
    end
  end

  def find_all_by_item_id(item_id)
    @invoice_items.find_all do |ii|
      ii.item_id.to_i == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.find_all do |ii|
      ii.invoice_id.to_i == invoice_id
    end
  end

  def max_by_id
    @invoice_items.max_by do |ii|
      ii.id
    end.id
  end

  def create(attributes)
    @invoice_items.push(InvoiceItem.new({
                                          id:         max_by_id + 1,
                                          item_id:    attributes[:item_id],
                                          invoice_id: attributes[:invoice_id],
                                          quantity:   attributes[:quantity],
                                          unit_price: attributes[:unit_price],
                                          created_at: Time.now.to_s,
                                          updated_at: Time.now.to_s
                                        }))
  end

  def update(id, attributes)
    invoice_item = find_by_id(id)
    return nil if invoice_item.nil?
    attributes.each do |key, value|
      if value == attributes[:quantity]
        invoice_item.quantity = attributes[key]
      elsif value == attributes[:unit_price]
        invoice_item.unit_price = attributes[key]
      end
    end
      invoice_item.updated_at = Time.now
  end

end
