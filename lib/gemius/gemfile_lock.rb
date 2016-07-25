module Gemius
  class GemfileLock
    SPECS_SECTION_RE = /(?:\s{4}((?:\w|-|\.)+)\s\(((?:\w|\.)+)\))+\n?/
    GIT_SECTION_RE = /\s{2}remote:\s(.+)\n\s{2}revision:\s(.+)\n(?:\s{2}ref:\s(.+))?\n?(?:\s{2}branch:\s(.+))?/
    REMOTE_RE = /\s{2}remote:\s(.+)/

    def initialize(file_content)
      @file_content = file_content
    end

    def specs
      @specs ||= @file_content.split("\n\n").flat_map { |section| parse_section(section) }.compact
    end

    private

    attr_reader :file_content

    def parse_section(section)
      if section.start_with?("GIT")
        parse_git_section(section)
      elsif section.start_with?("PATH")
        parse_path_section(section)
      elsif section.start_with?("GEM")
        parse_gem_section(section)
      end
    end

    def parse_git_section(section)
      _, remote, revision, ref, branch = section.match(GIT_SECTION_RE).to_a
      additional_props = {remote: remote, revision: revision}
      additional_props[:ref] = ref if ref
      additional_props[:branch] = branch if branch

      parse_specs_section(section, additional_props)
    end

    def parse_path_section(section)
      parse_specs_section(section, remote: section.match(REMOTE_RE)[1])
    end

    def parse_gem_section(section)
      parse_specs_section(section, remote: section.scan(REMOTE_RE).flatten.join(", "))
    end

    def parse_specs_section(section, additional_props)
      section.scan(SPECS_SECTION_RE).map do |(name, version)|
        {name: name, version: version}.merge!(additional_props)
      end
    end
  end
end
