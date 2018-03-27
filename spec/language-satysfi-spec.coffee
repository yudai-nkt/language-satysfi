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
    tokens = grammar.tokenizeLines("`foo\nbar`")

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
