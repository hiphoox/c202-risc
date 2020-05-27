defmodule CodeGeneratorTest do
  use ExUnit.Case
  doctest CodeGenerator
  #Nuevas Test del parser entrega 1 con modificaciones respecto a entrega 3
  test "parser return 2" do
    code = ["int", "main(){","\r\n", "return", "2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\n    movl    %ebx, %eax\n    ret\n"
  end
  test "parser return 0" do
    code = ["int", "main(){","\r\n", "return", "0;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $0,%ebx\n    movl    %ebx, %eax\n    ret\n"
  end
  test "parser return multidigit" do
    code = ["int", "main(){","\r\n", "return", "100;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $100,%ebx\n    movl    %ebx, %eax\n    ret\n"
  end
  test "parser negation operational" do
    code = ["int", "main(){","\r\n", "return", "-2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\nneg %ebx\n\n    movl    %ebx, %eax\n    ret\n"
  end
  test "parser bitwise operation" do
    code = ["int", "main(){","\r\n", "return", "~2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\nnot %ebx\n\n    movl    %ebx, %eax\n    ret\n"
  end
  test "parser logical negation" do
    code = ["int", "main(){","\r\n", "return", "!2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\r\n    movl $0,%eax\r\n    cmpl %eax,%ebx\r\n    movl $0,%ebx\r\n    sete %dl\n    movl    %ebx, %eax\n    ret\n"
  end


end
