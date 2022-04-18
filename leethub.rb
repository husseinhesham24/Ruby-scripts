#!/usr/bin/env ruby

require 'fileutils'
require 'httparty'
require 'json'
require 'git'

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
  
  while(true)
    url = "https://leetcode.com/api/submissions/?offset=#{offset}&limit=20"
    headers = {
      cookie: 'NEW_PROBLEMLIST_PAGE=1; _ga=GA1.2.1508281977.1650292683; _gid=GA1.2.961240261.1650292683; c_a_u="c2l2eA==:1ngSWc:sJr67v_0SqRSUMoTFt_gVHK2i2s"; csrftoken=0obm3DiT2AEz5ZmSRRfr2u7PDww5UwsbCsXYT0BVaYs9qybKtz4XBdQUqvKaarcd; messages="d8007e75663a05e3cdaed889c404012673a1212b$[[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]\054[\"__json_message\"\0540\05425\054\"You have signed out.\"]\054[\"__json_message\"\0540\05425\054\"Successfully signed in as sivx.\"]]"; LEETCODE_SESSION=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfYXV0aF91c2VyX2lkIjoiMTkwNzE5MiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6ImNmODYwM2I4MDQ2MWNjOTQwNzMzNTYyMjEzNzYwOGYzODE1OTkxMjIiLCJpZCI6MTkwNzE5MiwiZW1haWwiOiJodXNzZWluaGVzaGFtMjRAZ21haWwuY29tIiwidXNlcm5hbWUiOiJzaXZ4IiwidXNlcl9zbHVnIjoic2l2eCIsImF2YXRhciI6Imh0dHBzOi8vYXNzZXRzLmxlZXRjb2RlLmNvbS91c2Vycy9zaXZ4L2F2YXRhcl8xNjIzNzAyNTc5LnBuZyIsInJlZnJlc2hlZF9hdCI6MTY1MDMxNDE4MCwiaXAiOiIxNTYuMjE4LjExOS4yMzgiLCJpZGVudGl0eSI6IjE5MjI0MWQ1ZjE0N2JkYzc2N2ViMzYzZjExMTU5MTAzIiwic2Vzc2lvbl9pZCI6MjA2MTQzODYsIl9zZXNzaW9uX2V4cGlyeSI6MTIwOTYwMH0.x8TAsg7ukf0DwARRayqYEmLTxk0b3Gf0lkx1vjpxoK8'
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
      if (p["status_display"]=="Accepted")
        create_file("/home/husssein/personal/problem-solving", "Leetcode/#{p["title"]}", "cpp")
        File.write("Leetcode/#{p["title"]}.cpp", p["code"])
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
Dir.chdir("/home/husssein/personal")
g = Git.clone("https://github.com/husseinhesham24/problem-solving.git", "problem-solving")


get_submmissions

g.add 
g.commit_all('leethub script')
g.push

FileUtils.rm_rf("/home/husssein/personal/problem-solving")
