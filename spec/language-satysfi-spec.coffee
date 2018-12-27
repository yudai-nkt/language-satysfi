describe "SATySFi grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-satysfi")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.satysfi")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.satysfi"

  it "tokenizes a comment", ->
    {tokens} = grammar.tokenizeLine("% foo")

    expect(tokens[0].value).toBe "%"
    expect(tokens[0].scopes).toEqual ["source.satysfi", "comment.line.percentage.satysfi", "punctuation.definition.comment.satysfi"]

    expect(tokens[1].value).toBe " foo"
    expect(tokens[1].scopes).toEqual ["source.satysfi", "comment.line.percentage.satysfi"]

  it "tokenizes the @require command", ->
    {tokens} = grammar.tokenizeLine("@require: pervasives")

    expect(tokens[0].value).toBe "@require"
    expect(tokens[0].scopes).toEqual ["source.satysfi", "keyword.control.header.require.satysfi"]

    expect(tokens[1].value).toBe ":"
    expect(tokens[1].scopes).toEqual ["source.satysfi", "punctuation.definition.terminator.satysfi"]

    expect(tokens[2].value).toBe " "
    expect(tokens[2].scopes).toEqual ["source.satysfi"]

    expect(tokens[3].value).toBe "pervasives"
    expect(tokens[3].scopes).toEqual ["source.satysfi", "support.class.satysfi"]

  it "tokenizes the @import command", ->
    {tokens} = grammar.tokenizeLine("@import: local")

    expect(tokens[0].value).toBe "@import"
    expect(tokens[0].scopes).toEqual ["source.satysfi", "keyword.control.header.import.satysfi"]

    expect(tokens[1].value).toBe ":"
    expect(tokens[1].scopes).toEqual ["source.satysfi", "punctuation.definition.terminator.satysfi"]

    expect(tokens[2].value).toBe " "
    expect(tokens[2].scopes).toEqual ["source.satysfi"]

    expect(tokens[3].value).toBe "local"
    expect(tokens[3].scopes).toEqual ["source.satysfi", "support.class.satysfi"]

  it "tokenizes a multi-line literal", ->
    tokens = grammar.tokenizeLines("""
      `foo
      bar`
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "`"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "punctuation.definition.string.begin.satysfi"]

    expect(tokens[0][1].value).toBe "foo"
    expect(tokens[0][1].scopes).toEqual ["source.satysfi", "string.quoted.grave-accent.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "bar"
    expect(tokens[1][0].scopes).toEqual ["source.satysfi", "string.quoted.grave-accent.satysfi"]

    expect(tokens[1][1].value).toBe "`"
    expect(tokens[1][1].scopes).toEqual ["source.satysfi", "punctuation.definition.string.end.satysfi"]

  it "tokenizes the +listing command", ->
    tokens = grammar.tokenizeLines("""
      '<
        +listing{
          *foo
            **bar
        }
      >
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "'<"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "punctuation.transition.program-to-block.begin.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "  "
    expect(tokens[1][0].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi"]

    expect(tokens[1][1].value).toBe "+listing"
    expect(tokens[1][1].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "support.function.listing.satysfi"]

    expect(tokens[1][2].value).toBe "{"
    expect(tokens[1][2].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "punctuation.definition.argument.inline.begin.satysfi"]

    # Line 2
    expect(tokens[2][0].value).toBe "    "
    expect(tokens[2][0].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi"]

    expect(tokens[2][1].value).toBe "*"
    expect(tokens[2][1].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi", "variable.unordered.list.satysfi"]

    expect(tokens[2][2].value).toBe "foo"
    expect(tokens[2][2].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi"]

    # Line 3
    expect(tokens[3][0].value).toBe "      "
    expect(tokens[3][0].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi"]

    expect(tokens[3][1].value).toBe "**"
    expect(tokens[3][1].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi", "variable.unordered.list.satysfi"]

    expect(tokens[3][2].value).toBe "bar"
    expect(tokens[3][2].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi"]

    # Line 4
    expect(tokens[4][0].value).toBe "  "
    expect(tokens[4][0].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "meta.state.inline.satysfi"]

    expect(tokens[4][1].value).toBe "}"
    expect(tokens[4][1].scopes).toEqual ["source.satysfi", "meta.state.block.satysfi", "punctuation.definition.argument.inline.end.satysfi"]

    # Line 5
    expect(tokens[5][0].value).toBe ">"
    expect(tokens[5][0].scopes).toEqual ["source.satysfi", "punctuation.transition.program-to-block.end.satysfi"]

  it "tokenizes a module definition", ->
    tokens = grammar.tokenizeLines("""
      module Foo : sig
        val bar : int
        direct \\baz : [string; inline-text] inline-cmd
      end = struct
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "module"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

    expect(tokens[0][1].value).toBe " Foo "
    expect(tokens[0][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][2].value).toBe ":"
    expect(tokens[0][2].scopes).toEqual ["source.satysfi", "punctuation.definition.type-specification.satysfi"]

    expect(tokens[0][3].value).toBe " "
    expect(tokens[0][3].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][4].value).toBe "sig"
    expect(tokens[0][4].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "  "
    expect(tokens[1][0].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][1].value).toBe "val"
    expect(tokens[1][1].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

    expect(tokens[1][2].value).toBe " bar "
    expect(tokens[1][2].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][3].value).toBe ":"
    expect(tokens[1][3].scopes).toEqual ["source.satysfi", "punctuation.definition.type-specification.satysfi"]

    expect(tokens[1][4].value).toBe " "
    expect(tokens[1][4].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][5].value).toBe "int"
    expect(tokens[1][5].scopes).toEqual ["source.satysfi", "storage.type.primitive.satysfi"]

    # Line 2
    expect(tokens[2][0].value).toBe "  "
    expect(tokens[2][0].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][1].value).toBe "direct"
    expect(tokens[2][1].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

    expect(tokens[2][2].value).toBe " "
    expect(tokens[2][2].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][3].value).toBe "\\baz"
    expect(tokens[2][3].scopes).toEqual ["source.satysfi", "support.function.command.inline.satysfi"]

    expect(tokens[2][4].value).toBe " "
    expect(tokens[2][4].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][5].value).toBe ":"
    expect(tokens[2][5].scopes).toEqual ["source.satysfi", "punctuation.definition.type-specification.satysfi"]

    expect(tokens[2][6].value).toBe " "
    expect(tokens[2][6].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][7].value).toBe "["
    expect(tokens[2][7].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi", "punctuation.definition.list.begin.satysfi"]

    expect(tokens[2][8].value).toBe "string"
    expect(tokens[2][8].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi", "storage.type.primitive.satysfi"]

    expect(tokens[2][9].value).toBe ";"
    expect(tokens[2][9].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi", "punctuation.definition.list.delimiter.satysfi"]

    expect(tokens[2][10].value).toBe " "
    expect(tokens[2][10].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi"]

    expect(tokens[2][11].value).toBe "inline-text"
    expect(tokens[2][11].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi", "storage.type.primitive.satysfi"]

    expect(tokens[2][12].value).toBe "]"
    expect(tokens[2][12].scopes).toEqual ["source.satysfi", "meta.structure.list.satysfi", "punctuation.definition.list.end.satysfi"]

    expect(tokens[2][13].value).toBe " "
    expect(tokens[2][13].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][14].value).toBe "inline-cmd"
    expect(tokens[2][14].scopes).toEqual ["source.satysfi", "keyword.other.type.builtin-command.satysfi"]

    # Line 3
    expect(tokens[3][0].value).toBe "end"
    expect(tokens[3][0].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

    expect(tokens[3][1].value).toBe " "
    expect(tokens[3][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[3][2].value).toBe "="
    expect(tokens[3][2].scopes).toEqual ["source.satysfi", "keyword.operator.assignment.satysfi"]

    expect(tokens[3][3].value).toBe " "
    expect(tokens[3][3].scopes).toEqual ["source.satysfi"]

    expect(tokens[3][4].value).toBe "struct"
    expect(tokens[3][4].scopes).toEqual ["source.satysfi", "keyword.other.module.satysfi"]

  it "tokenizes basic let bindings", ->
    tokens = grammar.tokenizeLines("""
      let foo = 1 * 2 + 3
      let bar = 42. +. 0.3
      let baz = 334inch *' 2.
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "let"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "keyword.other.let.satysfi"]

    expect(tokens[0][1].value).toBe " foo "
    expect(tokens[0][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][2].value).toBe "="
    expect(tokens[0][2].scopes).toEqual ["source.satysfi", "keyword.operator.assignment.satysfi"]

    expect(tokens[0][3].value).toBe " "
    expect(tokens[0][3].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][4].value).toBe "1"
    expect(tokens[0][4].scopes).toEqual ["source.satysfi", "constant.numeric.integer.decimal.satysfi"]

    expect(tokens[0][5].value).toBe " "
    expect(tokens[0][5].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][6].value).toBe "*"
    expect(tokens[0][6].scopes).toEqual ["source.satysfi", "keyword.operator.arithmetic.int.satysfi"]

    expect(tokens[0][7].value).toBe " "
    expect(tokens[0][7].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][8].value).toBe "2"
    expect(tokens[0][8].scopes).toEqual ["source.satysfi", "constant.numeric.integer.decimal.satysfi"]

    expect(tokens[0][9].value).toBe " "
    expect(tokens[0][9].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][10].value).toBe "+"
    expect(tokens[0][10].scopes).toEqual ["source.satysfi", "keyword.operator.arithmetic.int.satysfi"]

    expect(tokens[0][11].value).toBe " "
    expect(tokens[0][11].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][12].value).toBe "3"
    expect(tokens[0][12].scopes).toEqual ["source.satysfi", "constant.numeric.integer.decimal.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "let"
    expect(tokens[1][0].scopes).toEqual ["source.satysfi", "keyword.other.let.satysfi"]

    expect(tokens[1][1].value).toBe " bar "
    expect(tokens[1][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][2].value).toBe "="
    expect(tokens[1][2].scopes).toEqual ["source.satysfi", "keyword.operator.assignment.satysfi"]

    expect(tokens[1][3].value).toBe " "
    expect(tokens[1][3].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][4].value).toBe "42."
    expect(tokens[1][4].scopes).toEqual ["source.satysfi", "constant.numeric.float.satysfi"]

    expect(tokens[1][5].value).toBe " "
    expect(tokens[1][5].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][6].value).toBe "+."
    expect(tokens[1][6].scopes).toEqual ["source.satysfi", "keyword.operator.arithmetic.float.satysfi"]

    expect(tokens[1][7].value).toBe " "
    expect(tokens[1][7].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][8].value).toBe "0.3"
    expect(tokens[1][8].scopes).toEqual ["source.satysfi", "constant.numeric.float.satysfi"]

    # Line 2
    expect(tokens[2][0].value).toBe "let"
    expect(tokens[2][0].scopes).toEqual ["source.satysfi", "keyword.other.let.satysfi"]

    expect(tokens[2][1].value).toBe " baz "
    expect(tokens[2][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][2].value).toBe "="
    expect(tokens[2][2].scopes).toEqual ["source.satysfi", "keyword.operator.assignment.satysfi"]

    expect(tokens[2][3].value).toBe " "
    expect(tokens[2][3].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][4].value).toBe "334inch"
    expect(tokens[2][4].scopes).toEqual ["source.satysfi", "constant.numeric.length.satysfi"]

    expect(tokens[2][5].value).toBe " "
    expect(tokens[2][5].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][6].value).toBe "*'"
    expect(tokens[2][6].scopes).toEqual ["source.satysfi", "keyword.operator.arithmetic.length.satysfi"]

    expect(tokens[2][7].value).toBe " "
    expect(tokens[2][7].scopes).toEqual ["source.satysfi"]

    expect(tokens[2][8].value).toBe "2."
    expect(tokens[2][8].scopes).toEqual ["source.satysfi", "constant.numeric.float.satysfi"]

  it "tokenizes recursive function", ->
    tokens = grammar.tokenizeLines("""
      let-rec fact n =
        if n <= 0 then 1 else n * fact (n - 1)
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "let-rec"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "keyword.other.let.satysfi"]

    expect(tokens[0][1].value).toBe " fact n "
    expect(tokens[0][1].scopes).toEqual ["source.satysfi"]

    expect(tokens[0][2].value).toBe "="
    expect(tokens[0][2].scopes).toEqual ["source.satysfi", "keyword.operator.assignment.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "  "
    expect(tokens[1][0].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][1].value).toBe "if"
    expect(tokens[1][1].scopes).toEqual ["source.satysfi", "keyword.control.conditional.satysfi"]

    expect(tokens[1][2].value).toBe " n "
    expect(tokens[1][2].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][3].value).toBe "<="
    expect(tokens[1][3].scopes).toEqual ["source.satysfi", "keyword.operator.comparison.int.satysfi"]

    expect(tokens[1][4].value).toBe " "
    expect(tokens[1][4].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][5].value).toBe "0"
    expect(tokens[1][5].scopes).toEqual ["source.satysfi", "constant.numeric.integer.decimal.satysfi"]

    expect(tokens[1][6].value).toBe " "
    expect(tokens[1][6].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][7].value).toBe "then"
    expect(tokens[1][7].scopes).toEqual ["source.satysfi", "keyword.control.conditional.satysfi"]

    expect(tokens[1][8].value).toBe " "
    expect(tokens[1][8].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][9].value).toBe "1"
    expect(tokens[1][9].scopes).toEqual ["source.satysfi", "constant.numeric.integer.decimal.satysfi"]

    expect(tokens[1][10].value).toBe " "
    expect(tokens[1][10].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][11].value).toBe "else"
    expect(tokens[1][11].scopes).toEqual ["source.satysfi", "keyword.control.conditional.satysfi"]

    expect(tokens[1][12].value).toBe " n "
    expect(tokens[1][12].scopes).toEqual ["source.satysfi"]

    expect(tokens[1][13].value).toBe "*"
    expect(tokens[1][13].scopes).toEqual ["source.satysfi", "keyword.operator.arithmetic.int.satysfi"]

    expect(tokens[1][14].value).toBe " fact "
    expect(tokens[1][14].scopes).toEqual ["source.satysfi"]

  it "tokenizes a record", ->
    tokens = grammar.tokenizeLines("""
      (|
        foo = {bar};
      |)
    """)

    # Line 0
    expect(tokens[0][0].value).toBe "(|"
    expect(tokens[0][0].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "punctuation.definition.record.begin.satysfi"]

    # Line 1
    expect(tokens[1][0].value).toBe "  foo "
    expect(tokens[1][0].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi"]

    expect(tokens[1][1].value).toBe "="
    expect(tokens[1][1].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "keyword.operator.assignment.satysfi"]

    expect(tokens[1][2].value).toBe " "
    expect(tokens[1][2].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi"]

    expect(tokens[1][3].value).toBe "{"
    expect(tokens[1][3].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "punctuation.transition.program-to-inline.begin.satysfi"]

    expect(tokens[1][4].value).toBe "bar"
    expect(tokens[1][4].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "meta.state.inline.satysfi"]

    expect(tokens[1][5].value).toBe "}"
    expect(tokens[1][5].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "punctuation.transition.program-to-inline.end.satysfi"]

    expect(tokens[1][6].value).toBe ";"
    expect(tokens[1][6].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "punctuation.definition.record.delimiter.satysfi"]

    # Line 2
    expect(tokens[2][0].value).toBe "|)"
    expect(tokens[2][0].scopes).toEqual ["source.satysfi", "meta.structure.record.satysfi", "punctuation.definition.record.end.satysfi"]
