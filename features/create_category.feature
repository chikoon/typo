Feature: Create new category
  As a blog administrator, I want to create new, edit, and delete categories.

  Background:
    Given the blog is set up
      And I am logged into the admin panel

  Scenario:
    Given I am on the admin home page
    When I follow "Categories"
    Then I should see "Name"
      And I should see "Keywords"
      And I should see "Permalink"
    When I fill in "category_name" with "chicken"
      And I press "Save"
    Then I should see "chicken"
    When I follow "chicken"
    Then the "category_name" field should contain "chicken"