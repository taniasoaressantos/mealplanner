require 'rails_helper'

RSpec.describe DataFetcher do
  subject(:data_fetcher) { described_class.new(source, type: :json) }

  let(:source) { 'path/to/source.json' }
  let(:valid_json_data) { [{ 'title' => 'Recipe 1', 'ingredients' => ['1 cup flour'] }] }

  describe '#initialize' do
    it 'initializes with a source and type' do
      fetcher = described_class.new(source, type: :json)
      expect(fetcher).to be_a(described_class)
    end
  end

  describe '#perform' do
    context 'when type is :json' do
      before do
        allow(File).to receive(:read).with(source).and_return(valid_json_data.to_json)
      end

      it 'fetches data from a JSON file' do
        expect(data_fetcher.perform).to eq(valid_json_data)
      end

      it 'raises an error when JSON is invalid' do
        invalid_json_data = 'invalid json'
        allow(File).to receive(:read).with(source).and_return(invalid_json_data)
        expect { data_fetcher.perform }.to raise_error(JSON::ParserError)
      end

      it 'raises an error when file is not found' do
        allow(File).to receive(:read).with(source).and_raise(Errno::ENOENT)
        expect { data_fetcher.perform }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when type is unsupported' do
      subject(:unsupported_data_fetcher) { described_class.new(source, type: :xml) }

      it 'raises an error for unsupported data types' do
        expect { unsupported_data_fetcher.perform }.to raise_error('Unsupported data type: xml')
      end
    end
  end

  describe '#fetch_from_json' do
    it 'parses JSON data from a file' do
      allow(File).to receive(:read).with(source).and_return(valid_json_data.to_json)
      result = data_fetcher.send(:fetch_from_json)
      expect(result).to eq(valid_json_data)
    end
  end
end
