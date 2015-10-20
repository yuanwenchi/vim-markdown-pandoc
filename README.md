# vim-markdown-pandoc

Lets you focus on editing your documentation, recording your life. 
Vim-markdown-pandoc will organize file's create, convert and pre-view.  
It converts markdown base on pandoc. 

_I am not familiar with the syntax of the vim-script, if you like the script, welcome to improve it._

## Intruduction

Vim-markdown-pandoc can conveniently edit markdown by vim. It can fastly generate html, docx and so on.

Vim-markdown-pandoc provids a scheme for organizing markdown source file, and provides default css's file and param to generate html.

## Install

1. Need pandoc
```sh
apt-get install pandoc
```

1. Need vim-script plasticboy/vim-markdown for highlight syntax
```vim
" use bundle install vim-markdown
Bundle 'plasticboy/vim-markdown'
```

1. Install vim-markdown-pandoc
```vim
" usee bundle install vim-markdown-pandoc
Bundle 'yuanwenchi/vim-markdown-pandoc'
```

## example

The [example.md](http://yuanwenchi.github.io/) is generated by vim-markdown-pandoc

## Usage example

```vim
" open index md file
nmap <Leader>mm :call OpenNewBuf('index.md') <CR>
" create/entry a md file, and auto build link
nmap <Leader>mn :call MdNewMD() <CR>
" Convert current md file to html and open it by brower
nmap <Leader>mh :call MdconvertHTMLandOpen() <CR>
nmap <Leader>md :call MdconvertDocx() <CR>
nmap <Leader>ma :call MdconvertAll() <CR>
```

## Options

Configuration:

Change markdown file , default`~/my_markdown/`
```vim
let g:g_markdown_path=''
```
Change brower, default`firefox`
```vim
let g:g_markdown_brower=''
```

## about me

yuanwenchi@126.com
