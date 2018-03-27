ENV['GOOGLE_CLIENT_ID'] = '15627086266-cinmktkmj02agftt7dgv27ab4gai6sbt.apps.googleusercontent.com'
ENV['GOOGLE_CLIENT_SECRET'] = '6GAhYiGe7cZVsmm-QarWju6b'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '59440291d2afb9089731', '4d94c86dd6bea0a039d18752c37d594c79fbe639'
  #with refresh token code is change only in initializers file
  provider :google_oauth2,'395881522941-u743v9in3447plpar5t2clh3niokp7rn.apps.googleusercontent.com','6GAhYiGe7cZVsmm-QarWju6b', {  verify_iss: 'false',grant_type: 'authorization_code',access_type: 'offline',prompt: 'consent' ,scope: ['https://www.googleapis.com/auth/calendar','https://mail.google.com/', 'https://www.googleapis.com/auth/userinfo.email','email'],client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}

#without refresh token
  #provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
  #{
    #scope: ['https://mail.google.com/', 'https://www.googleapis.com/auth/userinfo.email']
  #}
end