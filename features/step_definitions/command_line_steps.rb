# Just a spot check that a rails project was generated successfully.
# The exact files being check could be tuned better.
Then /^a rails application named "([^"]*)" should exist$/ do |app_name|
  self.project_name = app_name
  check_directory_presence [project_name], true
  expect_project_directories %w{ app config db }
  expect_project_files %w{script/rails Gemfile }
end

Given /^a rails application named "([^"]*)" exists$/ do |name|
  create_rails_project(name)
end

When /^I create a new BrowserCMS project named "([^"]*)"$/ do |name|
  self.project_name = name
  cmd = "bcms new #{project_name} --skip-bundle"
  run_simple(unescape(cmd), false)
end
When /^I create a module named "([^"]*)"$/ do |name|
  self.project_name = name
  cmd = "bcms module #{project_name} --skip-bundle"
  run_simple(unescape(cmd), false)
end
Then /^a rails engine named "([^"]*)" should exist$/ do |engine_name|
  check_directory_presence [engine_name], true
  expect_project_directories %w{ app config lib }
  expect_project_files ["script/rails", "Gemfile", "#{engine_name}.gemspec"]
end

When /^BrowserCMS should be added the \.gemspec file$/ do
  check_file_content("#{project_name}/#{project_name}.gemspec", "s.add_dependency \"browsercms\", \"~> #{Cms::VERSION}\"", true)
end

Then /^BrowserCMS should be installed in the project$/ do
  # This is a not a really complete check but it at least verifies the generator completes.
  check_file_content('config/initializers/browsercms.rb', 'Cms.table_prefix = "cms_"', true)
  check_file_content('config/routes.rb', 'mount_browsercms', true)
end

Then /^a demo project named "([^"]*)" should be created$/ do |project|
  check_directory_presence [project], true
  cd project
  expected_files = %W{
      public/themes/blue_steel/images/logo.jpg
      public/themes/blue_steel/images/splash.jpg
      public/themes/blue_steel/stylesheets/style.css
      lib/tasks/demo_site.rake
      db/demo_site_seeds.rb
  }
  check_file_presence expected_files, true
end

Given /^a BrowserCMS project named "([^"]*)" exists$/ do |project_name|

  unless File.exists?("#{@scratch_dir}/#{project_name}")
    old_dirs = @dirs
    @dirs = [@scratch_dir]
    create_bcms_project("petstore")
    @dirs = old_dirs
  end
  from = File.absolute_path("#{@scratch_dir}/#{project_name}")
  to = File.absolute_path("#{@aruba_dir}/#{project_name}")
  FileUtils.mkdir_p(@aruba_dir)
  FileUtils.cp_r(from, to)

  self.project_name = project_name
end

When /^I run `([^`]*)` in the project$/ do |cmd|
  cd(project_name)
  run_simple(unescape(cmd), false)
  cd("..")
end

Then /^a project file named "([^"]*)" should contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(prefix_project_name_to(file), partial_content, true)
end

Then /^a project file named "([^"]*)" should not contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(prefix_project_name_to(file), partial_content, false)
end

When /^I cd into the project "([^"]*)"$/ do |project|
  cd project
  self.project_name = project
end

When /^a migration named "([^"]*)" should contain:$/ do |file, partial_content|
  migration = find_migration_with_name(file)
  check_file_content(migration, partial_content, true)
end

# A table of string values to check
When /^a migration named "([^"]*)" should contain the following:$/ do |file, table|
  migration = find_migration_with_name(file)
  table.rows.each do |row|
    check_file_content(migration, row.first, true)
  end
end

Then /^it should seed the BrowserCMS database$/ do
  assert_partial_output "YOUR CMS username/password is: cmsadmin/cmsadmin", all_output
end

When /^it should seed the demo data$/ do
  assert_partial_output  "Cms::PagePartial(:_header)", all_output
  # This output is ugly, but it verifies that seed data completely runs
end

When /^the file "([^"]*)" should contain:$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

When /^the correct version of Rails should be added to the Gemfile$/ do
  check_file_content("#{project_name}/Gemfile", "gem 'rails', '#{Rails::VERSION::STRING}'", true)
end

When /^BrowserCMS should be added the Gemfile$/ do
  check_file_content("#{project_name}/Gemfile", 'gem "browsercms"', true)
end