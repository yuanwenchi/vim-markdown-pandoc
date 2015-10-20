let g:g_markdown_path='/home/owen/my_markdown/'
let g:g_markdown_css=g:g_markdown_path . 'css/main.css'
let g:g_markdown_output=g:g_markdown_path . 'md_html'
let g:g_markdown_src=g:g_markdown_path . 'md'
let g:g_markdown_toc=' --table-of-contents '
let g:g_markdown_dzsilde=' -s --mathml -i -t dzslides '
let g:g_markdown_sildy=' -s --webtex -i -t slidy '
let g:g_markdown_flag=' -c ' . g:g_markdown_css . g:g_markdown_toc
let g:g_markdown_browser='firefox'

function MdconvertHTML(src_path, src_file)
	let s:src_file=a:src_path . '/' . a:src_file
	let s:out_file=g:g_markdown_output . '/' . a:src_file . '.html'
	let s:tmp=system('pandoc ' . s:src_file . g:g_markdown_flag . ' -o ' . s:out_file)
	call MdReplaceTOCattr(s:out_file)
endfunction

function MdconvertSlideHTML(src_path, src_file)
	let s:src_file=a:src_path . '/' . a:src_file
	let s:out_file=g:g_markdown_output . '/' . a:src_file . '_slide.html'
	let s:tmp=system('pandoc ' . s:src_file . g:g_markdown_dzsilde . ' -o ' . s:out_file)
endfunction

function MdconvertHTMLandOpen()
	let s:path=getcwd()
	let s:file=expand("%")
	call MdconvertHTML(s:path, s:file)
	let s:tmp=system(g:g_markdown_browser . ' ' . g:g_markdown_output . '/' . s:file . '.html')
endfunction

function MdconvertAll()
	let s:flst=system('ls ' . g:g_markdown_src)
	for s:temp in split(s:flst)
		call MdconvertHTML(g:g_markdown_src, s:temp)
	endfor
endfunction

function OpenNewBuf(file)
	exec ':e ' . g:g_markdown_src . '/' . a:file
endfunction

function MdNewMD()
	let s:file=expand("<cword>")
	let s:check = findfile(s:file . '.md', g:g_markdown_src)

	if empty(s:check)
		exec ':s/' . s:file . '/[' . s:file . '](' . s:file .'.md.html)'
		exec ':w'
		let s:tmp=system('touch ' . g:g_markdown_src . '/' . s:file . '.md')
	endif

	exec ':e ' . g:g_markdown_src . '/' . s:file . '.md'
endfunction

function MdInit()
	let s:base_dir=finddir(g:g_markdown_path)
	if empty(s:base_dir)
		let s:tmp=system('mkdir -p ' . g:g_markdown_css)
		let s:tmp=system('mkdir -p ' . g:g_markdown_output)
		let s:tmp=system('mkdir -p ' . g:g_markdown_src)
		let s:tmp=system('touch ' . g:g_markdown_src . 'index.md')
	endif
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
