module Authentication
  module Providers
    # Twitter authentication provider, uses omniauth-twitter as backend
    class Twitter < Provider
      OFFICIAL_NAME = "Twitter".freeze
      CREATED_AT_FIELD = "twitter_created_at".freeze
      USERNAME_FIELD = "twitter_username".freeze

      def new_user_data
        name = raw_info.name.presence || info.name
        remote_profile_image_url = info.image.to_s.gsub("_normal", "")

        {
          email: info.email.to_s,
          name: name,
          remote_profile_image_url: remote_profile_image_url,
          twitter_created_at: raw_info.created_at,
          twitter_followers_count: raw_info.followers_count.to_i,
          twitter_following_count: raw_info.friends_count.to_i,
          twitter_username: info.nickname
        }
      end

      def existing_user_data
        {
          twitter_created_at: raw_info.created_at,
          twitter_followers_count: raw_info.followers_count.to_i,
          twitter_following_count: raw_info.friends_count.to_i,
          twitter_username: info.nickname
        }
      end

      def self.official_name
        OFFICIAL_NAME
      end

      protected

      def cleanup_payload(auth_payload)
        auth_payload.tap do |auth|
          # Twitter sends the server side access token keys in the payload
          # for each authentication. We definitely do not want to store those
          auth.extra.delete("access_token")
        end
      end
    end
  end
end
