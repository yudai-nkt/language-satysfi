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
