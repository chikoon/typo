Feature: Merge Articles
  As a blog administrator
  In order to unify posts that have similar content
  I want to be able to merge articles

  Background:
    Given the blog is set up
    And the following articles exist:
      | title        | author    | body           | permalink    |
      | Fuzzy Wuzzy  | admin     | was a bear     | fuzzy-wuzzy  |
      | Peter Piper  | publisher | picked a peck  | peter-piper  |
      | Oompa Loompa | publisher | lopidy dee     | oompa-loompa |
#      | Petah Pipah  | admin     | pecked a pick  | petah-pipah  |

  #    | Itsy Bitsy   | publisher | up water spout | itsy-bitsy   |

  Scenario: A non-admin cannot merge articles
    Given I am logged in as a publisher
      And I am not an administrator
    When I am on the edit page for an article I wrote
    Then I should see "Peter Piper"
      And I should not see "Merge Articles"

  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
      And I am an administrator
      When I am on the edit page for the "fuzzy-wuzzy" article
    Then I should see "Fuzzy Wuzzy"
      And I should see "Merge Articles"
    When I fill in "other_article_id" with "4"
      And I press "Merge"
    Then I should be on the edit page for the newly created merged article
      And I should see either "Fuzzy Wuzzy" or "Peter Piper" # one of the titles
      And I should see the "was a bear"
      And I should see the "picked a peck"
      And I should see the "comments" of "Fuzzy Wuzzy"
      And I should see the "comments" of "Peter Piper"


  Scenario: No merge articles option for new articles
    Given I am on the new article page
    Then I should not see "Merge Articles"

  Scenario: Unsuccessfull when merge_with value is empty
    Given I am on the edit page for article with id "1"
    And I am an administrator
    When I press "Merge"
    Then I should see an exception

  Scenario: Unsuccessfull when the current article's id is given for merging
    Given I am on the edit page for article with id "1"
    And I am an administrator
    When I fill in "other_article_id" with 3
    And I press "Merge"
    Then I should see an exception

  Scenario: Unsuccessful when a non-existant id is provided for merging
    Given I am on the edit page for article with id "1"
    And I am an administrator
    And article 42 does not exist
    When I fill in "other_article_id" with 42
    And I press "Merge"
    Then I should see an exception

