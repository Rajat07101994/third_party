require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets'
require 'nokogiri'
require 'json'


class FinalGmail
  CLIENT_ID =  '395881522941-u743v9in3447plpar5t2clh3niokp7rn.apps.googleusercontent.com' #ENV['GOOGLE_CLIENT_ID']
	CLIENT_SECRET = '6GAhYiGe7cZVsmm-QarWju6b' #ENV['GOOGLE_CLIENT_SECRET']
  GMAIL = Google::Apis::GmailV1::GmailService

  def initialize(oauth_token, refresh_token, uid)
    byebug
    @client = Google::APIClient::ClientSecrets.new({"web" => { access_token: oauth_token, refresh_token: refresh_token, client_id: CLIENT_ID, client_secret: CLIENT_SECRET}})
    @gmail = GMAIL.new
    @gmail.authorization = @client.to_authorization
    @uid = uid
  end
  def search(type,text)
    byebug
      if(type.blank?)
          thread_id=@gmail.list_user_messages(@uid, q:"#{text}").to_h[:messages]
      else
        hash = {subject: 'Subject', to: 'To', from: 'From', cc: 'Cc' }
        thread_id=@gmail.list_user_messages(@uid, q:"#{hash[type.downcase.to_sym]}:#{text}").to_h[:messages]
      end
      thread_id = thread_id.map{|x| x[:thread_id]}
      thread_id = thread_id.uniq
      thread_id
  end 
  def thread(thread_id)
    page=@gmail.get_user_thread(@uid,'15dabfb0f3a96a16',fields:"messages")
    byebug
    packet = []
    messages = page.to_h[:messages]
    messages.each do |message|
      begin
      message_data = {}
      message_data[:history_id] = message[:history_id]
      message_data[:id] = message[:id]
      message_data[:label_ids] = message[:label_ids]
      message_data[:To] = message[:payload][:headers].select{|a| a[:name]=="To"}.extract_options![:value]
      message_data[:From] = message[:payload][:headers].select{|a| a[:name]=="From"}.extract_options![:value]
      message_data[:Subject] = message[:payload][:headers].select{|a| a[:name]=="Subject"}.extract_options![:value]
      message_data[:Date] = message[:payload][:headers].select{|a| a[:name]=="Date"}.extract_options![:value]
      message_data[:Body] =Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0].delete("\r\n")
      rescue Exception => e
          puts "error occured #{e}"
          byebug
          puts "#{Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0]}"
      end
      packet<< message_data
      packet
    end  
      byebug
      packet
  end
  def thread_data(thread_id)
      byebug
      email_data = []
      thread_id.each do |thread|
        byebug
        page=@gmail.get_user_thread(@uid,thread[:thread_id],fields:"messages")
        packet = []
        messages = page.to_h[:messages]
        messages.each do |message|
          begin
          message_data = {}
          message_data[:history_id] = message[:history_id]
          message_data[:id] = message[:id]
          message_data[:label_ids] = message[:label_ids]
          message_data[:To] = message[:payload][:headers].select{|a| a[:name]=="To"}.extract_options![:value]
          message_data[:From] = message[:payload][:headers].select{|a| a[:name]=="From"}.extract_options![:value]
          message_data[:Subject] = message[:payload][:headers].select{|a| a[:name]=="Subject"}.extract_options![:value]
          message_data[:Date] = message[:payload][:headers].select{|a| a[:name]=="Date"}.extract_options![:value]
          message_data[:Body] =Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0].delete("\r\n")
          rescue Exception => e
              puts "error occured #{e}"
              byebug
              puts "#{Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0]}"
          end
          packet<< message_data
        #email_data[0].fetch(:Date)
      end
      email_data<<packet
    end
    byebug
      email_data
  end
end
