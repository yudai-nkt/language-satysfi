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
