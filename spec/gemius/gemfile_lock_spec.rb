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
  revision: 261075ed26d830cf3d960d7a447c3badbaa68734
  tag: v0.5.1
  specs:
    postgresql_cursor (0.5.1)
      activerecord (>= 3.1.0)
        GEMFILE
      end

      it do
        expect(specs).to contain_exactly({name: 'big_sitemap',
                                          version: "1.0.1",
                                          remote: "git://github.com/abak-press/big_sitemap.git",
                                          revision: "9b061f833510c4de41e1d53b7d5f4504d47900b8"},
                                         {name: 'postgresql_cursor',
                                          version: "0.5.1",
                                          remote: "git://github.com/abak-press/postgresql_cursor.git",
                                          revision: "261075ed26d830cf3d960d7a447c3badbaa68734",
                                          tag: "v0.5.1"})
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

      it do
        expect(specs).to contain_exactly({name: 'aasm', version: "3.1.1", remote: "https://rubygems.org/"},
                                         {name: 'actionmailer', version: "3.1.12", remote: "https://rubygems.org/"},
                                         {name: 'actionpack', version: "3.1.12", remote: "https://rubygems.org/"})
      end
    end
  end
end
