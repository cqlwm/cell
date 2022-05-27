package main

import (
	parser "cell/gen"
	"encoding/json"
	"fmt"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		panic("must args 1 not null")
	}
	input, _ := antlr.NewFileStream(os.Args[1])
	lexer := parser.NewCellLexer(input)
	lexer.AddErrorListener(antlr.NewDiagnosticErrorListener(true))

	tokenStream := antlr.NewCommonTokenStream(lexer, 0)

	cellParser := parser.NewCellParser(tokenStream)
	cellParser.BuildParseTrees = true
	visitor := parser.BaseCellVisitor{}
	any := visitor.Visit(cellParser.App())
	fmt.Println(json.Marshal(any))
}
