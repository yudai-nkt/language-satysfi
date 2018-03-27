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
