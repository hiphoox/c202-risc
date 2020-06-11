defmodule Parser do
  def parse_program(token_list) do
    IO.puts("\nThe program is parsing")
    function = parse_function(token_list)
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

  def parse_function([{next_token,num} | rest]) do
    error=fn (cadena,numero) ->
          {:error," #{cadena} is missing in line #{numero}"}
    end

    if next_token == :int_keyword do
      [{next_token,num} | rest] = rest

      if next_token == :main_keyword do
        [{next_token,num} | rest] = rest

        if next_token == :open_paren do
          [{next_token,num} | rest] = rest

          if next_token == :close_paren do
            [{next_token,num} | rest] = rest

            if next_token == :open_brace do
              statement = parse_statement(rest)
              case statement do
                {{:error, error_message}, rest} ->
                  {{:error, error_message}, rest}

                {statement_node, [{next_token,num} | rest]} ->
                  if next_token == :close_brace do
                    {%AST{node_name: :function, value: :main, left_node: statement_node}, rest}
                  else
                    {error.("}",num), rest}
                  end
              end
            else
              error.("{",num)
            end
          else
            error.(")",num)
          end
        else
          error.("(",num)
        end
      else
        error.("main",num)
      end
    else
      error.("int",num)
    end
  end

  def parse_statement([{next_token,num} | rest]) do
    #Funcion de manejo de errores
    error=fn (cadena,numero) ->
      {:error," #{cadena} is missing in line #{numero}"}
  end
    if next_token == :return_keyword do
      expression = parse_expression(rest)

      case expression do
        {{:error, error_message}, rest} ->
          {{:error, error_message}, rest}

        {exp_node, [{next_token,num} | rest]} ->
          if next_token == :semicolon do
            {%AST{node_name: :return, left_node: exp_node}, rest}
          else
            {{:error, "semicolon missed to finish return statement in line #{num}"} , rest}
          end
      end
    else
      {error.("return",num), rest}
    end
  end
  def parse_expression([next_token | rest]) do

    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=and_expression([next_token | rest])
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
          recall_expression(resto, {nodo, resto})
      end

  end

  def recall_expression([{next_token2,_num}|rest2],{nodo,resto}) do
    if(next_token2==:or_comparation) do##si es || hay que buscar al otro termino
    [next_token3|rest3]=rest2##pasamos al siguiente token
    {nodo2,resto2}=and_expression([next_token3 | rest3])##se busca al otro termino
    case nodo2 do ##verificar si existio error en el segundo termino
      {:error,_}->##si existio error devolver el error
          {nodo2,resto2}
          _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
          resultado={%AST{node_name: :binary_comparation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
          recall_expression(resto2, resultado)##verificamos que no existan mas operadores
    end
  else##si no existe + o - retorna el nodo y el resto como lo recibio
  {nodo,resto}
  end
end
  def and_expression([next_token | rest]) do

    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=equality_exp([next_token | rest])
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
          recall_and(resto, {nodo, resto})
      end

  end

  def recall_and([{next_token2,_num}|rest2],{nodo,resto}) do
    if(next_token2==:and_comparation) do##si es && hay que buscar al otro termino
    [next_token3|rest3]=rest2##pasamos al siguiente token
    {nodo2,resto2}=equality_exp([next_token3 | rest3])##se busca al otro termino
    case nodo2 do ##verificar si existio error en el segundo termino
      {:error,_}->##si existio error devolver el error
          {nodo2,resto2}
          _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
          resultado={%AST{node_name: :binary_comparation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
          recall_and(resto2, resultado)##verificamos que no existan mas operadores
    end
  else##si no existe  retorna el nodo y el resto como lo recibio
  {nodo,resto}
  end
end

  def equality_exp([next_token | rest]) do
    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=relational_exp([next_token | rest])
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
              [{next_token2,_num}|rest2]=resto
           if(next_token2==:equal_comparation||next_token2==:notEqual_comparation) do##si es == o != hay que buscar al otro termino
            [next_token3|rest3]=rest2##pasamos al siguiente token
             {nodo2,resto2}=relational_exp([next_token3 | rest3])##se busca al otro termino
               case nodo2 do ##verificar si existio error en el segundo termino
                    {:error,_}->##si existio error devolver el error
                      {nodo2,resto2}
                     _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
                      {%AST{node_name: :binary_comparation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
              end
            else##si no existe retorna el nodo y el resto como lo recibio
               {nodo,resto}
            end
        end
  end
  def relational_exp([next_token | rest]) do

    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=add_expression([next_token | rest])
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
              [{next_token2,_num}|rest2]=resto
           if(next_token2==:lessEqual_comparation||next_token2==:less_comparation||next_token2== :greateEqual_comparation||next_token2== :greate_comparation) do##si es + o - hay que buscar al otro termino
            [next_token3|rest3]=rest2##pasamos al siguiente token
             {nodo2,resto2}=add_expression([next_token3 | rest3])##se busca al otro termino
               case nodo2 do ##verificar si existio error en el segundo termino
                    {:error,_}->##si existio error devolver el error
                      {nodo2,resto2}
                     _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
                      {%AST{node_name: :binary_comparation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
              end
            else##si no existe + o - retorna el nodo y el resto como lo recibio
               {nodo,resto}
            end
        end
  end
   ##-----------------------------------------------------------------------------------ya no se modifica
  def add_expression([next_token | rest]) do

    ##al menos se debe de ejecutar una vez term
    {nodo,resto}=parse_term([next_token | rest])
      case nodo do
        {:error,_}->##devuelve el error si existio
              {nodo,resto}
        _->##en otro caso
          recall_add(resto, {nodo, resto})
      end

  end

  def recall_add([{next_token2,_num}|rest2],{nodo,resto}) do
    if(next_token2==:plus_operation||next_token2==:negation_operation) do##si es + o - hay que buscar al otro termino
    [next_token3|rest3]=rest2##pasamos al siguiente token
    {nodo2,resto2}=parse_term([next_token3 | rest3])##se busca al otro termino
    case nodo2 do ##verificar si existio error en el segundo termino
      {:error,_}->##si existio error devolver el error
          {nodo2,resto2}
          _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
            ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
          resultado={%AST{node_name: :binary_operation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
          recall_add(resto2, resultado)##verificamos que no existan mas operadores
    end
  else##si no existe + o - retorna el nodo y el resto como lo recibio
  {nodo,resto}
  end


   end
  def parse_factor([{next_token,num} | rest])do
      if(next_token==:negation_operation|| next_token==:bitwise_operation||next_token==:negation_logical)do##verifica que sea op unitario
      [next_token2|rest2]=rest##si fue initario pasar al sig token en rest
      {nodo,resto}=parse_factor([next_token2|rest2])##volvemos a llamar a factor
      case nodo do
        {:error,_}->##error se devuelve
            {nodo,resto}
            _->##si se pudo hacer formar  nodo
              {%AST{node_name: :unitary_expression,value: next_token,left_node: nodo},resto}
      end
      else ##si no lo es pasar a sig condiciones
        if(next_token==:open_paren)do
          [next_token2|rest2]=rest## pasamos al siguiente token
          {nodo,resto}=relational_exp([next_token2|rest2])##buscamos expresion+++++++++++++++++++++++++++++++modificar
          case nodo do
            {:error,_}->##error se devuelve
                {nodo,resto}
            _->##si se pudo hacer verificar que se cierra parentesis
                  [{next_token3,num}|rest3]=resto##no posicionamos en el sig token
                  if (next_token3==:close_paren) do##si se cierro parentesis entonces regresamos el formamos el nodo
                    {nodo,rest3}
                  else
                    {{:error,"is missing ) in line #{num}"},rest3};
                  end

          end
        else ##si no es unitario o nohabre parentesisi significa que es un valor o caracter invalido
          case next_token do
            {:constant, value} -> {%AST{node_name: :constant, value: value}, rest}
            _ -> {{:error,"unespected character #{next_token} in line #{num}"}, rest}
            end
        end
      end

  end

  def parse_term([next_token | rest])do
    {nodo,resto}=parse_factor([next_token | rest])## se ejecuta al menos una vez
      case nodo do
        {:error,_}->##si existio error regresa el error
              {nodo,resto}
              _->##de otra forma pasar al siguiente token
               recall_term(resto,{nodo,resto})
      end
  end
def recall_term([{next_token2,_num}|rest2],{nodo,resto}) do
  if(next_token2==:multiplication_operation||next_token2==:divition_operation) do##si es + o - hay que buscar al otro termino
  [next_token3|rest3]=rest2##pasamos al siguiente token
  {nodo2,resto2}=parse_factor([next_token3 | rest3])##se busca al otro termino
  case nodo2 do ##verificar si existio error en el segundo termino
    {:error,_}->##si existio error devolver el error
        {nodo2,resto2}
        _->##si no existio error armamos la tupla con el nodo binario y el resto de tokens
          ##operacion binaria, la operacion que es, el primer termino que sacamos, el segundo termino que sacamos
        resultado={%AST{node_name: :binary_operation,value: next_token2,left_node: nodo,right_node: nodo2},resto2}
        recall_term(resto2, resultado)##verificamos que no existan mas operadores
  end
else##si no existe + o - retorna el nodo y el resto como lo recibio
{nodo,resto}
end
end
end
