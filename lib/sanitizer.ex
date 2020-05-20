defmodule Sanitizer do
  def sanitize_source(file_content) do
    trimmed_content = String.trim(file_content)

    Regex.split(~r/\s+/, trimmed_content, include_captures: true)
    |>Enum.reject(fn(x)-> x==" " end)
    |>IO.inspect()
  end
end
