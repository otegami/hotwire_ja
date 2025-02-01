require "json"
require "rake"

class TranslationPrUpdater
  include Rake::FileUtilsExt

  def initialize(repository_path, translated_file, diff_content)
    @repository_path = repository_path
    @translated_file = translated_file
    @diff_content = diff_content
  end

  def execute
    current_title, current_description = find_existed_pr
    Dir.chdir(repository_path) do
      if current_title.empty? && current_description.empty?
        create_pr(branch, title, generate_description(diff_content))
      else
        update_pr(branch, update_description(current_description, diff_content))
      end
    end
  end

  private

  attr_reader :translated_file, :repository_path, :diff_content

  DIFF_START = "## Diff (Please don't change this section. It will be automatically updated.)"
  DIFF_END = "<!-- Please write your description under here. -->"

  def branch
    "update-translation-" +
      "#{translated_file.project}-" +
      "#{translated_file.category}-" +
      "#{translated_file.topic}"
  end

  def title
    "#{translated_file.project} " +
      "#{translated_file.category} " +
      "#{translated_file.topic}: " +
      "updated translation"
  end

  def generate_description(diff)
<<-TEMPLATE
#{DIFF_START}

~~~diff
#{diff}
~~~

#{DIFF_END}

TEMPLATE
  end

  def update_description(description, diff)
    lines = description.lines
    diff_start = lines.index { |line| line.strip == DIFF_START }
    diff_end = lines.index { |line| line.strip == DIFF_END }

    if diff_start && diff_end && diff_start < diff_end
      before_diffs = lines[0...diff_start].join
      after_diffs = lines[(diff_end).next..-1].join

      before_diffs + generate_description(diff) + after_diffs
    else
      generate_description(diff)
    end
  end

  def find_existed_pr
    pr_raw_info = Tempfile.open("pr.json") do |pr|
      sh("gh",
         "--repo", "otegami/hotwire_ja",
         "pr",
         "view",
         branch,
         "--json",
         "title,body",
         {out: pr}
      )
      pr.open.read
    end
    if pr_raw_info.empty?
      ['', '']
    else
      pr_info = JSON.parse(pr_raw_info, symbolize_names: true)
      [pr_info[:title], pr_info[:body]]
    end
  end

  def commit_diff
    sh("git", "add", translated_file.path.to_s)
    sh("git",
       "commit",
       "-m",
       "updated translation target commit")
  end

  def update_pr(branch, description)
    sh("git", "fetch")
    sh("git", "switch", "-c", branch, "origin/#{branch}")
    commit_diff
    sh("git", "push", "origin", branch)
    sh("gh",
       "--repo", "otegami/hotwire_ja",
       "pr",
       "edit",
       "--body", description)
  end

  def create_pr(branch, title, description)
    sh("git", "switch", "-c", branch)
    commit_diff
    sh("git", "push", "origin", branch)
    sh("gh",
       "--repo", "otegami/hotwire_ja",
       "pr",
       "create",
       "--title", title,
       "--body", description,
       "--base", "auto-translations-update",
       "--head", branch)
    puts "Created a new PR for #{branch}."
  end
end
