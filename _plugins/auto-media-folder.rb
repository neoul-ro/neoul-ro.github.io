# _plugins/auto_media_folder.rb
Jekyll::Hooks.register :posts, :pre_render do |post|
  cats = (post.data['categories'] || []).join("/")
  slug = post.basename_without_ext

  subpath = File.join("media", cats, slug)
  fullpath = File.join(post.site.source, subpath)

  unless Dir.exist?(fullpath)
    FileUtils.mkdir_p(fullpath)
    Jekyll.logger.info "[auto_media_folder]", "Created media folder: #{fullpath}"
  end

  post.data['media_subpath'] = "/" + subpath
end
