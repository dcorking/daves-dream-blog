require 'test_helper'

class DreamTest < ActiveSupport::TestCase

  test "should reject new dream without title" do
    descr = 'This dream has no title'
    dream = Dream.create(:title => '', :description => descr)
    assert dream.errors.include?(:title)
  end

  test "should reject new dream without description" do
    title = 'This dream has no description.'
    dream = Dream.create(:title => title, :description => '')
    assert dream.errors.include?(:description)
  end

  test "should reject edit to dream without title" do
    dream = dreams(:good)
    dream.update_attributes(:title => '', :description => 'I changed the description')
    dream.save
    assert dream.errors.include?(:title)
  end

  test "should reject edit to dream without description" do
    dreams(:good).update_attributes(:title => 'I changed the title', :description => '')
    dreams(:good).save
    assert dreams(:good).errors.include?(:description)
  end

  test "should reject new dream with description shorter than 10 chars" do
    pending
  end
# short:
#   title: A dream whose description is too short
#   description: Eight ch

  test "should reject new dream with description shorter than 500 chars" do
    pending "not implemented"
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

  test "should reject edit to dream description shorter than 10 chars" do
    pending
  end

  test "should reject edit to dream description longer than 500 chars" do
    pending
  end

  test "should reject duplicate title " do
    pending
  end
# one_and_only:
#   title: A duplicate title
#   description: Titles must be unique
# dupe:
#   title: A duplicate title
#   description: The app should reject dreams with identical titles.

  test "should accept duplicate description with unique title" do
    pending
  end

end
