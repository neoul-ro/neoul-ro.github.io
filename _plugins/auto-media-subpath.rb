# _plugins/auto_media_subpath.rb
Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  cats = (post.data['categories'] || []).join("/")
  slug = post.basename_without_ext
  subpath = "/media/#{cats}/#{slug}"
  post.data['media_subpath'] = subpath
end