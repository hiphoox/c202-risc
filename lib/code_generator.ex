defmodule CodeGenerator do

  def generate_code(ast) do
    IO.puts("Generating assembler")
    cid=spawn(NameGenerator,:generateLabelEnd,["end",0,self()])
    post_order(ast,cid)
    send(cid,{:end,"end"})
  end

  def post_order(node,cid) do
    case node do
      nil ->
        nil

      ast_node ->
        receive do
          {:label, value} ->
            IO.puts(value)
            # code
        end
        send(cid, {:next, "Sigue"})

        code_snippet = post_order(ast_node.left_node,cid)
        # TODO: Falta terminar de implementar cuando el arbol tiene mas ramas
        code_snippet2=post_order(ast_node.right_node,cid)
        if(code_snippet2==nil)do
        emit_code(ast_node.node_name, code_snippet, ast_node.value)
        else
        emit_code(ast_node.node_name,code_snippet,code_snippet2,ast_node.value)
        end;
    end
  end

  def emit_code(:program, code_snippet, _) do
    """
        .section        .text
        .p2align        4, 0x90
    """ <>
      code_snippet
  end

  def emit_code(:function, code_snippet, :main) do
    """
        .globl  _main         ## -- Begin function main
    _main:                    ## @main
    """ <>
      code_snippet
  end

  def emit_code(:return, code_snippet, _) do
    code_snippet<>"""

        movl    %ebx, %eax
        ret
    """
  end
  def emit_code(:unitary_expression,code_snippet,:negation_operation) do
    code_snippet<>"""

    neg %ebx
    """
  end
  def emit_code(:unitary_expression,code_snippet,:bitwise_operation) do
    code_snippet<>"""

    not %ebx
    """
  end
  def emit_code(:unitary_expression,code_snippet,:negation_logical)do
   code_snippet<>"
    movl $0,%eax
    cmpl %eax,%ebx
    movl $0,%ebx
    sete %dl"
  end
  #el registro ebx se utilizara para almacenar los datos y hacer operaciones unitarias sobre el
  def emit_code(:constant, _code_snippet, value) do
    "movl $#{value},%ebx"
  end
  def emit_code(:binary_operation,code_snippet,code_snippet2,:plus_operation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %edx
    addl %edx,%ebx
    "

  end
  def emit_code(:binary_operation,code_snippet,code_snippet2,:negation_operation)do
    code_snippet2<>"
    neg %ebx
    push %ebx
    "<> code_snippet<>"
    pop %edx
    addl %edx,%ebx"


  end
  def emit_code(:binary_operation,code_snippet,code_snippet2,:multiplication_operation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    imul %ebx
    movl %eax,%ebx
    "

  end
  def emit_code(:binary_operation,code_snippet,code_snippet2,:divition_operation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cdq
    idivl %ebx
    movl %eax,%ebx
    "

  end
end
