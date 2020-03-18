defmodule Line do
  def line_code(file_content) do
    trimmed_content = String.trim(file_content)
    String.split(trimmed_content,"\n")
  end
end
