Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  content = doc.content

  # 保存行内数学公式
  math = []

  content = content.gsub(/(?<!\\)(?<!\$)\$(?!\$)(.+?)(?<!\\)(?<!\$)\$(?!\$)/m) do
    id = math.length
    math << $&
    "<span class=\"math-protect\" data-math-id=\"#{id}\"></span>"
  end

  doc.content = content
  doc.data["_inline_math"] = math
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  math = doc.data["_inline_math"]
  next unless math

  math.each_with_index do |expr, i|
    doc.output.gsub!(
      "<span class=\"math-protect\" data-math-id=\"#{i}\"></span>",
      expr
    )
  end
end
