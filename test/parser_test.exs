defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  #Nuevas Test del parser entrega 1
  test "parser return 2" do
    s_code = Lexer.scan_words(["int", "main(){","\r\n", "return", "2;","\r\n","}"])
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 2
          },
          node_name: :return,
          right_node: nil,
          value: nil
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }

  end
  test "parser return multidigit" do
    code = ["int", "main(){","\r\n", "return", "100;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 100
          },
          node_name: :return,
          right_node: nil,
          value: nil
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }

  end
  test "parser return 0" do
    code = ["int", "main(){","\r\n", "return", "0;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0
          },
          node_name: :return,
          right_node: nil,
          value: nil
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }

  end


end
