defmodule CodeGeneratorTest do
  use ExUnit.Case
  doctest CodeGenerator
  #Nuevas pruebas del code generator entrega 1 con modificaciones respecto a entrega 3 y 4
  test "code generator return 2" do
    code = ["int", "main(){","\r\n", "return", "2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx    movl    %ebx, %eax\n    ret\n"
  end
  test "code generator return 0" do
    code = ["int", "main(){","\r\n", "return", "0;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $0,%ebx    movl    %ebx, %eax\n    ret\n"
  end
  test "code generator return multidigit" do
    code = ["int", "main(){","\r\n", "return", "100;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $100,%ebx    movl    %ebx, %eax\n    ret\n"
  end

  #Nuevas pruebas del code generator entrega 2 con modificaciones respecto a entrega 3 y 4
  test "code generator negation operational" do
    code = ["int", "main(){","\r\n", "return", "-2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\nneg %ebx\n    movl    %ebx, %eax\n    ret\n"
  end
  test "code generator bitwise operation" do
    code = ["int", "main(){","\r\n", "return", "~2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\nnot %ebx\n    movl    %ebx, %eax\n    ret\n"
  end
  test "code generator logical negation" do
    code = ["int", "main(){","\r\n", "return", "!2;","\r\n","}"]
    s_code = Lexer.scan_words(code)
    p_code =  Parser.parse_program(s_code)
    assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\r\n    movl $0,%eax\r\n    cmpl %eax,%ebx\r\n    movl $0,%ebx\r\n    sete %bl    movl    %ebx, %eax\n    ret\n"
  end
#Nuevas pruebas entrega 4
test "code generator and comparation" do
  code = ["int", "main(){","\r\n", "return", "2&&2;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  p_code =  Parser.parse_program(s_code)
  assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\r\n    cmpl $0, %ebx\r\n    jne _clause_0\r\n    jmp _end_0\r\n    _clause_0:\r\n    movl $2,%ebx\r\n    cmpl $0, %ebx\r\n    movl $0, %ebx\r\n    setne %bl\r\n    \r\n    _end_0:    movl    %ebx, %eax\n    ret\n"
end
test "code generator or comparation" do
  code = ["int", "main(){","\r\n", "return", "2||2;","\r\n","}"]
  s_code = Lexer.scan_words(code)
  p_code =  Parser.parse_program(s_code)
  assert CodeGenerator.generate_code(p_code) == "    .section        .text\n    .p2align        4, 0x90\n    .globl  _main         ## -- Begin function main\n_main:                    ## @main\nmovl $2,%ebx\r\n    cmpl $0, %ebx\r\n    je _clause_0\r\n    movl $1, %ebx\r\n    jmp _end_0\r\n    _clause_0:\r\n    movl $2,%ebx\r\n    cmpl $0, %ebx\r\n    movl $0, %ebx\r\n    setne %bl\r\n    \r\n    _end_0:    movl    %ebx, %eax\n    ret\n"
end

end
