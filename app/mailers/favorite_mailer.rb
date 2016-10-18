class FavoriteMailer < ApplicationMailer

  default from: "stephanieyarboro@gmail.com"

  def new_comment(user, post, comment)

    # set 3 diff headers to enable [conversation threading] in diff email clients
    headers["Message-ID"] = "<comments/#{comment.id}@your-app-name.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@your-app-name.example>"
    headers["References"] = "<post/#{post.id}@your-app-name.example>"

    @user = user
    @post = post
    @comment = comment

    # mail (method) takes hash of mail-relevant information (subject, to: address, from: address [using default for checkpoint-44favorites], and any copy/blind-copy information
    # after taking hash of items above, prepares email to be sent
    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
