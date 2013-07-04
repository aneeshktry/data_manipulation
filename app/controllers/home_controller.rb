class HomeController < ApplicationController
  def home
    
  end

  def extract
    puts "@"*100
    puts "#{params[:text]}"
    puts "@"*100
    require 'csv'
    source_file_path = ARGV[0]
    destination_path = ARGV[1]
    data_list = []
    data_list << ["email"]
    file = File.open(source_file_path,'r:ascii-8bit')
    if file
      file.each do |line|
        line_list = line.split(" ")
        line_list.each do |str|
          if str.strip.match(/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/)
            data_list << [str]
          end
        end
      end
      insert_into_csv(data_list,destination_path)
    end
  end

  def insert_into_csv(data_list,file_path)
    if File.exist?(file_path)
      File.delete(file_path)
    end
    CSV.open(file_path, "wb") do |csv|
      data_list.each do |data|
        csv << data
      end
    end
  end
end
