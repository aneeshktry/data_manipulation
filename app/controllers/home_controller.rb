class HomeController < ApplicationController
  require 'csv'
  def home
    @text_file = Assets.new
  end

  def text_extract
    #    puts "@"*100
    file_path = "#{Rails.root}/tmp/emails/emails.csv"
    text = params[:text]
    #    puts "@"*100
    data_list = []
    data_list << ["email"]
    line_list = text.split(" ")
    line_list.each do |str|
      if str.strip.match(/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/)
        data_list << [str]
      end
    end
    insert_into_csv(data_list,file_path)
#    sleep(10)
    send_file file_path, :type=>'text/csv' if File.exist?(file_path)
    File.delete(file_path) if File.exist?(file_path)
  end

  def file_extract
    @text_file = Assets.new(:document=>params[:text][:document])
    @text_file.valid?
    puts "#{@text_file.errors.full_messages}".red
    @text_file.save
    puts "#{@text_file.document.to_s}".red
    file_path = "#{Rails.root}#{@text_file.document.to_s}"
    destination_path = "#{Rails.root}/tmp/emails/#{@text_file.document_file_name.split(".")[0..-2].join(".")}.csv"
    data_list = []
    data_list << ["email"]
    file = File.open(file_path,'r:ascii-8bit')
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
      @text_file.destroy
    end
    send_file destination_path, :type=>'text/csv' if File.exist?(destination_path)
    File.delete(destination_path) if File.exist?(destination_path)
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
#source_file_path = ARGV[0]
#    destination_path = ARGV[1]
#    data_list = []
#    data_list << ["email"]
#    file = File.open(source_file_path,'r:ascii-8bit')
#    if file
#      file.each do |line|
#        line_list = line.split(" ")
#        line_list.each do |str|
#          if str.strip.match(/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/)
#            data_list << [str]
#          end
#        end
#      end
#      insert_into_csv(data_list,destination_path)
#    end