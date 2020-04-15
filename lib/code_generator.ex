defmodule CodeGenerator do
  def generate_code(ast) do
    code = post_order(ast)
    IO.puts("\nCode Generator output:")
    IO.puts(code)
    code
  end

  def post_order(node) do
    case node do
      nil ->
        nil

      ast_node ->
        code_snippet = post_order(ast_node.left_node)
        # TODO: Falta terminar de implementar cuando el arbol tiene mas ramas
        post_order(ast_node.right_node)
        emit_code(ast_node.node_name, code_snippet, ast_node.value)
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

        movl    %edx, %eax
        ret
    """
  end
  def emit_code(:unitary_expression,code_snippet,:negation_operation) do
    code_snippet<>"""

    neg %edx
    """
  end
  def emit_code(:unitary_expression,code_snippet,:bitwise_operation) do
    code_snippet<>"""

      not %edx
    """
  end

  #el registro edx se utilizara para almacenar los datos y hacer operaciones unitarias sobre el
  def emit_code(:constant, _code_snippet, value) do
    " movl $#{value},%edx"
  end
end
