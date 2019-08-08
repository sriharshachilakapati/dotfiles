syn clear

" Module declarations
syn keyword psModuleKwd module contained
syn keyword psWhereKwd  where  contained

hi def link psModuleKwd psKeywords
hi def link psWhereKwd  psKeywords

syn region psModuleDecl keepend start=/module/ end=/where/ contains=psModuleKwd,psWhereKwd

" Link to VIM link groups
hi def link psKeywords Keyword
hi def link psModuleDecl PreProc
