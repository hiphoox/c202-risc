defmodule Manager_error do
  def verify(tupla) do
    case tupla do
      {:error,message}->
        IO.puts("Error:"<>message)
        System.halt(0)
        _->
          tupla
        end
  end
end
