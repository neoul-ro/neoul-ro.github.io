# Automatically derive categories from each post's directory structure when
# the front matter leaves them blank.
Jekyll::Hooks.register :posts, :post_init do |post|
  categories = post.data['categories']
  next unless categories.nil? || (categories.respond_to?(:empty?) && categories.empty?)

  relative_path = post.relative_path
  next unless relative_path

  segments = File.dirname(relative_path).split(File::SEPARATOR)
  segments.shift if segments.first == '_posts'
  segments.reject! { |segment| segment.nil? || segment.empty? || segment == '.' }
  next if segments.empty?

  post.data['categories'] = segments
end
