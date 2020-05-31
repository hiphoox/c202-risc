defmodule NameGenerator do
  def generateLabelEnd(name,num,id) do
    send(id,{:label,name<>"_#{num}"})##manda etiqueta
    receive do
      {:next, _} ->
          generateLabelEnd(name, num+1, id)
      {:end, _}->
        IO.puts("Acabe");
    end
  end

end
