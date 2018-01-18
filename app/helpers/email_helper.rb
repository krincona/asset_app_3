module EmailHelper
  def email_image_tag(image, **options)
    attachments[image] = File.read(Rails.root.join("public/images/#{image}"))
    image_tag attachments[image].url, **options
  end
end
