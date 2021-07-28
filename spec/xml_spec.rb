# frozen_string_literal: true

require 'spec_helper'

class TestClass
  include Xmltools::Xml
end

RSpec.describe 'Xmltools::XML' do
  let(:instance){ TestClass.new }

  describe '#schema_doc' do
    let(:schemapath){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }

    context 'with valid schema' do
      it 'returns Nokogiri::XML::Schema' do
        expect(instance.schema_doc(schemapath)).to be_a Nokogiri::XML::Schema
      end
    end

    context 'with invalid schema' do
      let(:schemapath){ files.join(fixtures_dir, 'xsd', 'mods_schema_invalid.xsd') }
      it 'raises Xmltools::Xml::InvalidSchemaError' do
        expect{ instance.schema_doc(schemapath) }.to raise_error(Xmltools::Xml::InvalidSchemaError)
      end
    end
  end
end

