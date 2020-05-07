defmodule Parser do
  def parse_program(token_list,list_number) do
    IO.puts("\nThe program is parsing")
    function = parse_function(token_list,list_number)
    case function do
      {{:error, error_message}, _rest} ->
        {:error, error_message}
        {:error,error_message}->
          {:error, error_message}
      {function_node, rest} ->
        if rest == [] do
          %AST{node_name: :program, left_node: function_node}
        else
          {:error, "Error: there are more elements after function end"}
        end
    end
  end

  @spec parse_function(nonempty_maybe_improper_list, any) :: any
  def parse_function([next_token | rest],code_line) do
    #Funcion de manejo de errores
    error = fn(cadena,code) ->
      max = length(code)
      range = 0..max-1
      error_tupla = Enum.map(range,fn (x)-> if(String.jaro_distance(Enum.at(code,x),cadena) >= 0.5, do: {:error,"Error in the line #{x+1}: #{cadena} is missing"} )end)
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

  def parse_statement([next_token | rest],code_line) do
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
      expression = parse_expression(rest,code_line)

      case expression do
        {{:error, error_message}, rest} ->
          {{:error, error_message}, rest}

        {exp_node, [next_token | rest]} ->
          if next_token == :semicolon do
            {%AST{node_name: :return, left_node: exp_node}, rest}
          else
            {{:error, "#{error.(";",code_line)} semicolon missed after constant to finish return statement"} , rest}
          end
      end
    else
      {error.("return",code_line), rest}
    end
  end

  def parse_expression([next_token | rest],code_number) do
    error = fn(cadena,code) ->
      max = length(code)
      range = 0..max-1
      error_tupla = Enum.map(range,fn (x)-> if(String.jaro_distance(Enum.at(code,x),cadena) >= 0.5, do: {:error,"Error in the line #{x+2}, #{x}, o #{x+1} constant value does not exist or misplaced"} )end)
      firts_tupla = Enum.split_with(error_tupla, fn x -> x != nil end)
      tupla = elem(firts_tupla,0)
      Enum.at(tupla,0)
      end
    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=parse_term([next_token | rest], code_number,error)
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
          recall_expression(resto, {nodo, resto}, code_number, error)
      end

  end

  def recall_expression([next_token2|rest2],{nodo,resto},code_number,error) do
    if(next_token2==:plus_operation||next_token2==:negation_operation) do##si es + o - hay que buscar al otro termino
    [next_token3|rest3]=rest2##pasamos al siguiente token
    {nodo2,resto2}=parse_term([next_token3 | rest3], code_number,error)##se busca al otro termino
    case nodo2 do ##verificar si existio error en el segundo termino
      {:error,_}->##si existio error devolver el error
          {nodo2,resto2}
          _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
          resultado={%AST{node_name: :binary_operation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
          recall_expression(resto2, resultado, code_number, error)##verificamos que no existan mas operadores
    end
  else##si no existe + o - retorna el nodo y el resto como lo recibio
  {nodo,resto}
  end


   end
  def parse_factor([next_token | rest],code_number,error)do
      if(next_token==:negation_operation|| next_token==:bitwise_operation||next_token==:negation_logical)do##verifica que sea op unitario
      [next_token2|rest2]=rest##si fue initario pasar al sig token en rest
      {nodo,resto}=parse_factor([next_token2|rest2],code_number,error)##volvemos a llamar a factor
      case nodo do
        {:error,_}->##error se devuelve
            {nodo,resto}
            _->##si se pudo hacer formar  nodo
              {%AST{node_name: :unitary_expression,value: next_token,left_node: nodo},resto}
      end
      else ##si no lo es pasar a sig condiciones
        if(next_token==:open_paren)do
          [next_token2|rest2]=rest## pasamos al siguiente token
          {nodo,resto}=parse_expression([next_token2|rest2],code_number)##buscamos expresion
          case nodo do
            {:error,_}->##error se devuelve
                {nodo,resto}
            _->##si se pudo hacer verificar que se cierra parentesis
                  [next_token3|rest3]=resto##no posicionamos en el sig token
                  IO.puts("next token3")
                  IO.inspect(next_token3)
                  if (next_token3==:close_paren) do##si se cierro parentesis entonces regresamos el formamos el nodo
                    {nodo,rest3}
                  else
                    {{:error,"falta )"},rest3};
                  end

          end
        else ##si no es unitario o nohabre parentesisi significa que es un valor o caracter invalido
          case next_token do
            {:constant, value} -> {%AST{node_name: :constant, value: value}, rest}
            _ -> {{:error,"valor invalido#{next_token}"}, rest}
            end
        end
      end

  end

  def parse_term([next_token | rest],code_number,error)do
    {nodo,resto}=parse_factor([next_token | rest], code_number, error)## se ejecuta al menos una vez
      case nodo do
        {:error,_}->##si existio error regresa el error
              {nodo,resto}
              _->##de otra forma pasar al siguiente token
               recall_term(resto,{nodo,resto},code_number,error)
      end
  end
def recall_term([next_token2|rest2],{nodo,resto},code_number,error) do
  if(next_token2==:multiplication_operation||next_token2==:divition_operation) do##si es + o - hay que buscar al otro termino
  [next_token3|rest3]=rest2##pasamos al siguiente token
  {nodo2,resto2}=parse_factor([next_token3 | rest3], code_number,error)##se busca al otro termino
  case nodo2 do ##verificar si existio error en el segundo termino
    {:error,_}->##si existio error devolver el error
        {nodo2,resto2}
        _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
          ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
        resultado={%AST{node_name: :binary_operation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
        recall_term(resto2, resultado, code_number, error)##verificamos que no existan mas operadores
  end
else##si no existe + o - retorna el nodo y el resto como lo recibio
{nodo,resto}
end
end
end
