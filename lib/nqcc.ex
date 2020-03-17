defmodule Nqcc do
  @moduledoc """
  Documentation for Nqcc.
  """
  @commands %{
    "h" => "Prints this help",
    "a" => "Prints the .ams file",
    "t" => "Prints the AST",
    "l" => "Prints the list with atmos of the text",
    "s" => ""
  }

  def main(args) do
    res= parse_args(args)
     process_file(res)
  end

  def parse_args(args) do
    OptionParser.parse(args, switches: [h: :boolean, a: :boolean])
    |>IO.inspect(label: "\nSanitizer ouput")
    |>Tuple.to_list()
    |>hd
    |>IO.inspect(label: "\nSanitizer ouput")
    |>Enum.map(fn (x)-> process_args(x) end)
    OptionParser.parse(args, switches: [h: :boolean, a: :boolean])

  end

  defp process_args({:h ,true}) do
    print_help_message()
  end
  defp process_args({:a ,true})do
      IO.puts("Se debe de imprimir a")
  end
  defp process_args([l: true])do
      IO.puts("Se imprimio l")
  end
  defp process_file({{tupa}, _, _})do
    IO.inspect(tupa,label: "\nSanitizer ouput")
  end

  defp process_file({_, [file_name], _}) do
    compile_file(file_name)
  end

  defp compile_file(file_path) do
    IO.puts("Compiling file: " <> file_path)
    assembly_path = String.replace_trailing(file_path, ".c", ".s")

    File.read!(file_path)
    |> Sanitizer.sanitize_source()
    |> IO.inspect(label: "\nSanitizer ouput")
    |> Lexer.scan_words()
    |> IO.inspect(label: "\nLexer ouput")
    |> Parser.parse_program()
    |> IO.inspect(label: "\nParser ouput")
    |> CodeGenerator.generate_code()
    |> Linker.generate_binary(assembly_path)
  end

  defp print_help_message do
    IO.puts("\nnqcc --help file_name \n")

    IO.puts("\nThe compiler supports following options:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end
end
