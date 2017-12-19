require 'application_system_test_case'

class AutomorphsTest < ApplicationSystemTestCase
  ANSWERS = [1, 5, 6, 25, 76].freeze

  # Test AJAX
  class Ajax < AutomorphsTest
    def setup
      Capybara.current_driver = :selenium_chrome
      signin_as_user1
    end

    test 'should get result for automorph numbers less or equal then 25' do
      visit automorph_result_path(number: 36)
      self.test_results(4)
    end

    test 'should get result for automorph numbers less or equal then 100' do
      visit automorph_result_path(number: 100)
      self.test_results(5)
    end

    test 'should not get result for numbers greater then 100' do
      visit automorph_result_path(number: 101)
      page.find('p#error').assert_text 'Number is too large'
    end

    test 'should not get result for non-positive numbers' do
      visit automorph_result_path(number: -1)
      page.find('p#error').assert_text 'Number is too small'
    end

    test 'should not get result for non numbers params' do
      visit automorph_result_path(number:  'string')
      page.find('p#error').assert_text 'Number parameter is not an integer'
    end

    test 'should not get result number param' do
      visit automorph_result_path(number: nil)
      page.find('p#error').assert_text 'Number parameter is not an integer'
    end

    protected

    def test_results(length)
      # Check headers
      ths = page.find('table tr:first-child').all 'th'
      assert_equal 3, ths.length

      # Check rows
      rows = page.all 'table tr:not(:first-child)'
      assert_equal rows.length, length
      rows.each_with_index do |tr, i|
        tr.find('td[name=index]').assert_text (i + 1).to_s
        tr.find('td[name=value]').assert_text ANSWERS[i].to_s
        tr.find('td[name=square]').assert_text (ANSWERS[i]**2).to_s
      end
    end
  end
end
