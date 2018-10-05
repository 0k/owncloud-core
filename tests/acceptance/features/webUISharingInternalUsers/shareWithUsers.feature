@webUI @insulated @disablePreviews
Feature: Sharing files and folders with internal users
  As a user
  I want to share files and folders with other users
  So that those users can access the files and folders

  Background:
    Given these users have been created:
      | username |
      | user1    |
      | user2    |
    And user "user2" has logged in using the webUI

  @TestAlsoOnExternalUserBackend
  @smokeTest
  Scenario: share a file & folder with another internal user
    When the user shares the folder "simple-folder" with the user "User One" using the webUI
    And the user shares the file "testimage.jpg" with the user "User One" using the webUI
    And the user re-logs in as "user1" using the webUI
    Then the folder "simple-folder (2)" should be listed on the webUI
    And the folder "simple-folder (2)" should be marked as shared by "User Two" on the webUI
    And the file "testimage (2).jpg" should be listed on the webUI
    And the file "testimage (2).jpg" should be marked as shared by "User Two" on the webUI
    When the user opens the folder "simple-folder (2)" using the webUI
    Then the file "lorem.txt" should be listed on the webUI
    But the folder "simple-folder (2)" should not be listed on the webUI

  @TestAlsoOnExternalUserBackend
  Scenario: share a file with another internal user who overwrites and unshares the file
    When the user renames the file "lorem.txt" to "new-lorem.txt" using the webUI
    And the user shares the file "new-lorem.txt" with the user "User One" using the webUI
    And the user re-logs in as "user1" using the webUI
    Then the content of "new-lorem.txt" should not be the same as the local "new-lorem.txt"
		# overwrite the received shared file
    When the user uploads overwriting the file "new-lorem.txt" using the webUI and retries if the file is locked
    Then the file "new-lorem.txt" should be listed on the webUI
    And the content of "new-lorem.txt" should be the same as the local "new-lorem.txt"
		# unshare the received shared file
    When the user unshares the file "new-lorem.txt" using the webUI
    Then the file "new-lorem.txt" should not be listed on the webUI
		# check that the original file owner can still see the file
    When the user re-logs in as "user2" using the webUI
    Then the content of "new-lorem.txt" should be the same as the local "new-lorem.txt"

  @TestAlsoOnExternalUserBackend
  Scenario: share a folder with another internal user who uploads, overwrites and deletes files
    When the user renames the folder "simple-folder" to "new-simple-folder" using the webUI
    And the user shares the folder "new-simple-folder" with the user "User One" using the webUI
    And the user re-logs in as "user1" using the webUI
    And the user opens the folder "new-simple-folder" using the webUI
    Then the content of "lorem.txt" should not be the same as the local "lorem.txt"
		# overwrite an existing file in the received share
    When the user uploads overwriting the file "lorem.txt" using the webUI and retries if the file is locked
    Then the file "lorem.txt" should be listed on the webUI
    And the content of "lorem.txt" should be the same as the local "lorem.txt"
		# upload a new file into the received share
    When the user uploads the file "new-lorem.txt" using the webUI
    Then the content of "new-lorem.txt" should be the same as the local "new-lorem.txt"
		# delete a file in the received share
    When the user deletes the file "data.zip" using the webUI
    Then the file "data.zip" should not be listed on the webUI
		# check that the file actions by the sharee are visible for the share owner
    When the user re-logs in as "user2" using the webUI
    And the user opens the folder "new-simple-folder" using the webUI
    Then the file "lorem.txt" should be listed on the webUI
    And the content of "lorem.txt" should be the same as the local "lorem.txt"
    And the file "new-lorem.txt" should be listed on the webUI
    And the content of "new-lorem.txt" should be the same as the local "new-lorem.txt"
    But the file "data.zip" should not be listed on the webUI

  @TestAlsoOnExternalUserBackend
  Scenario: share a folder with another internal user who unshares the folder
    When the user renames the folder "simple-folder" to "new-simple-folder" using the webUI
    And the user shares the folder "new-simple-folder" with the user "User One" using the webUI
		# unshare the received shared folder and check it is gone
    And the user re-logs in as "user1" using the webUI
    And the user unshares the folder "new-simple-folder" using the webUI
    Then the folder "new-simple-folder" should not be listed on the webUI
		# check that the folder is still visible for the share owner
    When the user re-logs in as "user2" using the webUI
    Then the folder "new-simple-folder" should be listed on the webUI
    When the user opens the folder "new-simple-folder" using the webUI
    Then the file "lorem.txt" should be listed on the webUI
    And the content of "lorem.txt" should be the same as the original "simple-folder/lorem.txt"

  @skipOnMICROSOFTEDGE @TestAlsoOnExternalUserBackend
  Scenario: share a folder with another internal user and prohibit deleting
    When the user shares the folder "simple-folder" with the user "User One" using the webUI
    And the user sets the sharing permissions of "User One" for "simple-folder" using the webUI to
      | delete | no |
    And the user re-logs in as "user1" using the webUI
    And the user opens the folder "simple-folder (2)" using the webUI
    Then it should not be possible to delete the file "lorem.txt" using the webUI

  Scenario: share a folder with other user and then it should be listed on Shared with You for other user
    Given the user has renamed the folder "simple-folder" to "new-simple-folder" using the webUI
    And the user has renamed the file "lorem.txt" to "ipsum.txt" using the webUI
    And the user has shared the file "ipsum.txt" with the user "User One" using the webUI
    And the user has shared the folder "new-simple-folder" with the user "User One" using the webUI
    When the user re-logs in as "user1" using the webUI
    And the user browses to the shared-with-you page
    Then the file "ipsum.txt" should be listed on the webUI
    And the folder "new-simple-folder" should be listed on the webUI

  Scenario: share a folder with other user and then it should be listed on Shared with Others page
    Given the user has shared the file "lorem.txt" with the user "User One" using the webUI
    And the user has shared the folder "simple-folder" with the user "User One" using the webUI
    When the user browses to the shared-with-others page
    Then the file "lorem.txt" should be listed on the webUI
    And the folder "simple-folder" should be listed on the webUI

  Scenario: share two file with same name but different paths
    Given the user has shared the file "lorem.txt" with the user "User One" using the webUI
    When the user opens the folder "simple-folder" using the webUI
    And the user shares the file "lorem.txt" with the user "User One" using the webUI
    And the user browses to the shared-with-others page
    Then the file "lorem.txt" with the path "" should be listed in the shared with others page on the webUI
    And the file "lorem.txt" with the path "/simple-folder" should be listed in the shared with others page on the webUI
