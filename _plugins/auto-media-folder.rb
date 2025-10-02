require "fileutils"
require "set"

module AutoMediaFolder
  IGNORED_FILES = %w[.DS_Store Thumbs.db].freeze

  module_function

  def registry
    @registry ||= Set.new
  end

  def remember(path)
    registry << File.expand_path(path)
  end

  def cleanup(site)
    media_root = File.join(site.source, "media")
    return unless Dir.exist?(media_root)

    protected = registry.dup
    protected << File.expand_path(media_root)

    Dir.glob(File.join(media_root, "**", "*"), File::FNM_DOTMATCH)
      .select { |p| File.directory?(p) }
      .sort_by { |p| p.length }
      .reverse_each do |directory|
        basename = File.basename(directory)
        next if [".", ".."].include?(basename)

        abs = File.expand_path(directory)
        next if protected.include?(abs)

        begin
          children = Dir.children(directory)
        rescue Errno::ENOENT
          next
        end

        IGNORED_FILES.each do |ignored|
          next unless children.delete(ignored)

          ignored_path = File.join(directory, ignored)
          File.delete(ignored_path) if File.file?(ignored_path)
        end

        next unless children.empty?

        Dir.rmdir(directory)
        Jekyll.logger.info "[auto_media_folder]", "Removed empty media folder: #{directory}"
      end

    registry.clear
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  categories = Array(post.data['categories']).map(&:to_s).reject(&:empty?)
  slug = post.basename_without_ext

  segments = ["media"] + categories + [slug]
  subpath = File.join(*segments)
  fullpath = File.join(post.site.source, subpath)

  AutoMediaFolder.remember(fullpath)

  unless Dir.exist?(fullpath)
    FileUtils.mkdir_p(fullpath)
    Jekyll.logger.info "[auto_media_folder]", "Created media folder: #{fullpath}"
  end

  post.data['media_subpath'] = "/" + subpath
end

Jekyll::Hooks.register :site, :post_write do |site|
  AutoMediaFolder.cleanup(site)
end
