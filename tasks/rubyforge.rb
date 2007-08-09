require 'rubyforge'

#-----------------------------------------------------------------------
# Documentation - pushing documentation to rubyforge
#-----------------------------------------------------------------------
namespace :doc do
    desc "Deploy the RDoc documentation to rubyforge"
    task :deploy => :rerdoc do
        sh "rsync -zav --delete #{Launchy::SPEC.local_rdoc_dir}/ #{Launchy::SPEC.remote_rdoc_location}"
    end
end

#-----------------------------------------------------------------------
# Packaging and Distribution - push to rubyforge
#-----------------------------------------------------------------------
namespace :dist do
    desc "Release files to rubyforge"
    task :release => [:clean, :package] do
        
        rubyforge = RubyForge.new
        
        # make sure this release doesn't already exist
        releases = rubyforge.autoconfig['release_ids']
        if releases.has_key?(Launchy::SPEC.name) and releases[Launchy::SPEC.name][Launchy::VERSION] then
            abort("Release #{Launchy::VERSION} already exists!")
        end
        
        config = rubyforge.userconfig
        config["release_notes"]     = Launchy::SPEC.description
        config["release_changes"]   = last_changeset
        config["Prefomatted"]       = true


        puts "Uploading to rubyforge..."
        files = FileList[File.join("pkg","#{Launchy::SPEC.name}-#{Launchy::VERSION}*.*")].to_a
        files.each do |f|
            puts "    #{f}"
        end
        rubyforge.login
        rubyforge.add_release(Launchy::SPEC.rubyforge_project, Launchy::SPEC.name, Launchy::VERSION, *files)
        puts "done."
    end
end

#-----------------------------------------------------------------------
# Announcements - Create an email text file, and post news to rubyforge
#-----------------------------------------------------------------------
def changes
    change_file = File.expand_path(File.join(File.basename(__FILE__),"..","CHANGES"))
    sections    = File.read(change_file).split(/^(?===)/)
end
def last_changeset
    changes[1]
end

def announcement
    urls    = "  #{Launchy::SPEC.homepage}"
    subject = "#{Launchy::SPEC.name} #{Launchy::VERSION} Released"
    title   = "#{Launchy::SPEC.name} version #{Launchy::VERSION} has been released."
    body    = <<BODY
#{Launchy::SPEC.description.rstrip}

{{ Changelog for Version #{Launchy::VERSION} }}

#{last_changeset.rstrip}

BODY

    return subject, title, body, urls
end

namespace :announce do
    desc "create email for ruby-talk"
    task :email do
        subject, title, body, urls = announcement

        File.open("email.txt", "w") do |mail|
            mail.puts "From: #{Launchy::SPEC.author} <#{Launchy::SPEC.email}>"
            mail.puts "To: ruby-talk@ruby-lang.org"
            mail.puts "Date: #{Time.now.rfc2822}"
            mail.puts "Subject: [ANN] #{subject}"
            mail.puts
            mail.puts title
            mail.puts
            mail.puts urls
            mail.puts 
            mail.puts body
            mail.puts 
            mail.puts urls
        end
        puts "Created the following as email.txt:"
        puts "-" * 72
        puts File.read("email.txt")
        puts "-" * 72
    end
    
    CLOBBER << "email.txt"

    desc "Post news of #{Launchy::SPEC.name} to #{Launchy::SPEC.rubyforge_project} on rubyforge"
    task :post_news do
        subject, title, body, urls = announcement
        rubyforge = RubyForge.new
        rubyforge.login
        rubyforge.post_news(Launchy::SPEC.rubyforge_project, subject, "#{title}\n\n#{urls}\n\n#{body}")
        puts "Posted to rubyforge"
    end

end
