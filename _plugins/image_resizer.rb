require 'mini_magick'

module Jekyll
  module ResizeFilter
    def resize(input, width, height)
      if width.nil? || height.nil? then return input end
      if width == "auto" and height == "auto" then return input end

      size = "#{width}x#{height}"
      if width == "auto"
        size = "x#{height}"
      elsif height == "auto"
        size = width
      end

      site = @context.registers[:site]

      # find file in src or dest
      source = File.join(site.source, input)
      source = File.join(site.dest, input) unless File.exists?(source)
      image = ::MiniMagick::Image.open(source)

      digest = Digest::MD5.hexdigest(image.to_blob).slice!(0..5)
      targetName = output_name(input, width, height, digest).gsub(/^\//, "")
      target = File.join(site.dest, targetName)

      if site.keep_files.index(targetName) != nil
        return "/#{targetName}"
      end

      FileUtils.mkdir_p(File.dirname(target))
      site.keep_files << targetName
      image.combine_options do |b|
        b.resize "#{size}^"
        b.gravity "center"
        b.crop "#{size}+0+0"
      end
      image.write target

      "/#{targetName}"
    end

    private
    def output_name(input, width, height, digest)
      dir = File.dirname(input)
      extension = File.extname(input)
      basename = File.basename(input, extension)

      File.join(dir, "#{basename}-#{width}x#{height}-#{digest}#{extension}")
    end

  end
end

Liquid::Template.register_filter(Jekyll::ResizeFilter)
