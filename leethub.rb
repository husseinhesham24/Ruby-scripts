#!/usr/bin/env ruby

require 'fileutils'
require 'httparty'
require 'json'
require 'git'

#please change the paths to yours

#folder which download inside your repo 
@path = "/folder/folder/folder" 

#your repo folder path
@repo_path = "/folder/folder/folder/<repo-name>"

#folder name which download inside your solution files 
@sub_repo_path = "<folder-name>" 

#your repo name
@repo_name = "repo-name" 

#repo link to clone it
@repo_url = "<repo-link>" 


def create_file(path, path2, extension)
  
  Dir.chdir(path)
  dir = File.dirname(path2) 
  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  path2 << ".#{extension}"
  File.new(path2, 'w')

end


def get_submmissions
  offset = 0
  problems = []

  while(true)
    url = "https://leetcode.com/api/submissions/?offset=#{offset}&limit=20"
    headers = {
      cookie: 'your-leetcode-token'
    }

    response = HTTParty.get(url, headers: headers)

    if response.code != 200
      flag = false
      puts "request failed"
      exit
    end

    puts "Downloading data ...."
    data = JSON.parse(response.body)

    puts "Creating files ...."
    data["submissions_dump"].each do |p|
      if (!problems.any?{|h| h[:title]==p['title']} && p["status_display"]=="Accepted")
        problems.append({title: p['title'], code: p['code']})
        create_file(@repo_path, "#{@sub_repo_path}/#{p["title"]}", "cpp")
        File.write("#{@sub_repo_path}/#{p["title"]}.cpp", p["code"])
      end 
    end

    if(!data["has_next"])
      break
    end

    offset= offset + 20
    sleep 1
  end
end



puts "clone repo ...."
Dir.chdir(@path)

if Dir.exist?(@repo_name)
  FileUtils.rm_rf(@repo_path)
end

g = Git.clone(@repo_url, @repo_name)


get_submmissions

g.add
g.commit_all('leethub script')
g.push

FileUtils.rm_rf(@repo_path)
