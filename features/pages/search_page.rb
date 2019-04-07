class SearchPage < SitePrism::Page

  def page_loaded?
    page.should has_selector?('Filter')
  end

  def results_valid?(type, comparison, expected_value)
    get_all_homes_data
    if type.include?('Price')
      expected_value = NumUtils.convert_abbr_to_full(expected_value)
      expected_value = NumUtils.remove_money_symbols(expected_value).to_i
    end
    @homes_data.each do |stats|
      if type.include?('Price')
        value = stats[/(\S*)/]
        value = NumUtils.remove_money_symbols(value).to_i
      else
        value = stats[/(\d*\.?\d*) #{type}/,1]
      end
      next if value.nil?
      return false if comparison == 'greater' && expected_value > value
      return false if comparison == 'less' && expected_value < value
    end
    true
  end

  def get_all_homes_data
    if @homes_data.nil? # Caching because this could get expensive
      elems_home_stats = all('div.HomeStatsV2')
      elems_home_prices = all('span.homecardV2Price')
      home_prices = elems_home_prices.map(&:text)
      home_stats = elems_home_stats.map(&:text)
      @homes_data = home_prices.zip(home_stats).map { |a| a.join(' ') }
    end
    @homes_data
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
    @homes_data = nil
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
    @homes_data = nil
  end

  def set_baths(target_baths)
    elem_baths_value = find('#filterContent > div > div:nth-child(1) > div.doubleRow > div:nth-child(2) > div.filterRow > span > span > span.input > span > span')

    target_baths = target_baths.chop.to_i
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

  def change_baths_value(action, steps)
    action = (action == 'increase') ? 'up' : 'down'
    elem_button = find("#filterContent > div > div:nth-child(1) > div.doubleRow > div:nth-child(2) > div.filterRow > span > span > span.step-#{action}")
    steps.times do
      elem_button.click
    end
    page_loaded?
    @homes_data = nil
  end

end