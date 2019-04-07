class NumUtils

  def self.convert_abbr_to_full(value)
    abbr = value[-1]
    case abbr
    when 'k'
      suffix = '000'
    when 'M'
      suffix = '000000'
    end
    value.gsub(abbr, suffix)
  end

  def self.remove_money_symbols(value)
    value.delete '$,'
  end

end
