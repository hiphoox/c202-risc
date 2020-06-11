defmodule Sanitizer do
  def sanitize_source(file_content) do
    Regex.split(~r/\s+/, file_content, include_captures: true)
    |>Enum.map( fn x->  Regex.split(~R/\r\n/, x, include_captures: true) end)
    |>Enum.concat()
    |>Enum.reject(fn(x)-> x==" "||x=="" end)
  end
end
