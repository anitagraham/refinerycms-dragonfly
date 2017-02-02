class Hash
  def method_missing(method, *opts)
    m = method.to_s
    if self.has_key?(m.to_sym)
      return self[m.to_sym]
    elsif self.has_key?(m)
      return self[m]
    end
    super
  end
end
