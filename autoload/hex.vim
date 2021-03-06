function! s:update_hex_changedtick() abort
  let b:hex_changedtick = b:changedtick
endfunction

function hex#setup() abort
  if exists('b:hex_changedtick')
    return
  endif
  setlocal binary
  call hex#dump()
  setlocal nomodified
  call s:update_hex_changedtick()

  augroup ftplugin_xxd
    au! * <buffer>

    au BufWritePre <buffer> call hex#write_pre()
    au BufWritePost <buffer> call hex#write_post()
    au TextChanged,InsertLeave <buffer> call hex#update()
  augroup END

  let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
  if ! empty(b:undo_ftplugin)
    let b:undo_ftplugin .= '|'
  endif
  let b:undo_ftplugin .= 'setlocal binary<'
  let b:undo_ftplugin .= '|execute "au! ftplugin_xxd * <buffer>"'
  let b:undo_ftplugin .= '|call hex#rev()'
  let b:undo_ftplugin .= '|unlet b:hex_changedtick'
endfunction

function hex#dump() abort
  silent %!xxd -g 1
  call s:hex_strip_trailing_CR()
endfunction

function hex#rev() abort
  silent %!xxd -r
endfunction

function s:hex_strip_trailing_CR() abort
  %substitute/\r$//e
endfunction

" before writing, translate back to original
function hex#write_pre() abort
  call s:hex_save_cursor()
  call hex#rev()
endfunction

" after writing, restore hex view and mark unmodified
function hex#write_post() abort
  call hex#dump()
  setlocal nomodified
  call s:hex_restore_cursor()
  call s:update_hex_changedtick()
endfunction

function! s:hex_changed() abort
  return b:changedtick > get(b:, 'hex_changedtick', 0)
endfunction

" update text column after changing hex values
function hex#update() abort
  if get(g:, 'hex_no_update', v:false)
    return
  endif
  let l:changed = s:hex_changed()
  if l:changed
    call s:hex_save_cursor()
    call hex#rev()
    call hex#dump()
    call s:hex_restore_cursor()
  endif
  if !l:changed
    setlocal nomodified
  endif
endfunction

function s:hex_save_cursor() abort
  let b:xxd_cursor = getpos('.')
endfunction

function s:hex_restore_cursor() abort
  call setpos('.', b:xxd_cursor)
endfunction
