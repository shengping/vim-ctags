"
" Author shengping turingbird@163.com
"

if exists('g:vim_ctags_loaded')
  finish
endif

let g:vim_ctags_loaded = 1

augroup vim_ctags_group
  autocmd!
  autocmd BufWritePost * call AutoGenTagAfterWrite()
augroup END

command! GenTags call GenTags()

let g:tags_file_str = "~/.tags"

execute 'set tags+='.g:tags_file_str

if !exists("g:languages") || len(g:languages) == 0
  let g:tag_languages_option = ""
else
  let g:tag_languages_option = "--languages=".join(g:languages,",")
endif

function! GenTags()

  if !exists("g:files_directory") || len(g:files_directory) == 0
    echom("Please specify the source files directory")
    return
  else
    let l:directory = join(g:files_directory," ")
  endif

  let l:cmd = join(["silent !ctags -R","--tag-relative=yes",g:tag_languages_option,"-f",g:tags_file_str,l:directory]," ")

  echom "Wait a moment ..."
  execute l:cmd
  echom "GenTags Done"
endfunction

function! InFilesDirectory(file_full_path)

  let l:file_path_slice = split(a:file_full_path,'/')

  for l:g_direcotry in g:files_directory

    let l:g_direcotry_slice = split(l:g_direcotry,'/')
    let l:ii    = 0
    let l:match = 1

    if len(l:file_path_slice) < len(l:g_direcotry_slice)
      let l:match = 0
      continue
    endif

    while l:ii < len(l:g_direcotry_slice)
      if !(l:file_path_slice[ii] ==# l:g_direcotry_slice[ii])
        let l:match = 0
        break
      endif
      let l:ii = l:ii+1
    endwhile
    if l:match
      return 1
    endif
  endfor
  return 0
endfunction

function! AutoGenTagAfterWrite()
  if InFilesDirectory(expand("%:p:h"))
    let l:st=join(split(expand("%:p"),'/'),'\/')
    execute "silent !sed -i ".'"/'.l:st.'/d" '.g:tags_file_str
    let l:cmd = join(["silent !ctags -a","--tag-relative=yes",g:tag_languages_option,"-f",g:tags_file_str,expand("%:p")]," ")
    execute l:cmd
  endif
endfunction
