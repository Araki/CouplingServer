class ApplicationController < ActionController::Base
  # protect_from_forgery

  def push_notification(user, message)
    if Rails.env == 'production'    
      certificate = "config/cert/certificate_distribute.pem"
    else
      certificate = "config/cert/certificate.pem"
    end
    pusher = Grocer.pusher(
      certificate: certificate,
      passphrase:  "",
      port:        2195,
      retries:     3
    )

    params = {device_token: user.device_token}
    params[:alert] = message.size > 20 ? message[0..16] + '...' : message
    unread_count = user.count_unread_messages
    params[:badge] = unread_count if unread_count > 0
    
    pusher.push(Grocer::Notification.new(params))
  end  
end
