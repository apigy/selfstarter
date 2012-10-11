module PreorderHelper
	def like_button(width = 70, show_faces = false)
		raw "<div class=\"fb-like\" data-send=\"false\" data-width=\"#{width}\" data-layout=\"box_count\" data-show-faces=\"true\"></div>"
	end
	def pin_it_button
		image_url = URI.encode("#{request.scheme}://#{request.host}#{image_path(Settings.product_image_url)}")
		raw "<a href='http://pinterest.com/pin/create/button/?url=#{encoded_root_url}&media=#{image_url}' class='pin-it-button' count-layout='vertical'><img border='0' src='//assets.pinterest.com/images/PinExt.png' title='Pin It' /></a>"
	end
	def tweet_button
		tweet_text = "I'm #{Settings.primary_stat_verb} number #{number_with_delimiter @order.number, :delimiter => ","} #{Settings.tweet_text}!"
		raw "<a href='https://twitter.com/share?url=/' id='tweet_button' class='twitter-share-button twitter-button' data-url=#{request.scheme}//#{request.host}' data-via='#{Settings.product_name}' data-lang='en' data-count='vertical' data-text=\"#{tweet_text}\">Tweet</a>"
	end

	def encoded_root_url
		raw URI.encode "#{request.scheme}://#{request.host}/preorder"
	end
end
