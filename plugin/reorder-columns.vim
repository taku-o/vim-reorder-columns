" reorder-columns.vim:
" Load Once:
if &cp || exists("g:loaded_reorder_columns")
    finish
endif
let g:loaded_reorder_columns = 1
let s:keepcpo              = &cpo
set cpo&vim
" ---------------------------------------------------------------------

function! ReOrder(...) range
    if len(a:000) < 2
        echohl WarningMsg | echo "usage\n\t :[range]ReOrder {splitter} {order} [{delimiter}] \nexample\n\t :%ReOrder , 2431 | \ncause\n\t parameter count error." | echohl None
        return
    endif

    let l:delimiter = a:1
    if len(a:000) < 3
        let l:glue = a:1
    else
        let l:glue = a:3
    endif

    let l:orders = split(a:2, '\zs')
    for l:o in l:orders
        let l:n = str2nr(l:o)
        if l:n == 0
            echohl WarningMsg | echo "usage\n\t :[range]ReOrder {splitter} {order} [{delimiter}] \nexample\n\t :%ReOrder , 2431 | \ncause\n\t {order} is not a natural number or 0 error." | echohl None
            return
        endif
    endfor

    let l:lines = getline(a:firstline, a:lastline)
    let l:i = 0
    while l:i + a:firstline <= a:lastline

        let l:line = l:lines[l:i]
        let l:columns = split(l:line, l:delimiter, 1)

        let l:newcolumns = []
        for l:o in l:orders
            let l:n = str2nr(l:o)
            if len(l:columns) < l:n
                continue
            endif

            call add(l:newcolumns, l:columns[l:o - 1])
        endfor

        let l:newline = join(l:newcolumns, l:glue)

        call setline(l:i + a:firstline, l:newline)

        let l:i += 1
    endwhile

endfunction

" :[range]ReOrder {splitter} {order} [{delimiter}]
" :ReOrder , 24314 |
command! -range -nargs=* ReOrder call ReOrder(<f-args>)

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

