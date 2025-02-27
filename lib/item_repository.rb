require_relative 'item'
require_relative 'repository'

class ItemRepository < Repository
  attr_reader :items

  def initialize(file_path, engine)
    @engine = engine
    @items  = create_repository(file_path)
    @repo   = @items
  end

  def create_repository(file_path)
    file = CSV.readlines(file_path, headers: true, header_converters: :symbol)
    file.map do |row|
      Item.new(row)
    end
  end

  def find_all_with_description(description)
    @items.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    @items.find_all do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    @items.find_all do |item|
      range.include?(item.unit_price)
    end
  end

  def create(attributes)
    @items.push(Item.new({
                          id: (max_by_id + 1),
                          name: attributes[:name],
                          description: attributes[:description],
                          unit_price: attributes[:unit_price],
                          merchant_id: attributes[:merchant_id],
                          created_at: attributes[:created_at] = Time.now.to_s,
                          updated_at: attributes[:updated_at] = Time.now.to_s
                          }))
  end

  def update_given_attributes(item, attributes)
    attributes.each do |key, value|
      if value == attributes[:name]
        item.name = attributes[key]
      elsif value == attributes[:description]
        item.description = attributes[key]
      elsif value == attributes[:unit_price]
        item.unit_price = attributes[key]
      end
    end
  end

  def update(id, attributes)
    item = find_by_id(id)
    return nil if item.nil?
    update_given_attributes(item, attributes)
    item.updated_at = Time.now
  end
end
