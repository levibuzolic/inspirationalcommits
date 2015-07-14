# -*- encoding : utf-8 -*-
module Lolcommits
  class Inspirationaltext < Plugin
    # enabled by default (if no configuration exists)
    def enabled?
      !configured? || super
    end

    def run_postcapture
      font_location_1 = File.join(
        Configuration::LOLCOMMITS_ROOT,
        'vendor',
        'fonts',
        'Raleway-Light.ttf'
      )

      font_location_2 = File.join(
        Configuration::LOLCOMMITS_ROOT,
        'vendor',
        'fonts',
        'Raleway-Regular.ttf'
      )

      debug 'Annotating image via MiniMagick'
      image = MiniMagick::Image.open(runner.main_image)

      message = clean_msg(runner.message).upcase
      sha = runner.sha

      image.combine_options do |c|
        c.gravity 'Center'
        c.fill 'white'
        c.pointsize(runner.animate? ? '20' : '30')
        c.interline_spacing '-9'
        c.font font_location_1
        c.annotate '+0-20', message
      end

      image.combine_options do |c|
        c.gravity 'South'
        c.fill 'white'
        c.pointsize(runner.animate? ? '15' : '25')
        c.font font_location_2
        c.annotate '+0+20', sha
      end

      debug "Writing changed file to #{runner.main_image}"
      image.write runner.main_image
    end

    def self.name
      'inspirationaltext'
    end

    private

    # do whatever is required to commit message to get it clean and ready for imagemagick
    def clean_msg(text)
      wrapped_text = word_wrap text
      escape_quotes wrapped_text
      escape_ats wrapped_text
    end

    # conversion for quotation marks to avoid shell interpretation
    # does not seem to be a safe way to escape cross-platform?
    def escape_quotes(text)
      text.gsub(/"/, "''")
    end

    def escape_ats(text)
      text.gsub(/@/, '\@')
    end

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
