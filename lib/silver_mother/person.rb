require 'singleton'

module SilverMother
  class Person
    include Singleton

    def call(token)
      @token = token
      @persons_raw = []
      @response = Api.instance.get(@token, path)
      @persons_raw << @response
      while next_page do
        new_path = path + next_page_number
        @response = Api.instance.get(@token, new_path)
        @persons_raw << @response
      end
    end

    def persons
      @persons ||= @persons_raw.each_with_object([]) do |person, array|
        array << person.to_ostruct.objects
      end.flatten
    end

    private

    def path
      'persons/'
    end

    def next_page
      @response.parsed_response['links']['next'] if @response
    end

    def next_page_number
      @response.parsed_response['links']['next'].split('/').last if next_page
    end
  end
end

# Examples
#
# Fetch token first:
# token = SilverMother::Token.new('your_username', 'your_password')
#
# persons_api = SilverMother::Person.instance
# persons_api.call(token)
# persons = persons_api.persons
# person = persons.first
#
# Attributes/methods available for the person now:
# uid, avatarUrl, email, firstName, lastName, gender, object, phoneNumber.


