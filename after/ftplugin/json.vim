" ftplugin for JSON files to add ERB highlighting for .json.erb files
" Only apply ERB highlighting if this is a .json.erb file

if expand('%:t') =~# '\.json\.erb$'
    " Add ERB syntax highlighting on top of JSON
    syntax region erbBlock start=+<%+ end=+%>+ containedin=ALL
    syntax region erbExpression start=+<%=+ end=+%>+ containedin=ALL
    syntax region erbComment start=+<%#+ end=+%>+ containedin=ALL
    
    " Highlight ERB regions
    highlight link erbBlock PreProc
    highlight link erbExpression Identifier
    highlight link erbComment Comment
endif