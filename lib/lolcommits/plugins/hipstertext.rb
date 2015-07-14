# -*- encoding : utf-8 -*-
module Lolcommits
  class Hipstertext < Plugin
    COLORS = ["#2e4970", "#674685", "#ca242f", "#1e7882", "#2884ae", "#4ba000", "#187296", "#7e231f", "#017d9f", "#e52d7b", "#0f5eaa", "#e40087", "#5566ac", "#ed8833", "#f8991c", "#408c93", "#ba9109"]

    # enabled by default (if no configuration exists)
    def enabled?
      !configured? || super
    end

    def run
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

      message = clean_msg(runner.message).upcase
      sha = runner.sha

      image = MiniMagick::Image.open(runner.main_image)

      image.combine_options do |c|
        c.fill COLORS.sample
        c.colorize 50
      end

      image.combine_options do |c|
        c.pointsize(runner.animate? ? '15' : '30')
        c.size '540x380'
        c.font font_location_1
        c.fill 'white'
        c.gravity 'Center'
        c.draw "text 0,0 \"#{message}\""
      end

      image.combine_options do |c|
        c.gravity 'South'
        c.fill 'white'
        c.pointsize(runner.animate? ? '10' : '20')
        c.font font_location_2
        c.draw "text 0,20 \"#{sha}\""
      end

      debug "Writing changed file to #{runner.main_image}"
      image.write runner.main_image
    end

    def self.name
      'hipstertext'
    end

    def self.runner_order
      :process
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
