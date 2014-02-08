module Jekyll
    module ShareButtonsFilter
      def share_buttons url
        full_url = @context.registers[:site].config['url'] + url

        <<-HTML
          <div class="buttons">
            <div class="fb-like"
              data-href="#{full_url}"
              data-send="true"
              data-layout="button_count"
              data-width="90"
              data-show-faces="false">
            </div>

            <a href="https://twitter.com/share"
              class="twitter-share-button"
              data-url="#{full_url}"
              data-via="twitterapi"
              data-lang="en">
            </a>

            <div class="google_plus">
              <div class="g-plusone"
                data-href="#{full_url}"
                data-size="medium"
                data-annotation="bubble">
              </div>
            </div>
          </div>
        HTML
      end
    end
  end

  Liquid::Template.register_filter Jekyll::ShareButtonsFilter