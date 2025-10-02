# _plugins/obsidian-image-converter.rb
Jekyll::Hooks.register [:pages, :posts], :pre_render do |doc|
  content = doc.content.dup  # 복사본 만들어서 수정
  content = content.gsub(/!\[\[(.*?)\]\]/) do
    filename = Regexp.last_match(1)
    "![image](#{filename})"
  end
  doc.content = content
end
