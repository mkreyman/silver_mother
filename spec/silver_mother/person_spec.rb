require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Person do
    token = 'stubbed-application-token'
    persons_api = SilverMother::Person.instance

    before :all do
      stub_request(:get, SENSE_API_URL + 'persons/')
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(body: fixture('dummy_persons.json'))

      persons_api.call(token)
    end

    context 'with all data' do
      it 'pulls raw persons with #call' do
        expected_raw_person_data = fixture('dummy_persons.json')
        expect(persons_api.persons_raw[0].parsed_response)
          .to eq expected_raw_person_data
      end

      it 'extracts persons data with #persons' do
        expected_persons = JSON.parse(fixture('dummy_persons.json'),
                                      object_class: OpenStruct).objects

        expect(persons_api.persons).to eq expected_persons
      end
    end
  end
end
