defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  setup_all do
    {:ok,
     tokens: [
       {:int_keyword,1},
       {:main_keyword,1},
       {:open_paren,1},
       {:close_paren,1},
       {:open_brace,1},
       {:return_keyword,2},
       {{:constant, 2},2},
       {:semicolon,2},
       {:close_brace,3}
     ]}
  end

  # tests to pass, con modificaciones para la tercera entrega
  test "return 2", state do
    assert Lexer.scan_words(["int", "main(){","\r\n", "return", "2;","\r\n","}"]) == state[:tokens]
  end

  test "return 0", state do
    s_code = ["int", "main(){","\r\n", "return", "0;","\r\n","}"]

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {{:constant, 0},2} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "multi_digit", state do
    s_code = ["int", "main(){","\r\n", "return", "100;","\r\n","}"]

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {{:constant, 100},2} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "new_lines" do
    s_code = ["int","\r\n","main","\r\n","(","\r\n",")","\r\n","{","\r\n","return","\r\n", "100","\r\n",";","\r\n","}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,2},
      {:open_paren,3},
      {:close_paren,4},
      {:open_brace,5},
      {:return_keyword,6},
      {{:constant, 100},7},
      {:semicolon,8},
      {:close_brace,9}
    ]

  end

  test "no_newlines" do
    s_code = ["int","main(){return2;}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,1},
      {{:constant, 2},1},
      {:semicolon,1},
      {:close_brace,1}
    ]
  end

  test "spaces" do
    s_code = ["int","main(",")","{","return","2",";}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,1},
      {{:constant, 2},1},
      {:semicolon,1},
      {:close_brace,1}
    ]
  end

  test "elements separated just by spaces" do
    assert Lexer.scan_words(["int", "main(){return", "2;}"]) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,1},
      {{:constant, 2},1},
      {:semicolon,1},
      {:close_brace,1}
    ]
  end

  test "function name separated of function body", state do
    assert Lexer.scan_words(["int", "main(){","\r\n", "return", "2;","\r\n","}"]) == state[:tokens]
  end

  test "everything is separated" do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "2", ";", "}"]) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,1},
      {{:constant, 2},1},
      {:semicolon,1},
      {:close_brace,1}
    ]
  end
  #nuevas pruebas entrega 1
  test "corchetes separados" do
    assert Lexer.scan_words(["intmain(", ")","\r\n", "{return2;}"]) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,2},
      {:return_keyword,2},
      {{:constant, 2},2},
      {:semicolon,2},
      {:close_brace,2}
    ]

  end
  test "todo junto" do
    assert Lexer.scan_words(["intmain(){return2;}"]) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,1},
      {{:constant, 2},1},
      {:semicolon,1},
      {:close_brace,1}
    ]
  end
  test "input lines of space" do
    s_code = ["\r\n","\r\n","\r\n","\r\n","\r\n","intmain(){","\r\n","return2;}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,6},
      {:main_keyword,6},
      {:open_paren,6},
      {:close_paren,6},
      {:open_brace,6},
      {:return_keyword,7},
      {{:constant, 2},7},
      {:semicolon,7},
      {:close_brace,7}
    ]
  end
  test "output lines of space" do
    s_code = ["intmain(){","\r\n","return2;}","\r\n","\r\n","\r\n","\r\n","\r\n"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {{:constant, 2},2},
      {:semicolon,2},
      {:close_brace,2}
    ]

  end
  #Nuevas pruebas entrega 2
  test "negation operational"do
    s_code = ["int","main(){","\r\n","return","-2;","\r\n","}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:negation_operation,2},
      {{:constant, 2},2},
      {:semicolon,2},
      {:close_brace,3}
    ]

    end
  test "bitwise operation"do
    s_code = ["int","main(){","\r\n","return","~2;","\r\n","}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:bitwise_operation,2},
      {{:constant, 2},2},
      {:semicolon,2},
      {:close_brace,3}
    ]
  end
  test "negation logical"do
    s_code = ["int","main(){","\r\n","return","!2;","\r\n","}"]
    assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:negation_logical,2},
      {{:constant, 2},2},
      {:semicolon,2},
      {:close_brace,3}
    ]

  end
  test "BO & NO"do
  s_code = ["int","main(){","\r\n","return","~-2;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {:bitwise_operation,2},
    {:negation_operation,2},
    {{:constant, 2},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
  end
   test "Multi digit negation"do
  s_code = ["int","main(){","\r\n","return","~-1000;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {:bitwise_operation,2},
    {:negation_operation,2},
    {{:constant, 1000},2},
    {:semicolon,2},
    {:close_brace,3}
  ]

  end
  test "NL & BO"do
  s_code = ["int","main(){","\r\n","return","!~1000;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {:negation_logical,2},
    {:bitwise_operation,2},
    {{:constant, 1000},2},
    {:semicolon,2},
    {:close_brace,3}
  ]

  end
test "NL & NO"do
  s_code = ["int","main(){","\r\n","return","!-1000;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:negation_logical,2},
      {:negation_operation,2},
      {{:constant, 1000},2},
      {:semicolon,2},
      {:close_brace,3}
    ]

  end
test "Doble Negation "do
  s_code = ["int","main(){","\r\n","return","--1000;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:negation_operation,2},
      {:negation_operation,2},
      {{:constant, 1000},2},
      {:semicolon,2},
      {:close_brace,3}
    ]
 end
 test "Doble Negation Logical" do
  s_code = ["int","main(){","\r\n","return","!!100;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
    [
      {:int_keyword,1},
      {:main_keyword,1},
      {:open_paren,1},
      {:close_paren,1},
      {:open_brace,1},
      {:return_keyword,2},
      {:negation_logical,2},
      {:negation_logical,2},
      {{:constant, 100},2},
      {:semicolon,2},
      {:close_brace,3}
    ]

  end
  test "Doble Bitwise Operation "do
    s_code = ["int","main(){","\r\n","return","~~100;","\r\n","}"]
    assert Lexer.scan_words(s_code) ==
    [
       {:int_keyword,1},
       {:main_keyword,1},
       {:open_paren,1},
       {:close_paren,1},
       {:open_brace,1},
       {:return_keyword,2},
       {:bitwise_operation,2},
       {:bitwise_operation,2},
       {{:constant, 100},2},
       {:semicolon,2},
       {:close_brace,3}
     ]
    end
test "Multiple Negation "do
  s_code = ["int","main(){","\r\n","return","!~-!~-100;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {:negation_logical,2},
    {:bitwise_operation,2},
    {:negation_operation,2},
    {:negation_logical,2},
    {:bitwise_operation,2},
    {:negation_operation,2},
    {{:constant, 100},2},
    {:semicolon,2},
    {:close_brace,3}
  ]

end
#Nuevas pruebas entrega 3
test "Plus operation" do
  s_code = ["int","main(){","\r\n","return","2+3+4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:plus_operation,2},
    {{:constant, 3},2},
    {:plus_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi negation operational" do
  s_code = ["int","main(){","\r\n","return","2-3-4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:negation_operation,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi multiplication" do
  s_code = ["int","main(){","\r\n","return","2*3*4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:multiplication_operation,2},
    {{:constant, 3},2},
    {:multiplication_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi divition" do
  s_code = ["int","main(){","\r\n","return","2/3/4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:divition_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "plus & negation" do
  s_code = ["int","main(){","\r\n","return","2-3+4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:negation_operation,2},
    {{:constant, 3},2},
    {:plus_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "plus & multiplication" do
  s_code = ["int","main(){","\r\n","return","2+3*4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:plus_operation,2},
    {{:constant, 3},2},
    {:multiplication_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "plus & divition" do
  s_code = ["int","main(){","\r\n","return","2/3+4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:plus_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multiplication & divition" do
  s_code = ["int","main(){","\r\n","return","2*3/4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:multiplication_operation,2},
    {{:constant, 3},2},
    {:divition_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multiplication & negation" do
  s_code = ["int","main(){","\r\n","return","2*3-4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:multiplication_operation,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "divition & negation" do
  s_code = ["int","main(){","\r\n","return","2/3-4;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi operation for 3" do
  s_code = ["int","main(){","\r\n","return","2/3-4*5;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:multiplication_operation,2},
    {{:constant, 5},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi operation for 4" do
  s_code = ["int","main(){","\r\n","return","2/3-4*5+6;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:multiplication_operation,2},
    {{:constant, 5},2},
    {:plus_operation,2},
    {{:constant, 6},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multi operation for 3 with paren" do
  s_code = ["int","main(){","\r\n","return","(2/3)(-4*5)+6;","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {:open_paren,2},
    {{:constant, 2},2},
    {:divition_operation,2},
    {{:constant, 3},2},
    {:close_paren,2},
    {:open_paren,2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:multiplication_operation,2},
    {{:constant, 5},2},
    {:close_paren,2},
    {:plus_operation,2},
    {{:constant, 6},2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
test "multiplication & negation with paren" do
  s_code = ["int","main(){","\r\n","return","2*(3-4);","\r\n","}"]
  assert Lexer.scan_words(s_code) ==
  [
    {:int_keyword,1},
    {:main_keyword,1},
    {:open_paren,1},
    {:close_paren,1},
    {:open_brace,1},
    {:return_keyword,2},
    {{:constant, 2},2},
    {:multiplication_operation,2},
    {:open_paren,2},
    {{:constant, 3},2},
    {:negation_operation,2},
    {{:constant, 4},2},
    {:close_paren,2},
    {:semicolon,2},
    {:close_brace,3}
  ]
end
# tests to fail
  test "wrong case" do
    s_code = ["int","main(){","\r\n","RETURN","2;","\r\n","}"]
    assert Lexer.scan_words(s_code) == {:error, "Token not valid: RETURN in line 2"}
  end
end
