defmodule Nqcc do
  @moduledoc """
  Documentation for Nqcc.
  """
  @commands %{
    "h" => "Prints this help",
    "a" => "Prints the .ams file",
    "t" => "Prints the AST",
    "l" => "Prints the list with atmos of the text",
    "s" => "Prints the file become to String"
  }

  def main(args) do
    res= parse_args(args)
    if elem(res,1) != [] do
      process_file(res)
      end
  end

  def parse_args(args) do
    opcion=OptionParser.parse(args, switches: [h: :boolean, a: :boolean, t: :boolean, l: :boolean, s: :boolean])
    opcion
    |>Tuple.to_list()
    |>hd
    |>Enum.map(fn (x)->if x=={:h,true}do process_args(x) end end)
    opcion
  end

  defp process_args({:h ,true}) do
    print_help_message()
  end
  defp process_args({:a ,true})do
      IO.puts("Se debe de imprimir a")
  end
  defp process_args({:t ,true})do
      IO.puts("Se debe de imprimir AST")
  end
  defp process_args({:l ,true})do
      IO.puts("Se debe de imprimir Lexer")
  end
  defp process_args({:s ,true})do
      IO.puts("Se debe de imprimir string")
  end

  defp process_file({accesos, [file_name], _}) do
    compile_file(file_name,accesos)
  end

  defp compile_file(file_path,accesos) do
    IO.puts("Compiling file: " <> file_path)
    assembly_path = String.replace_trailing(file_path, ".c", ".s")
    line = Line.line_code(File.read!(file_path))

    path=File.read!(file_path)
    sanitizado=Sanitizer.sanitize_source(path)
    if Enum.any?(accesos,fn(x)->x == {:s,true} end)do
      IO.inspect(sanitizado, label: "\nSanitizer ouput")
    end
    lexado=Lexer.scan_words(sanitizado)
    if Enum.any?(accesos,fn(x)->x == {:l,true} end)do
      IO.inspect(lexado, label: "\nLexer ouput")
    end
    parseado=Parser.parse_program(lexado,line)
    if Enum.any?(accesos,fn(x)->x == {:t,true} end)do
      IO.inspect(parseado, label: "\nParcer ouput")
    end
    generado=CodeGenerator.generate_code(parseado)
    if Enum.any?(accesos,fn(x)->x == {:a,true} end)do
    IO.inspect(generado, label: "\nCode Generator ouput")
    end
    generado
    |> Linker.generate_binary(assembly_path)
  end

  defp print_help_message do
    IO.puts("\nnqcc --help file_name \n")

    IO.puts("\nThe compiler supports following options:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end
end
