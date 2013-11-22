Feature: Merge Articles
  As a blog administrator
  In order to unify posts that have similar content
  I want to be able to merge articles

  Background:
    Given the blog is set up
    And the following articles exist:
      | title        | author    | body           | permalink    | comment           |
      | Fuzzy Wuzzy  | admin     | was a bear     | fuzzy-wuzzy  | had no hair       |
      | Peter Piper  | publisher | picked a peck  | peter-piper  | where's the peck? |
      | Oompa Loompa | publisher | lopidy dee     | oompa-loompa | sheer happiness!  |

  Scenario: A non-admin cannot merge articles
    Given I am logged in as a publisher
      And I am not an administrator
    When I go to the edit page for the "peter-piper" article
    Then the "article_title" field should contain "Peter Piper"
      And I should not see "Merge Articles"

  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
      And I am an administrator
      When I am on the edit page for the "fuzzy-wuzzy" article
    Then the "article_title" field should contain "Fuzzy Wuzzy"
      And I should see "Merge Articles"
    When I fill in "merge_with" with the id of the "peter-piper" article
      And I press "Merge"
    Then I should be on the edit page for the "peter-piper" article
      And the "article__body_and_extended_editor" field should contain "was a bear"
      And the "article__body_and_extended_editor" field should contain "picked a peck"
      And the "fuzzy-wuzzy" article should not exist
      And the "peter-piper" article should have "2" comments
      And the "peter-piper" article should have a comment with "had no hair"
      And the "peter-piper" article should have a comment with "where's the peck?"


  Scenario: Unsuccessfull when the current article's id is given for merging
    Given I am logged into the admin panel
      And I am an administrator
    And I am on the edit page for the "peter-piper" article
    When I fill in "merge_with" with the id of the "peter-piper" article
      And I press "Merge"
    Then I should see "Error, you can't merge an article to itself"

  Scenario: No merge articles option for new articles
    Given I am on the new article page
    Then I should not see "Merge Articles"

  Scenario: Unsuccessfull when merge_with value is empty
    Given I am logged into the admin panel
      And I am on the edit page for article with id "1"
    When I press "Merge"
    Then I should see "Error, expected an article id for the merge"

  Scenario: Unsuccessful when a non-existant id is provided for merging
    Given I am logged into the admin panel
    And I am on the edit page for article with id "1"
    When I fill in "merge_with" with "42"
    And I press "Merge"
    Then I should see "Error, there is no article with id"

