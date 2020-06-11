defmodule Manager_error do
  def verify(tupla) do
    case tupla do
      {:error,message}->
        IO.puts IO.ANSI.format([:yellow_background, :black, inspect("Error:"<>message)])
        System.halt(0)
        _->
          tupla
        end
  end
end
