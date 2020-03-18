defmodule Parser do
  def parse_program(token_list,list_number) do
    function = parse_function(token_list,list_number)
    case function do
      {{:error, error_message}, _rest} ->
        {:error, error_message}

      {function_node, rest} ->
        if rest == [] do
          %AST{node_name: :program, left_node: function_node}
        else
          {:error, "Error: there are more elements after function end"}
        end
    end
  end

  def parse_function([next_token | rest],code_line) do
    #Funcion de manejo de errores
    error = fn(cadena,code) ->
      max = length(code)
      range = 0..max-1
      error_tupla = Enum.map(range,fn (x)-> if(String.jaro_distance(Enum.at(code,x),cadena) >= 0.5, do: {:error,"Error in the line #{x+1}"} )end)
      firts_tupla = Enum.split_with(error_tupla, fn x -> x != nil end)
      tupla = elem(firts_tupla,0)
      Enum.at(tupla,0)
      end
    if next_token == :int_keyword do
      [next_token | rest] = rest

      if next_token == :main_keyword do
        [next_token | rest] = rest

        if next_token == :open_paren do
          [next_token | rest] = rest

          if next_token == :close_paren do
            [next_token | rest] = rest

            if next_token == :open_brace do
              statement = parse_statement(rest,code_line)

              case statement do
                {{:error, error_message}, rest} ->
                  {{:error, error_message}, rest}

                {statement_node, [next_token | rest]} ->
                  if next_token == :close_brace do
                    {%AST{node_name: :function, value: :main, left_node: statement_node}, rest}
                  else
                    {error.("}",code_line), rest}
                  end
              end
            else
              error.("{",code_line)
            end
          else
            error.(")",code_line)
          end
        else
          error.("(",code_line)
        end
      else
        error.("main",code_line)
      end
    else
      error.("int",code_line)
    end
  end

  def parse_statement([next_token | rest],code_number) do
    #Funcion de manejo de errores
    error = fn(cadena,code) ->
      max = length(code)
      range = 0..max-1
      error_tupla = Enum.map(range,fn (x)-> if(String.jaro_distance(Enum.at(code,x),cadena) >= 0.5, do: {:error,"Error in the line #{x+1}"} )end)
      firts_tupla = Enum.split_with(error_tupla, fn x -> x != nil end)
      tupla = elem(firts_tupla,0)
      Enum.at(tupla,0)
      end
    if next_token == :return_keyword do
      expression = parse_expression(rest,code_number)

      case expression do
        {{:error, error_message}, rest} ->
          {{:error, error_message}, rest}

        {exp_node, [next_token | rest]} ->
          if next_token == :semicolon do
            {%AST{node_name: :return, left_node: exp_node}, rest}
          else
            {{:error, "#{error.(";",code_number)} semicolon missed after constant to finish return statement"}, rest}
          end
      end
    else
      {error.("return",code_number), rest}
    end
  end

  def parse_expression([next_token | rest],code_error) do
    error = fn(cadena,code) ->
      max = length(code)
      range = 0..max-1
      error_tupla = Enum.map(range,fn (x)-> if(String.jaro_distance(Enum.at(code,x),cadena) >= 0.5, do: {:error,"Error in the line #{x+2}, #{x}, o #{x+1} constant value does not exist or misplaced"} )end)
      firts_tupla = Enum.split_with(error_tupla, fn x -> x != nil end)
      tupla = elem(firts_tupla,0)
      Enum.at(tupla,0)
      end
    case next_token do
      {:constant, value} -> {%AST{node_name: :constant, value: value}, rest}
      _ -> {error.(";",code_error), rest}
    end
  end
end
