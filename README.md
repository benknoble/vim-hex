# vim-hex

[![This project is considered stable](https://img.shields.io/badge/status-stable-success.svg)](https://benknoble.github.io/status/stable/)

`Hex` and `Bless` your binary files for editing

## Usage

If you are opening a binary file, make sure to use `vim -b` or `:edit ++binary`

- `:Hex` to start hex-editing a file
- `:Bless` or `:Hex!` to restore the normal view

You can edit the two-hexit numbers in the middle columns, and see the text
representation updated dynamically. Saving will write out the correct
representation.

## Bugs

-<strike> Saving a binary executable, even after changing nothing, corrupts
it</strike> (use `vim -b` [#4](https://github.com/benknoble/vim-hex/issues/4))
- Undo not fully supported
