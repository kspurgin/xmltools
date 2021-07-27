# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::AppContract' do
  let(:described_class){ Xmltools::AppContract }
  let(:recurse) { false }

  before{ @files = Dry::Files.new }

  describe 'existing_dir' do
    class DirContract < Xmltools::AppContract
      schema do
        required(:dir).value(:string)
      end

      rule(:dir).validate(:existing_dir)
    end
    
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
        expect(result.errors.messages.first.text).to eq('directory does not exist')
      end
    end

  end

  describe 'xml_dir' do
    class XMLDirContract < Xmltools::AppContract
      schema do
        required(:dir).value(:string)
        required(:recurse).value(:bool)
      end

      rule(:dir, :recurse).validate(:xml_dir)
    end
    
    let(:contract){ XMLDirContract.new }
    let(:result){ contract.call(dir: dirval, recurse: recurse) }
    
    context 'with empty string' do
      let(:dirval){ '' }
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'with existing path containing an XML file' do
      before do
        @path = @files.join(fixtures_dir, 'a.xml')
        @files.touch(@path)
      end
      let(:dirval){ fixtures_dir }
      it 'is success' do
        expect(result.success?).to be true
      end
      after{ @files.delete(@path) }
    end

    context 'with existing directory without XML' do
      before do
        @path = @files.join(fixtures_dir, 'emptydir')
        @files.mkdir(@path)
      end
      after{ @files.delete_directory(@path) }
      let(:dirval){ @path }

      context 'when no child directories contain XML files' do
        before do
          child_dir = @files.join(@path, 'childdir')
          @files.mkdir(child_dir)
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
          child_dir = @files.join(@path, 'childdir')
          @files.mkdir(child_dir)
          @files.touch(@files.join(child_dir, 'a.xml'))
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
