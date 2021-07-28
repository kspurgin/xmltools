# frozen_string_literal: true

require 'spec_helper'

class DirContract < Xmltools::AppContract
  schema do
    required(:dir).value(:string)
  end

  rule(:dir).validate(:existing_dir_or_file)
end

class FileContract < Xmltools::AppContract
  schema do
    required(:file).value(:string)
  end

  rule(:file).validate(:existing_dir_or_file)
end

class SchemaContract < Xmltools::AppContract
  schema do
    required(:path).value(:string)
  end

  rule(:path).validate(:valid_schema)
end

class XMLDirContract < Xmltools::AppContract
  schema do
    required(:dir).value(:string)
    required(:recurse).value(:bool)
  end

  rule(:dir).validate(xml_dir: :recurse)
end

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::AppContract' do
  let(:described_class){ Xmltools::AppContract }
  let(:recurse){ false }

  describe 'existing_dir_or_file' do
    context 'when validating a directory' do
      let(:contract){ DirContract.new }
      let(:result){ contract.call(dir: dirval) }

      context 'with empty string' do
        let(:dirval){ '' }
        it 'is success' do
          expect(result.success?).to be true
        end
      end

      context 'with existing directory' do
        let(:dirval){ fixtures_dir }
        it 'is success' do
          expect(result.success?).to be true
        end
      end

      context 'with nonexistent directory' do
        let(:dirval){ '/a/b/c/d/e' }
        it 'is failure' do
          expect(result.failure?).to be true
        end
        it 'has expected message' do
          msg = "dir does not exist at #{dirval}"
          expect(result.errors.messages.first.text).to eq(msg)
        end
      end
    end

    context 'when validating a file' do
      let(:contract){ FileContract.new }
      let(:result){ contract.call(file: fileval) }

      context 'with empty string' do
        let(:fileval){ '' }
        it 'is success' do
          expect(result.success?).to be true
        end
      end

      context 'with existing file' do
        let(:fileval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
        it 'is success' do
          expect(result.success?).to be true
        end
      end

      context 'with nonexistent file' do
        let(:fileval){ files.join(fixtures_dir, 'xsd', 'missing.xsd') }
        it 'is failure' do
          expect(result.failure?).to be true
        end
        it 'has expected message' do
          msg = "file does not exist at #{fileval}"
          expect(result.errors.messages.first.text).to eq(msg)
        end
      end
    end
  end

  describe 'valid_schema' do
    let(:contract){ SchemaContract.new }
    let(:result){ contract.call(path: schemaval) }

    context 'with valid schema' do
      let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
      it 'is success' do
        expect(result.failure?).to be false
      end
    end

    context 'with invalid schema' do
      let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema_invalid.xsd') }
      it 'is failure' do
        expect(result.failure?).to be true
      end
      it 'has expected message' do
        messages = result.errors.messages.map(&:text)
        msg = "invalid schema at #{schemaval}"
        expect(messages).to eq([msg])
      end
    end
  end

  describe 'xml_dir' do
    let(:contract){ XMLDirContract.new }
    let(:result){ contract.call(dir: dirval, recurse: recurse) }

    context 'with empty string' do
      let(:dirval){ '' }
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'with nonexistent directory' do
      let(:dirval){ '/a/b/c/d/e' }
      it 'raises Errno::ENOENT' do
        expect{ result }.to raise_error(Errno::ENOENT)
      end
      # it 'blah' do
      #   expect(result.failure?).to be true
      # end
    end

    context 'with existing path containing an XML file' do
      before do
        @path = files.join(fixtures_dir, 'a.xml')
        files.touch(@path)
      end
      let(:dirval){ fixtures_dir }
      it 'is success' do
        expect(result.success?).to be true
      end
      after{ files.delete(@path) }
    end

    context 'with existing directory without XML' do
      before do
        @path = files.join(fixtures_dir, 'emptydir')
        files.mkdir(@path)
      end
      after{ files.delete_directory(@path) }
      let(:dirval){ @path }

      context 'when no child directories contain XML files' do
        before do
          child_dir = files.join(@path, 'childdir')
          files.mkdir(child_dir)
        end
        context 'when not recursive' do
          it 'is failure' do
            expect(result.failure?).to be true
          end
          it 'has expected message' do
            expect(result.errors.messages.first.text).to eq('directory contains no XML')
          end
        end

        context 'when recursive' do
          let(:recurse){ true }
          it 'is failure' do
            expect(result.failure?).to be true
          end
          it 'has expected message' do
            expect(result.errors.messages.first.text).to eq('directory contains no XML')
          end
        end
      end

      context 'when a child directory contain XML files' do
        before do
          child_dir = files.join(@path, 'childdir')
          files.mkdir(child_dir)
          files.touch(files.join(child_dir, 'a.xml'))
        end
        context 'when not recursive' do
          it 'is failure' do
            expect(result.failure?).to be true
          end
          it 'has expected message' do
            expect(result.errors.messages.first.text).to eq('directory contains no XML')
          end
        end

        context 'when recursive' do
          let(:recurse){ true }
          it 'is success' do
            expect(result.success?).to be true
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
