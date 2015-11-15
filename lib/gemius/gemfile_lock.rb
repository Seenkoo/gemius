module Gemius
  class GemfileLock
    SPEC_PATTERN = /^\s*([\w-]+)\s{1}\(((\d|\.)+)\)/
    GIT_SECTION_PATTERN = /^GIT\n\s+remote:\s(.+)\n\s+revision:\s(.*)\n\s+specs:\s((.|\n)*)/
    GEM_SECTION_PATTERN = /^GEM\n((.|\n)*)/

    def initialize(file_content)
      @file_content = file_content
    end

    def specs
      @specs ||= @file_content.split("\n\n").flat_map { |section| parse_section(section) }.compact
    end

    private

    attr_reader :file_content

    Spec = Struct.new :name, :version, :remote, :revision

    def parse_section(section)
      if section.start_with?("GIT\n")
        parse_git_section(section)
      elsif section.start_with?('GEM')
        parse_gem_section(section)
      end
    end

    def parse_spec_section(content, remote = nil, revision = nil)
      content.split("\n").map { |line| parse_spec(line, remote, revision) }.compact
    end

    def parse_spec(line, remote = nil, revision = nil)
      _, name, version = line.match(SPEC_PATTERN).to_a

      Spec.new(name, version, remote, revision) if name && version
    end

    def parse_git_section(content)
      _, remote, revision, specs_section = content.match(GIT_SECTION_PATTERN).to_a

      parse_spec_section(specs_section, remote, revision) if specs_section
    end

    def parse_gem_section(content)
      _, specs_section = content.match(GEM_SECTION_PATTERN).to_a

      parse_spec_section(specs_section) if specs_section
    end
  end
end