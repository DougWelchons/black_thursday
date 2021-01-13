class Repository
  def inspect
    "#<#{self.class} #{@repo.size} rows>"
  end

  def all
    @repo
  end

  def find_by_id(id)
    @repo.find do |instance|
      instance.id.to_i == id
    end
  end

  def max_by_id
    @repo.max_by do |instance|
      instance.id
    end.id
  end

  def delete(id)
    @repo.delete(find_by_id(id))
  end

  def find_all_by_invoice_id(invoice_id)
    @repo.find_all do |instance|
      instance.invoice_id == invoice_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @repo.find_all do |instance|
      instance.merchant_id.to_i == merchant_id
    end
  end

  def find_by_name(name)
    @repo.find do |instance|
      instance.name.casecmp(name).zero?
    end
  end
end
