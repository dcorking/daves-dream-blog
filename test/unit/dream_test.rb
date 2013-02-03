require 'test_helper'

class DreamTest < ActiveSupport::TestCase

  test "should reject new dream without title" do
    debugger
    # assert true
  end
# title_missing:
#   title:
#   description: This dream has no title.

  test "should reject new dream without description" 
# description_missing:
#   title:
#   description: This dream has no description.

  test "should reject edit to dream without title" do
    pending
    # not implemented
  end

  test "should reject new dream with title shorter than 10 chars" do
  end
# short:
#   title: A dream whose title is too short
#   description: Eight ch

  test "should reject new dream with description shorter than 500 chars" do
# long:
#   title: A dream whose description is too long
#   description: 501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too muc
# short_enough:
#   title: A dream whose description is exactly 500 chars
#   description: 501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu501 characters is too mu
# long_enough:
#   title: A dream whose description is exactly 10 chars
#   description:Only 10 ch
  end

  test "should reject edit to dream title shorter than 10 chars" do
  end

  test "should reject edit to dream description longer than 500 chars" do
  end

  test "should reject duplicate title " do
  end
# one_and_only:
#   title: A duplicate title
#   description: Titles must be unique
# dupe:
#   title: A duplicate title
#   description: The app should reject dreams with identical titles.

  test "should reject duplicate description" do
  end

end
