require 'time'
require_relative 'merchant'
require_relative 'repository'

class MerchantRepository < Repository
  attr_reader :merchants

  def initialize(file_path, engine)
    @engine = engine
    @merchants = create_repository(file_path)
    @repo = @merchants
  end

  def create_repository(file_path)
    file = CSV.readlines(file_path, headers: true, header_converters: :symbol)
    file.map do |row|
      Merchant.new(row)
    end
  end

  def find_all_by_name(name)
    @merchants.find_all do |merchant|
      merchant.name.downcase.include?(name.downcase)
    end
  end

  def create(attributes)
    @merchants.push(Merchant.new({
                                  id: max_by_id + 1,
                                  name: attributes[:name],
                                  created_at: Time.now, #lookinto sriptime
                                  updated_at: Time.now
                                  }))
  end

  def update(id, attribute)
    return nil if find_by_id(id).nil?
    find_by_id(id).name = attribute[:name]
    find_by_id(id).updated_at = Time.now.round
  end
end
