syntax match myoperators "[+/*%^&!|<>?-]"
syntax match mymisc "[:.,\[\]=]"
syntax match mybrackets "[(){}]"
hi clear SignColumn
syn keyword cTodo contained  BUG TEST OPTIMIZE PRIORITY NOTE
"hi cTodo guifg=#53f5b1 guibg=NONE gui=NONE
"hi VertSplit guifg=#1d2021 guibg=#d5c4a1
"hi StatusLine guifg=#1d2021 guibg=#ebdbb2
"hi StatusLineNC guifg=#101010 guibg=#a89984
"hi LineNr guibg=#000000 guifg=NONE
"hi EndOfBuffer guifg=#282828
"hi Visual guifg=#282828 guibg=#335a61 gui=none
"hi MatchParen guifg=#243333 guibg=#ff6a00
"hi Normal guifg=#ebdbb2
"hi Normal guibg=#282828
"hi Number guifg=#8ec07c
"hi Character guifg=#fabd2f
"hi Search guifg=#d5c4a1 guibg=#665c54
"hi Constant guifg=#d3869b
"hi Type guifg=#b8bb26 cterm=NONE gui=NONE
"hi link LspCxxHlSymPrimitive Type
"hi link LspCxxHlSymClass Type
"hi link LspCxxHlSymStruct Type
"hi link LspCxxHlSymEnum Type
"hi link LspCxxHlSymTypeAlias Type
"hi link LspCxxHlSymTypeParameter Type
"hi link LspCxxHlSymDependentType Type
"hi link LspCxxHlSymConcept Type
"hi link LspCxxHlSymTemplateParameter Type
"hi link LspCxxHlSymTypedef Type
"hi link LspCxxHlSymPrimitive Type
"hi link LspCxxHlSymTemplateParameter Type
"hi link LspCxxHlGroupNamespace Type
"hi link LspCxxHlGroupEnumConstant Constant
"hi link LspCxxHlGroupMemberVariable Normal
"hi Function guifg=#83a598 gui=NONE
"hi String guifg=#fabd2f
"hi Control guifg=#fb4934
"hi Statement guifg=#fb4934 cterm=NONE gui=NONE
"hi Special guifg=#fabd2f
"hi PreProc guifg=#fe8019 guibg=NONE gui=bold
"hi Comment guifg=#928374 guibg=NONE gui=NONE cterm=NONE
"hi Macro guifg=#d3869b cterm=NONE gui=NONE
"hi CocFloating guibg=#1d2021
"hi CocErrorFloat guifg=#cc3737 guibg=#1d2021
"hi CocWarningFloat guifg=#d4ae3b guibg=#1d2021
"hi Pmenu guifg=#2c91d4 guibg=#1d2021
"hi PmenuSel guifg=#e3e3e3 guibg=#202020

"Tree-Sitter specific highlighting"

"hi link TSType Type
"hi link TSTypeBuiltin Type
"hi link TSOperator Normal
"hi link TSNamespace Normal
"hi link TSMethod Normal
"hi link TSNumber Number
"hi link TSKeyword Statement
"hi link TSKeywordReturn TSKeyword
"hi link TSKeywordFunction TSKeyword
"hi link TSKeywordOperator TSKeyword
"hi link TSInclude PreProc
"hi link TSFunction Normal
"hi link TSFloat Number
"hi link TSField Normal
"hi link TSProperty Normal
"hi link TSConstructor Type
"hi link TSConditional TSKeyword
"hi link TSCharacter String
"hi link TSBoolean Number
"hi link TSConstant Macro
"hi link TSConstBuiltin Macro
"hi link TSConstMacro Macro
"hi link TSFuncBuiltin TSFunction
"hi link TSFuncMacro TSFunction
"hi link TSParameter Normal 
"hi link TSParameterReference Normal
"hi link TSPunctDelimiter Normal
"hi link TSString String
"hi link TSStringEscape String
"hi link TSStringRegex String
"hi link TSStringSpecial String
"hi link TSSymbol Normal
"hi link TSVariable Normal
"hi link TSRepeat Statement
"hi link TSVariableBuiltin Normal
"hi link TSNone Normal
"hi link TSPunctBracket Normal
"hi link TSComment Comment
"hi TSLabel guifg=#fb4934
