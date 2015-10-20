if !exists('g:g_markdown_path')
	let g:g_markdown_path='~/my_markdown/'
endif

if !exists('g:g_markdown_browser')
	let g:g_markdown_browser='firefox'
endif

if !exists('g:g_markdown_exflag')
	let g:g_markdown_exflag='-s'
endif

function MdInit()
	let s:base_dir=finddir(g:g_markdown_path)
	if empty(s:base_dir)
		let s:tmp=system('mkdir -p ' . s:s_markdown_css)
		let s:tmp=system('mkdir -p ' . s:s_markdown_output)
		let s:tmp=system('mkdir -p ' . s:s_markdown_src)
		let s:tmp=system('touch ' . s:s_markdown_src . 'index.md')
		let s:tmp=system('cp ../src/main.css' . s:s_markdown_css')
	endif

endfunction
	
