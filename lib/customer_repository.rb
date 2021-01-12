require_relative 'customer'
require_relative 'repository'

class CustomerRepository < Repository
  attr_reader :customers

  def initialize(file_path, engine)
    @engine = engine
    @customers = create_repository(file_path)
    @repo = @customers
  end

  def create_repository(file_path)
    file = CSV.readlines(file_path, headers: true, header_converters: :symbol)
    file.map do |row|
      Customer.new(row)
    end
  end

  def find_all_by_first_name(name)
    @customers.find_all do |customer|
      customer.first_name.downcase.include?(name.downcase)
    end
  end

  def find_all_by_last_name(name)
    @customers.find_all do |customer|
      customer.last_name.downcase.include?(name.downcase)
    end
  end

  def create(attributes)
    @customers.push(Customer.new({
                                    :id         => max_by_id + 1,
                                    :first_name => attributes[:first_name],
                                    :last_name  => attributes[:last_name],
                                    :created_at => Time.now,
                                    :updated_at => Time.now,
                                  }))
  end

  def update(id, attributes)
    customer = find_by_id(id)
    return nil if customer.nil?
    attributes.each do |key, value|
      if value == attributes[:first_name]
        customer.first_name = attributes[key]
      elsif value == attributes[:last_name]
        customer.last_name = attributes[key]
      end
    end
    customer.updated_at = Time.now
  end
end
