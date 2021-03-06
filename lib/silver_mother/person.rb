require 'singleton'

module SilverMother
  class Person
    include Singleton

    PERSONS_PATH = 'persons/'.freeze

    attr_reader :persons_raw, :persons

    def call(token)
      @token = token
      @persons_raw = []
      @response = Api.instance.get(PERSONS_PATH, @token)
      @persons_raw << @response
      while next_page
        new_path = PERSONS_PATH + next_page_number
        @response = Api.instance.get(new_path, @token)
        @persons_raw << @response
      end
    end

    def persons
      @persons ||= @persons_raw.each_with_object([]) do |person, array|
        array << person.to_ostruct.objects
      end.flatten
    end

    def clear_cache!
      @persons_raw = []
      @persons     = []
    end

    private

    def next_page
      @response.parsed_response['links']['next'] if @response
    end

    def next_page_number
      @response.parsed_response['links']['next'].split('/').last if next_page
    end
  end
end
