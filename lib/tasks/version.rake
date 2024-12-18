namespace :version do

  CHANGELOG_NAME = 'CHANGELOG.md'
  DEPLOYMENT_NAME = 'DEPLOYMENT.md'

  def ensure_version_defined
    unless defined? Rails.application.class::VERSION
      STDERR.puts 'You need to add the file "config/initializers/version.rb" which defines the version as a constant in the application namespace.'
      STDERR.puts 'Abort, nothing done.'
      exit 1
    end
  end

  def application_name
    return Rails.application.class::NAME if defined? Rails.application.class::NAME
    Rails.application.class.parent_name.underscore.humanize.split.map(&:capitalize).join(' ')
  end

  def changelog_file_path
    Rails.root.join(CHANGELOG_NAME)
  end

  def deployment_file_path
    Rails.root.join(DEPLOYMENT_NAME)
  end

  def version_file_path
    Rails.root.join('config', 'initializers', 'version.rb')
  end

  def create_file_with_content(file, content)
    File.open(file, "w+") do |f|
      f.write(content)
    end
  end

  def change_version(new_version)
    old_version = Rails.application.class::VERSION
    puts "#{old_version} => #{new_version}"
    print 'Confirm? (Y/n): '
    confirmation = (STDIN.gets.chomp.downcase == 'y')

    unless confirmation
      STDERR.puts 'Abort, nothing done.'
      exit 1
    end

    puts "Updating #{version_file_path}..."
    content = File.read(version_file_path)
    File.open(version_file_path, 'w') do |f|
      f.puts content.gsub(/VERSION ?= ?'#{old_version}'/, "VERSION = '#{new_version}'")
    end

    title = "## #{application_name} v#{new_version} (#{Date.today.strftime('%d.%m.%Y')})"

    if File.exist?(deployment_file_path)
      puts "Updating #{DEPLOYMENT_NAME}..."
      content = File.read(deployment_file_path)
      File.open(deployment_file_path, 'w') do |f|
        f.puts title
        f.puts
        f.puts content
      end
    else
      STDERR.puts "file #{DEPLOYMENT_NAME} is missing! did you run 'version:init'?"
    end

    if File.exist?(changelog_file_path)
      puts "Updating #{CHANGELOG_NAME}..."
      content = File.read(changelog_file_path)
      File.open(changelog_file_path, 'w') do |f|
        f.puts content.gsub(/^(# Changelog #{application_name})$/, "\\1\n\n#{title}")
      end
    else
      STDERR.puts "file #{CHANGELOG_NAME} is missing! did you run 'version:init'?"
    end
  end

  def git_commit
    `git add #{changelog_file_path} #{deployment_file_path} #{version_file_path}`
    puts `git commit -m "bump version"`
  end

  desc 'Initialize Versioning - Create Changelog and Deployment Files'
  task init: :environment do
    create_file_with_content(deployment_file_path, "") unless File.exist?(deployment_file_path)
    create_file_with_content(changelog_file_path, "# Changelog #{application_name}") unless File.exist?(changelog_file_path)
  end

  desc 'Bump version'
  task bump: :environment do
    ensure_version_defined

    new_version = ENV['VERSION']

    unless new_version.present?
      STDERR.puts 'usage: rake version:bump VERSION=<NEW VERSION>'
      exit 1
    end

    change_version(new_version)
  end

  desc 'Bump to next patch version'
  task bump_patch: :environment do
    ensure_version_defined
    old_version = Rails.application.class::VERSION
    new_version_patch = old_version.split(".").last.to_i + 1
    new_version = old_version.split(".")[0..1].push(new_version_patch).join(".")

    change_version(new_version)
  end

  desc 'Bump to next minor version'
  task bump_minor: :environment do
    ensure_version_defined
    old_version = Rails.application.class::VERSION
    major, minor = old_version.split(".")[0..1]
    new_version = [major, minor.to_i + 1, 0].join(".")

    change_version(new_version)
  end

  desc 'Bump to next patch version and commit'
  task bump_patch_commit: [:bump_patch] do
    git_commit
  end

  desc 'Bump to next minor version and commit'
  task bump_minor_commit: [:bump_minor] do
    git_commit
  end

  desc 'Show version'
  task show: :environment do
    ensure_version_defined
    puts Rails.application.class::VERSION
  end
end
