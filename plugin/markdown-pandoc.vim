if !exists('*system')
	echomsg 'markdown-pandoc: Vim system() built-in function is not available. ' .
				\ 'Plugin is not loaded.'
	finish
endif

if !exists('g:g_markdown_path')
	let g:g_markdown_path='~/my_markdown/'
endif

if !exists('g:g_markdown_browser')
	let g:g_markdown_browser='firefox'
endif

if !exists('g:g_markdown_exflag')
	let g:g_markdown_exflag='-s'
endif


let s:s_markdown_css=g:g_markdown_path . 'css/'
let s:s_markdown_output=g:g_markdown_path . 'md_html/'
let s:s_markdown_src=g:g_markdown_path . 'md/'
let s:s_markdown_toc=' --table-of-contents '
let s:s_markdown_dzsilde=' -s --mathml -i -t dzslides '
let s:s_markdown_sildy=' -s --webtex -i -t slidy '
let s:s_markdown_flag=' -c ' . s:s_markdown_css . 'main.css' . s:s_markdown_toc . g:g_markdown_exflag . ' '

function MdInitdir(css_src)
	let s:base_dir=finddir(g:g_markdown_path)
	if empty(s:base_dir)
		let s:tmp=system('mkdir -p ' . s:s_markdown_css)
		let s:tmp=system('mkdir -p ' . s:s_markdown_output)
		let s:tmp=system('mkdir -p ' . s:s_markdown_src)
		let s:tmp=system('touch ' . s:s_markdown_src . 'index.md')
		let s:tmp=system('cp ' . a:css_src . '/../src/main.css ' . s:s_markdown_css)
	endif
endfunction

" init path
if !finddir(g:g_markdown_path)
	let s:current_file=expand('<sfile>:p:h')
	call MdInitdir(s:current_file)
endif


function MdconvertHTML(src_path, src_file)
	let s:src_file=a:src_path . '/' . a:src_file
	let s:out_file=s:s_markdown_output . a:src_file . '.html'
	let s:tmp=system('pandoc ' . s:src_file . s:s_markdown_flag . ' -o ' . s:out_file)
	call MdReplaceTOCattr(s:out_file)
endfunction

function MdconvertSlideHTML(src_path, src_file)
	let s:src_file=a:src_path . '/' . a:src_file
	let s:out_file=s:s_markdown_output . a:src_file . '_slide.html'
	let s:tmp=system('pandoc ' . s:src_file . s:s_markdown_dzsilde . ' -o ' . s:out_file)
endfunction

function MdconvertHTMLandOpen()
	let s:path=getcwd()
	let s:file=expand("%")
	call MdconvertHTML(s:path, s:file)
	let s:tmp=system(g:g_markdown_browser . ' ' . s:s_markdown_output . s:file . '.html')
endfunction

function MdconvertAll()
	let s:flst=system('ls ' . s:s_markdown_src)
	for s:temp in split(s:flst)
		call MdconvertHTML(s:s_markdown_src, s:temp)
	endfor
endfunction

function OpenNewBuf(file)
	exec ':e ' . s:s_markdown_src . a:file
endfunction

function MdNewMD()
	let s:file=expand("<cword>")
	let s:check = findfile(s:file . '.md', s:s_markdown_src)

	if empty(s:check)
		exec ':s/' . s:file . '/[' . s:file . '](' . s:file .'.md.html)'
		exec ':w'
		let s:tmp=system('touch ' . s:s_markdown_src . s:file . '.md')
	endif

	exec ':e ' . s:s_markdown_src . s:file . '.md'
endfunction

"Add html table-of-contents part base on org-mode css
function MdReplaceTOCattr(file)
	exec 'vsp ' . a:file
	let s:tmp=search('<div id="TOC">')
	if empty(s:tmp)
		exec ':q!'
	else
		exec '/<div id="TOC">'
		exec ':s/<div id="TOC">/<div id="TOC">\r<h1 class="title"> <\/h1>\r<div id="table-of-contents">\r<h2>Table of Contents<\/h2>\r<div id="text-table-of-contents">\r'
		exec '/<\/div>'
		exec ':s/<\/div>/<\/div>\r<\/div>\r<\/div>\r'
		exec ':wq'
	endif
endfunction
	

nmap <Leader>mm :call OpenNewBuf('index.md') <CR>
nmap <Leader>mn :call MdNewMD() <CR>
nmap <Leader>mh :call MdconvertHTMLandOpen() <CR>
nmap <Leader>ma :call MdconvertAll() <CR>
