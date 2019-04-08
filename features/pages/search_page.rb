class SearchPage < SitePrism::Page

  def change_baths_value(action, steps)
    action = (action == 'increase') ? 'up' : 'down'
    elem_button = find("#filterContent > div > div:nth-child(1) > div.doubleRow > div:nth-child(2) > div.filterRow > span > span > span.step-#{action}")

    steps.times do
      elem_button.click
    end
    page_loaded?
  end

  def get_all_homes_data
    elems_home_stats = all('div.HomeStatsV2')
    elems_home_prices = all('span.homecardV2Price')
    home_prices = elems_home_prices.map(&:text)
    home_stats = elems_home_stats.map(&:text)
    home_prices.zip(home_stats).map { |a| a.join(' ') }
  end

  def page_loaded?
    page.should has_selector?('Filter')
  end

  def remove_all_filters_from_url
    current_url.split('/filter')[0]
  end

  def remove_filter_from_url(type)
    raw_filters = current_url.split('/filter/')[1]
    filters = raw_filters.split(',')
    filters.reject!{ |filter| filter =~ /#{type}/ }
    new_filters = (filters.count == 1) ? filters[0] : filters.join(',')
    remove_all_filters_from_url + '/filter/' + new_filters
  end

  def results_valid_in_file?(type, comparison, expected_value)
    latest_csv_path = Dir.glob("#{Dir.home}/Downloads/redfin*").max_by {|f| File.mtime(f)}
    homes_table = CSV.read(latest_csv_path, headers: true)
    if type.include?('Price')
      type = 'Price'
      expected_value = NumUtils.convert_abbr_to_full(expected_value)
      expected_value = NumUtils.remove_money_symbols(expected_value).to_i
    end

    type_data = homes_table[type.upcase]
    type_data.each do |value|
      next if value.nil? # Redfin includes results when there's no data of that type
      return false if comparison == 'greater' && expected_value.to_f > value.to_f
      return false if comparison == 'less' && expected_value.to_f < value.to_f
    end
    true
  end

  def results_valid_on_screen?(type, comparison, expected_value)
    homes_data = get_all_homes_data
    if type.include?('Price')
      expected_value = NumUtils.convert_abbr_to_full(expected_value)
      expected_value = NumUtils.remove_money_symbols(expected_value).to_i
    end

    homes_data.each do |stats|
      if type.include?('Price')
        value = stats[/(\S*)/]
        value = NumUtils.remove_money_symbols(value).to_i
      else
        value = stats[/(\d*\.?\d*) #{type}/,1]
      end
      next if value.nil? # Redfin includes results when there's no data of that type
      return false if comparison == 'greater' && expected_value.to_f > value.to_f
      return false if comparison == 'less' && expected_value.to_f < value.to_f
    end
    true
  end

  def set_baths(target_baths)
    elem_baths_value = find('#filterContent > div > div:nth-child(1) > div.doubleRow > div:nth-child(2) > div.filterRow > span > span > span.input > span > span')
    target_baths = target_baths.chop.to_i # Remove + sign
    current_baths_value = (elem_baths_value.text == 'No min') ? 0 : elem_baths_value.text.chop

    if current_baths_value < target_baths
      steps = (target_baths - current_baths_value).to_i
      steps+=1 if current_baths_value <= 1.25 && target_baths > 1 # Have to add a step between 1 and 2 baths for 1.25 baths
      change_baths_value('increase', steps)
    elsif current_baths_value > target_baths
      steps = (current_baths_value - target_baths).to_i
      steps+=1 if target_baths <= 1.25 && current_baths_value > 1 # Have to add a step between 2 and 1 baths for 1.25 baths
      change_baths_value('decrease', steps)
    end
  end

  def set_limit_filter(type, min_or_max, value)
    if value == "No #{min_or_max}"
      current_url.include?(',') ? remove_filter_from_url("#{min_or_max}-#{type}") : visit(remove_all_filters_from_url)
    else
      value = NumUtils.remove_money_symbols(value) if type == 'price'
      filter_path = "#{min_or_max}-#{type}=#{value}"
      current_url.include?('filter') ?
          new_url = current_url + ',' + filter_path :
          new_url = current_url + '/filter/' + filter_path
      visit(new_url)
    end
  end

  def toggle_property_type(type)
    elem_house_button = find('#propertyTypeFilter > div:nth-child(1) > button:nth-child(1)')
    elem_condo_button = find('#propertyTypeFilter > div:nth-child(1) > button:nth-child(2)')
    elem_townhouse_button = find('#propertyTypeFilter > div:nth-child(1) > button:nth-child(3)')
    elem_multifamily_button = find('#propertyTypeFilter > div:nth-child(2) > button:nth-child(1)')
    elem_land_button = find('#propertyTypeFilter > div:nth-child(2) > button:nth-child(2)')
    elem_othertypes_button = find('#propertyTypeFilter > div:nth-child(2) > button:nth-child(3)')

    case type
    when 'House'
      elem_house_button.click
    when 'Condo'
      elem_condo_button.click
    when 'Townhouse'
      elem_townhouse_button.click
    when 'Multi-family'
      elem_multifamily_button.click
    when 'Land'
      elem_land_button.click
    when 'Other types'
      elem_othertypes_button.click
    else
      abort 'Invalid property type'
    end
  end

end