defmodule Lexer do
  def scan_words(words) do
    IO.puts("\nLexing the program")
    listado=prelex_tokens(words,1)
    |>IO.inspect(label: "lexer")
    if Enum.any?(listado,fn x->
      case x do
        {:error,_}->
          true
        _->
          false
      end
    end)do
      List.last(listado)
    else
      listado
    end
  end

  def get_constant(program) do
    cif=program
    case Regex.run(~r/^\d+/, program) do
      [value] ->
        {{:constant, String.to_integer(value)}, String.trim_leading(program, value)}

      program->
        if program != " " && program !="\r\n" do
        {:error, "Token not valid: #{cif}"}
        end
    end
  end
  def prelex_tokens([token|others],num) do
    case others do
      []->
        if token=="\r\n"do
        []
        else
          lex_raw_tokens(token, num)
        end
      _->
          if token !="\r\n" do
          final=lex_raw_tokens(token,num)
          Enum.concat(final,prelex_tokens(others,num))
          else
            final=[]
            Enum.concat(final,prelex_tokens(others,num+1))
          end
    end
  end

  def lex_raw_tokens(program,num)  do

    {token, rest} =
      case program do
        "{" <> rest ->
          {:open_brace, rest}

        "}" <> rest ->
          {:close_brace, rest}

        "(" <> rest ->
          {:open_paren, rest}

        ")" <> rest ->
          {:close_paren, rest}

        ";" <> rest ->
          {:semicolon, rest}

        "return" <> rest ->
          {:return_keyword, rest}

        "int" <> rest ->
          {:int_keyword, rest}

        "main" <> rest ->
          {:main_keyword, rest}
         "&&"<>rest->
          {:and_comparation,rest}
        "||"<>rest->
          {:or_comparation,rest}
        "=="<>rest->
           {:equal_comparation,rest}
        "!="<>rest->
          {:notEqual_comparation,rest}
          "<="<>rest->
            {:lessEqual_comparation,rest}
        "<"<>rest->
          {:less_comparation,rest}
         ">="<>rest->
            {:greateEqual_comparation,rest}
       ">"<>rest->
           {:greate_comparation,rest}
        "-"<> rest->
          {:negation_operation,rest}
        "~"<> rest ->
          {:bitwise_operation,rest}
        "!"<> rest ->
          {:negation_logical,rest}
        "+"<>rest->
           {:plus_operation,rest}
        "*"<>rest->
          {:multiplication_operation,rest}
        "/"<>rest->
          {:divition_operation,rest}

        rest ->
          get_constant(rest)

      end

    if token != :error do
      if rest != ""do
      remaining_tokens = lex_raw_tokens(rest,num)
      [{token,num} | remaining_tokens]
      else
        [{token,num}]
      end

    else
      [{:error,rest,num}]
    end
  end


end
