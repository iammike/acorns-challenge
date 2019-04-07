Feature: Redfin Search

  Scenario: Search results match filters
    Given I am on the Redfin homepage
    And I search for homes in Portland, OR
    And I expand Filters
    Then I set Baths filter to 2+
    Then I set Minimum Beds filter to 3
    Then I set Minimum Price filter to $300k
    Then I set Maximum Price filter to $525k
    And I verify in search results Baths are greater than or equal to 2
    And I verify in search results Beds are greater than or equal to 3
    And I verify in search results Minimum Price is greater than or equal to $300k
    And I verify in search results Maximum Price is less than or equal to $525k