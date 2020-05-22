if exists('g:vim_ctags_loaded')
  finish
endif

let g:vim_ctags_loaded = 1

command! GenerateTags call GenerateTags()

let b:tags_file = "~/.tags"
set tags=b:tags_file

function! GenerateTags()

  if !exists("g:languages") || len(g:languages) == 0
    let l:languages_option = ""
  else
    let l:languages_option = "--languages=".join(g:languages,",")
  endif

  if !exists("g:files_directory") || len(g:files_directory) == 0
    echom("Please specify the source files directory")
    return
  else
    let l:directory = join(g:files_directory," ")
  endif


  let l:cmd = join(["silent !ctags -R -u","--tag-relative=yes",l:languages_option,"-f",b:tags_file,l:directory]," ")
  echom "Wait a moment ..."
  execute l:cmd
  echom "GenerateTags Done"
endfunction
