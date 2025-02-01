require "open3"
require "rake"

class PrManager
  include Rake::FileUtilsExt

  def initialize(repository_path, translated_file, diff_content)
    @repository_path = repository_path
    @translated_file = translated_file
    @diff_content = diff_content
    @title, @description = find_existed
    @existed = false
  end

  def create_or_update
    Dir.chdir(repository_path) do
      if existed
        sh("git", "switch", branch)
        update_pr
      else
        sh("git", "switch", "-c", branch)
        create_pr
      end
    end
  end

  def create_pr
    updated_commit
    sh("gh",
       "--repo", "otegami/hotwire_ja"
       "pr",
       "create",
       "--title", title,
       "--body", description,
       "--base", "main",
       "--head", branch)
    puts "Created a new PR for branch #{branch_name}."
  end

  def branch
    project, category, topic = translated_file.path.to_s.split("/").last(3)
    "update-translation-#{project}-#{category}-#{topic.sub('.md', '')}"
  end

  def title
    project, category, topic = translated_file.path.to_s.split("/").last(3)
    "#{project} #{category} #{topic}: updated translation"
  end

  def description
    if existed
      updated_description
    else
      diff_template
    end
  end

  def find_existed
    response = sh_capture("gh",
                          "pr",
                          "view",
                          branch,
                          "--json",
                          "title,body")
    if response[:stdout].empty?
      @existed = false
      ['', '']
    else
      @existed = true
      pr_info = JSON.parse(response[:stdout])
      [pr_info[:title], pr_info[:body]]
    end
  end

  def updated_commit
    sh("git",
       "commit",
       "-m",
       "updated translation",
       "--allow-empty")
  end

  private

  attr_reader :translated_file, :repository_path, :existed

  DIFF_START = "## Diff (Please don't change this section. It will be automatically updated.)"
  DIFF_END = "**Please write a description under here.**"

  def sh_capture(*args)
    stdout, stderr, status = Open3.capture3(*args)
    { success: status.success?, stdout:, stderr: }
  end

  def diff_template
<<-TEMPLATE
#{DIFF_START}

```diff
#{@diff_content}
```

#{DIFF_END}

TEMPLATE
  end

  def update_description
    lines = @description.lines
    diff_start = lines.index { |line| l.strip == DIFF_START }
    diff_end = lines.index { |l| l.strip == DII_END }

    if start_index && end_index && start_index < end_index
      before_lines  = lines[0..start_index]
      after_lines   = lines[end_index..-1]

      before_lines + @diff_content + after_lines
    else
      diff_template
    end
  end
end
