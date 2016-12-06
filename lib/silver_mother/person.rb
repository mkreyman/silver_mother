require 'singleton'

module SilverMother
  class Person
    include Singleton

    def call(token)
      @token = token
      @persons_raw = []
      @response = Api.instance.get(path, @token)
      @persons_raw << @response
      while next_page do
        new_path = path + next_page_number
        @response = Api.instance.get(new_path, @token)
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
