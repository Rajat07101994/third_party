require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets'
require 'nokogiri'
require 'json'


class TestGmail
  CLIENT_ID =  ENV['GOOGLE_CLIENT_ID']
	CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
  GMAIL = Google::Apis::GmailV1::GmailService

  def initialize(oauth_token, refresh_token, uid)
    byebug
    @client = Google::APIClient::ClientSecrets.new({"web" => { access_token: oauth_token, refresh_token: refresh_token, client_id: CLIENT_ID, client_secret: CLIENT_SECRET}})
    @gmail = GMAIL.new
    @gmail.authorization = @client.to_authorization
    @uid = uid
  end

  def thread(thread_id)
    # List of threads
    byebug
    threads = @gmail.list_user_threads(@uid)

    # Get 1 thread data
    thread = @gmail.get_user_thread(@uid, threads.threads.first.id)
  end
  def thread(thread_id)
    thread_id=@gmail.get_user_thread(@uid,'15dabfb0f3a96a16',fields:"messages").to_h[:messages]
    byebug
    thread_id = thread_id.map{|x| x[:thread_id]}
    thread_id = thread_id.uniq
    thread_id

  end
    def ct
      byebug
    #GET https://www.googleapis.com/gmail/v1/users/me/messages?q="in:sent after:2014/01/01 before:2014/01/30"
    @gmail.list_user_messages(@uid, q:'in:sent after:2017/10/2 and before:3/10/2017')
    @gmail.list_user_messages(@uid, q:'in:sent after:2017/08/02')
    #@gmail.get_user_message(U.uid,'15cf495944b2bcab')
    #@gmail.get_user_message(U.uid,'15da818004261758')
    #@gmail.get_user_thread(u.uid,'15dabfb0f3a96a16').to_s(get all message)
    #@gmail.get_user_thread(u.uid,'15dabfb0f3a96a16',fields:"messages")
    #page.messages.to_json.chop.to_lf
    page=@gmail.get_user_thread(@uid,'15dabfb0f3a96a16',fields:"messages")
    lss=Nokogiri::HTML(page.messages[3].to_h[:payload][:parts][1][:body][:data])
    lss.children.text
    #lss.css('span').first.text
    #lss.css('span')[1].after('div').text
    #On [a-zA-Z]{3}, [a-zA-Z]{3} \d{1,2}, \d{4} at \d{1,2}:\d{1,2} [a-zA-Z]{1}M
    #lss.text.split(">").count
    #l1.starts_with?(" wrote")

    #m=lss.text.split("wrote")[2]
  #  m=lss.text.split("wrote")[2].split("On")
  #m=lss.text.split("wrote")[1].split("On")[0].delete(":")
    #lss.css('div').css('span').text

    #lss.css('div')[2]['class']
    byebug
    # page = HTTParty.get('%{@gmail.get_user_thread(@uid,"15dabfb0f3a96a16",fields:"messages")}')
    #lss.text.split(">")[0][/On [a-zA-Z]{3}, [a-zA-Z]{3} \d{1,2}, \d{4} at \d{1,2}:\d{1,2} [a-zA-Z]{1}M/]

    end
    def final(thread_id)
      byebug
      count =0
      message = []
      email = []
      lss = []
      body =[]
      time = []
      page=@gmail.get_user_thread(@uid,'15dabfb0f3a96a16',fields:"messages")
      email_data = []
      messages = page.to_h[:messages]
      byebug
      messages.each do |message|
        byebug
        message_data = {}
        message_data[:history_id] = message[:history_id]
        message_data[:id] = message[:id]
        message_data[:label_ids] = message[:label_ids]
        message_data[:To] = message[:payload][:headers].select{|a| a[:name]=="To"}.extract_options![:value]
        message_data[:From] = message[:payload][:headers].select{|a| a[:name]=="From"}.extract_options![:value]
        message_data[:Subject] = message[:payload][:headers].select{|a| a[:name]=="Subject"}.extract_options![:value]
        message_data[:Date] = message[:payload][:headers].select{|a| a[:name]=="Date"}.extract_options![:value]
        message_data[:Body] =Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0].delete("\r\n")
        email_data << message_data
      end
      byebug
      email_data[0].fetch(:Date)
      while(count<page.messages.count)
          lss[count]=Nokogiri::HTML(page.messages[count].to_h[:payload][:parts][1][:body][:data])
          count+=1
      end
      count=0
      byebug
      while(count<lss.count)
        if(count !=0)
          email[count]= lss[count].css('span')[0].text
          time[count]= lss[count].text.split(">")[0][/On [a-zA-Z]{3}, [a-zA-Z]{3} \d{1,2}, \d{4} at \d{1,2}:\d{1,2} [a-zA-Z]{1}M/].delete(" On")
          body[count] = lss[count].text.split("On")[0].delete("\r\n")
        else
          body[count] = lss[count].text.delete("\r\n")
        end
        count+=1
      end
      byebug
      messages_count=data.split("On").count
      data=data.split("On")
      byebug
      while(count<=lss.count)
         #message[count] =
      end

    end
    def thread_data(thread_id)
        message = []
        page=@gmail.get_user_thread(@uid,'15dabfb0f3a96a16',fields:"messages")
        email_data = []
        messages = page.to_h[:messages]
        messages.each do |message|
          message_data = {}
          message_data[:history_id] = message[:history_id]
          message_data[:id] = message[:id]
          message_data[:label_ids] = message[:label_ids]
          message_data[:To] = message[:payload][:headers].select{|a| a[:name]=="To"}.extract_options![:value]
          message_data[:From] = message[:payload][:headers].select{|a| a[:name]=="From"}.extract_options![:value]
          message_data[:Subject] = message[:payload][:headers].select{|a| a[:name]=="Subject"}.extract_options![:value]
          message_data[:Date] = message[:payload][:headers].select{|a| a[:name]=="Date"}.extract_options![:value]
          message_data[:Body] =Nokogiri::HTML(message[:payload][:parts][1][:body][:data]).text.split("On")[0].delete("\r\n")
          email_data << message_data
          #email_data[0].fetch(:Date)
          email_data
        end
      end

end


# .select{|a| a[:name]=="Subject"}

# page.to_h[:messages][2][:payload][:headers].select{|a| a[:name]=="Subject"}
