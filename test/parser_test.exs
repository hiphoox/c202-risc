defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  #Nuevas Test del parser entrega 1 con modificaciones respecto a entrega 3
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
  #Nuevas pruebas entrega 2 con modificaciones respecto a entrega 3
  test "parser negation operational"do
    code = ["int","main(){","\r\n","return","-2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :unitary_expression,
            right_node: nil,
            value: :negation_operation
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
  test "parser bitwise operational"do
    code = ["int","main(){","\r\n","return","~2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :unitary_expression,
            right_node: nil,
            value: :bitwise_operation
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
  test "parser negation logical"do
    code = ["int","main(){","\r\n","return","!2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    assert Parser.parse_program(s_code) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :unitary_expression,
            right_node: nil,
            value: :negation_logical
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
#Nuevas pruebas entrega 3
test "Plus operation parser" do
  code = ["int","main(){","\r\n","return","2+3+4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :plus_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :plus_operation
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
test "negation operation parser" do
  code = ["int","main(){","\r\n","return","2-3-4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :negation_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :negation_operation
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
test "multiplication operation parser" do
  code = ["int","main(){","\r\n","return","2*3*4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :multiplication_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :multiplication_operation
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
test "divition operation parser" do
  code = ["int","main(){","\r\n","return","2/3/4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :divition_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :divition_operation
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
test "multi operation plus & negation" do
  code = ["int","main(){","\r\n","return","2+3-4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :plus_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :negation_operation
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
test "multi operation multiplication & divition" do
  code = ["int","main(){","\r\n","return","2*3/4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :multiplication_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :divition_operation
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
test "multi operation paren for 3" do
  code = ["int","main(){","\r\n","return","(2*3)/4;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  assert Parser.parse_program(s_code) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            node_name: :binary_operation,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :multiplication_operation
          },
          node_name: :binary_operation,
          right_node: %AST{
            left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 4
            },
          value: :divition_operation
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
