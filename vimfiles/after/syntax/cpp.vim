"Vim syntax for method name highlighting
syn match cppFuncCall "\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?\s*"
hi cppFuncCall gui=bold

syn match cppFuncDef "\~\?\zs\h\w*\ze(\_[^)]*\()\s*\(const\)\?\)\?\s*{"
hi cppFuncDef guifg=#FFAF2F gui=bold

syn match Macro "\<[A-Z0-9_]\+\>("me=e-1
syn match Constant "\<[A-Z0-9_]\+\>[^(]"me=e-1
"hi cppMacro     guifg=#889966   gui=bold
"hi cppUserConst guifg=#707865   gui=bold

