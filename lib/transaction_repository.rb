require_relative 'transaction'
require_relative 'repository'

class TransactionRepository < Repository
  attr_reader :transactions

  def initialize(file_path, engine)
    @engine       = engine
    @transactions = create_repository(file_path)
    @repo         = @transactions
  end

  def create_repository(file_path)
    file = CSV.readlines(file_path, headers: true, header_converters: :symbol)
    file.map do |row|
      Transaction.new(row)
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number.to_s
    end
  end

  def find_all_by_result(result)
    @transactions.find_all do |transaction|
      transaction.result == result
    end
  end

  def create(attributes)
    @transactions.push(Transaction.new({
                          id: (max_by_id + 1),
                          invoice_id: attributes[:invoice_id],
                          credit_card_number: attributes[:credit_card_number],
                          credit_card_expiration_date: attributes[:credit_card_expiration_date],
                          result: attributes[:result],
                          created_at: Time.now.to_s,
                          updated_at: Time.now.to_s
                          }))
  end

  def update_given_attributes(transaction, attributes)
    attributes.each do |key, value|
      if value == attributes[:credit_card_number]
        transaction.credit_card_number = attributes[key]
      elsif value == attributes[:credit_card_expiration_date]
        transaction.credit_card_expiration_date = attributes[key]
      elsif value == attributes[:result]
        transaction.result = attributes[key]
      end
    end
  end

  def update(id, attributes)
    transaction = find_by_id(id)
    return nil if transaction.nil?
    update_given_attributes(transaction, attributes)
    transaction.updated_at = Time.now
  end
end
