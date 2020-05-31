defmodule CodeGenerator do

  def generate_code(ast) do
    IO.puts("Generating assembler")
    cid=spawn(NameGenerator,:generateLabelEnd,["_clause",0,self()])
    cid2=spawn(NameGenerator,:generateLabelEnd,["_end",0,self()])
    code=post_order(ast,cid,cid2)
    send(cid,{:end,"end"})
    send(cid2,{:end,"end"})
    code
  end

  def post_order(node,cid,cid2) do
    case node do
      nil ->
        nil

      ast_node ->


        code_snippet = post_order(ast_node.left_node,cid,cid2)
        # TODO: Falta terminar de implementar cuando el arbol tiene mas ramas
        code_snippet2=post_order(ast_node.right_node,cid,cid2)
        if(code_snippet2==nil)do
        emit_code(ast_node.node_name, code_snippet, ast_node.value)
        else
          if(ast_node.value != :or_comparation && ast_node.value != :and_comparation)do
            emit_code(ast_node.node_name,code_snippet,code_snippet2,ast_node.value)
          else
            receive do
              {:label, clause}->
                receive do
                  {:label, endTag} ->
                    send(cid, {:next, "Sigue"})
                    send(cid2, {:next, "Sigue"})
                      emit_code(ast_node.node_name,code_snippet,code_snippet2,clause,endTag,ast_node.value)
                end
            end
          end

        end
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
    sete %bl"
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
  def emit_code(:binary_comparation,code_snippet,code_snippet2,:equal_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %eax,%ebx
    movl $0,%ebx
    sete %bl"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,:notEqual_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %eax,%ebx
    movl $0,%ebx
    setne %bl"
  end

  def emit_code(:binary_comparation,code_snippet,code_snippet2,:lessEqual_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %ebx,%eax
    movl $0,%ebx
    setle %bl"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,:less_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %ebx,%eax
    movl $0,%ebx
    setl %bl"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,:greateEqual_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %ebx,%eax
    movl $0,%ebx
    setge %bl"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,:greate_comparation)do
    code_snippet<>"
    push %ebx
    "<>code_snippet2<>"
    pop %eax
    cmpl %ebx,%eax
    movl $0,%ebx
    setg %bl"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,tag1,tag2,:or_comparation)do
    code_snippet<>"
    cmpl $0, %ebx
    je "<>tag1<>"
    movl $1, %ebx
    jmp "<>tag2<>"
    "<>tag1<>":
    "<>code_snippet2<>"
    cmpl $0, %ebx
    movl $0, %ebx
    setne %bl
    "<>"
    "<>tag2<>":"
  end
  def emit_code(:binary_comparation,code_snippet,code_snippet2,tag1,tag2,:and_comparation)do
    code_snippet<>"
    cmpl $0, %ebx
    jne "<>tag1<>"
    jmp "<>tag2<>"
    "<>tag1<>":
    "<>code_snippet2<>"
    cmpl $0, %ebx
    movl $0, %ebx
    setne %bl
    "<>"
    "<>tag2<>":"
  end
end
