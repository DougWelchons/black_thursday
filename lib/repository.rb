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

end
