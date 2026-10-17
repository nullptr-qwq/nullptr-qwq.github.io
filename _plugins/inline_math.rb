require "cgi"

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  math = []

  doc.content = doc.content.gsub(
    /(?<!\\)(?<!\$)\$(?!\$)([^\n$]+?)(?<!\\)\$(?!\$)/
  ) do
    id = math.length
    math << $&
    "INLINE_MATH_PROTECT_#{id}_END"
  end

  doc.data["_inline_math"] = math
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  math = doc.data["_inline_math"]
  next unless math

  math.each_with_index do |expr, i|
    doc.output.gsub!(
      "INLINE_MATH_PROTECT_#{i}_END",
      CGI.escapeHTML(expr)
    )
  end
end
