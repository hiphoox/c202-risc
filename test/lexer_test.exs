defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  setup_all do
    {:ok,
     tokens: [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       {:constant, 2},
       :semicolon,
       :close_brace
     ]}
  end

  # tests to pass
  test "return 2", state do
    code = """
      int main() {
        return 2;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "return 0", state do
    code = """
      int main() {
        return 0;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {:constant, 0} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "multi_digit", state do
    code = """
      int main() {
        return 100;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 6, fn _ -> {:constant, 100} end)
    assert Lexer.scan_words(s_code) == expected_result
  end

  test "new_lines", state do
    code = """
    int
    main
    (
    )
    {
    return
    2
    ;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "no_newlines", state do
    code = """
    int main(){return 2;}
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "spaces", state do
    code = """
    int   main    (  )  {   return  2 ; }
    """

    s_code = Sanitizer.sanitize_source(code)

    assert Lexer.scan_words(s_code) == state[:tokens]
  end

  test "elements separated just by spaces", state do
    assert Lexer.scan_words(["int", "main(){return", "2;}"]) == state[:tokens]
  end

  test "function name separated of function body", state do
    assert Lexer.scan_words(["int", "main()", "{return", "2;}"]) == state[:tokens]
  end

  test "everything is separated", state do
    assert Lexer.scan_words(["int", "main", "(", ")", "{", "return", "2", ";", "}"]) ==
             state[:tokens]
  end
  #nuevas test
  test "corchetes separados", state do
    code = """
    intmain(  )
    {return  2;}
    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end
  test "todo junto", state do
    code = """
    intmain(){return2;}
    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end
  test "input lines of space", state do
    code = """





    intmain(){
      return2;}
    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end
  test "output lines of space", state do
    code = """
    intmain(){
      return2;}






    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) == state[:tokens]
  end
  #Entrega_2
  test "negation operational"do
    code ="""
    int main(){
      return -2;
    }
    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) ==
    [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      :negation_operation,
      {:constant, 2},
      :semicolon,
      :close_brace
    ]
    end
  test "bitwise operation"do
    code ="""
    int main(){
     return ~2;
    }
    """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) ==
    [
    :int_keyword,
    :main_keyword,
    :open_paren,
    :close_paren,
    :open_brace,
    :return_keyword,
    :bitwise_operation,
    {:constant, 2},
    :semicolon,
    :close_brace
    ]
  end
  test "negation logical"do
    code ="""
    int main(){
    return !2;
    }
    """
    s_code = Sanitizer.sanitize_source(code)
  assert Lexer.scan_words(s_code) ==
    [
    :int_keyword,
    :main_keyword,
    :open_paren,
    :close_paren,
    :open_brace,
    :return_keyword,
    :negation_logical,
    {:constant, 2},
    :semicolon,
    :close_brace
    ]
  end
  test "BO & NO"do
    code ="""
      int main(){
      return ~-2;
      }
      """
  s_code = Sanitizer.sanitize_source(code)
  assert Lexer.scan_words(s_code) ==
   [
    :int_keyword,
    :main_keyword,
    :open_paren,
    :close_paren,
    :open_brace,
    :return_keyword,
    :bitwise_operation,
    :negation_operation,
    {:constant, 2},
    :semicolon,
    :close_brace
    ]
  end
   test "Multi digit negation"do
   code ="""
     int main(){
      return ~-1000;
     }
     """
     s_code = Sanitizer.sanitize_source(code)
     assert Lexer.scan_words(s_code) ==
    [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      :bitwise_operation,
      :negation_operation,
      {:constant, 1000},
      :semicolon,
      :close_brace
    ]
  end
  test "NL & BO"do
  code =
  """
    int main(){
     return !~1000;
      }
  """
s_code = Sanitizer.sanitize_source(code)
assert Lexer.scan_words(s_code) ==
     [
      :int_keyword,
      :main_keyword,
      :open_paren,
      :close_paren,
      :open_brace,
      :return_keyword,
      :negation_logical,
      :bitwise_operation,
      {:constant, 1000},
      :semicolon,
      :close_brace
      ]
  end
test "NL & NO"do
code ="""
    int main(){
    return !-100;
     }
    """
    s_code = Sanitizer.sanitize_source(code)
 assert Lexer.scan_words(s_code) ==
    [
    :int_keyword,
    :main_keyword,
    :open_paren,
    :close_paren,
    :open_brace,
    :return_keyword,
    :negation_logical,
    :negation_operation,
    {:constant, 100},
    :semicolon,
    :close_brace
    ]
  end
test "Doble Negation "do
 code ="""
  int main(){
  return --100;
  }
  """
 s_code = Sanitizer.sanitize_source(code)
 assert Lexer.scan_words(s_code) ==
    [
    :int_keyword,
    :main_keyword,
    :open_paren,
    :close_paren,
    :open_brace,
    :return_keyword,
    :negation_operation,
    :negation_operation,
    {:constant, 100},
    :semicolon,
    :close_brace
    ]
 end
 test "Doble Negation Logical "do
  code ="""
   int main(){
   return !!100;
   }
   """
  s_code = Sanitizer.sanitize_source(code)
  assert Lexer.scan_words(s_code) ==
     [
     :int_keyword,
     :main_keyword,
     :open_paren,
     :close_paren,
     :open_brace,
     :return_keyword,
     :negation_logical,
     :negation_logical,
     {:constant, 100},
     :semicolon,
     :close_brace
     ]
  end
  test "Doble Bitwise Operation "do
    code ="""
     int main(){
     return ~~100;
     }
     """
    s_code = Sanitizer.sanitize_source(code)
    assert Lexer.scan_words(s_code) ==
       [
       :int_keyword,
       :main_keyword,
       :open_paren,
       :close_paren,
       :open_brace,
       :return_keyword,
       :bitwise_operation,
       :bitwise_operation,
       {:constant, 100},
       :semicolon,
       :close_brace
       ]
    end
test "Multiple Negation "do
code ="""
      int main(){
      return !~-!~-100;
      }
      """
s_code = Sanitizer.sanitize_source(code)
assert Lexer.scan_words(s_code) ==
  [
  :int_keyword,
  :main_keyword,
  :open_paren,
  :close_paren,
  :open_brace,
  :return_keyword,
  :negation_logical,
  :bitwise_operation,
  :negation_operation,
  :negation_logical,
  :bitwise_operation,
  :negation_operation,
  {:constant, 100},
  :semicolon,
  :close_brace
  ]
end




  # tests to fail
  test "wrong case", state do
    code = """
    int main() {
      RETURN 2;
    }
    """

    s_code = Sanitizer.sanitize_source(code)

    expected_result = List.update_at(state[:tokens], 5, fn _ -> :error end)
    assert Lexer.scan_words(s_code) == expected_result
  end
end
