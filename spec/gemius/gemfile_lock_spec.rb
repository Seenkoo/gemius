require "spec_helper"

describe Gemius::GemfileLock do
  describe '#specs' do
    subject(:specs) { described_class.new(lock_file).specs }

    context 'when lock_file with GIT section' do
      let(:lock_file) do
        <<-GEMFILE
GIT
  remote: git://github.com/abak-press/big_sitemap.git
  revision: 9b061f833510c4de41e1d53b7d5f4504d47900b8
  specs:
    big_sitemap (1.0.1)

GIT
  remote: git://github.com/abak-press/postgresql_cursor.git
  revision: 31f503975063aeffdc3573f8dd3695a3ab1e1bc3
  specs:
    postgresql_cursor (0.5.1)
      activerecord (>= 3.1.0)
        GEMFILE
      end

      it { expect(specs.size).to eq(2) }

      it do
        expect(specs[0].name).to eq 'big_sitemap'
        expect(specs[0].version).to eq '1.0.1'
      end

      it do
        expect(specs[1].name).to eq 'postgresql_cursor'
        expect(specs[1].version).to eq '0.5.1'
      end
    end

    context 'when lock_file with GEM section' do
      let(:lock_file) do
        <<-GEMFILE
GEM
  remote: https://rubygems.org/
  specs:
    aasm (3.1.1)
    actionmailer (3.1.12)
      actionpack (= 3.1.12)
      mail (~> 2.4.4)
    actionpack (3.1.12)
        GEMFILE
      end

      it { expect(specs.size).to eq(3) }

      it do
        expect(specs[0].name).to eq 'aasm'
        expect(specs[0].version).to eq '3.1.1'
      end

      it do
        expect(specs[1].name).to eq 'actionmailer'
        expect(specs[1].version).to eq '3.1.12'
      end
    end
  end
end