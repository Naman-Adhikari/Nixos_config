return {
  {
    "lervag/vimtex",
    ft = "tex", 
		priority = 1000,
    config = function()
      vim.g.vimtex_view_method = 'zathura'
      
      vim.g.vimtex_compiler_method = 'latexmk'
		
	  vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_complete_close_braces = 1
      vim.g.vimtex_complete_ignore_case = 1		
      
      vim.g.vimtex_compiler_latexmk = {
        build_dir = 'build',  
        options = {
          '-pdf',
          '-shell-escape',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        }
      }

	  vim.g.vimtex_toc_config = {
		  mode = 1,    
		  layer_status = {
			label = 1,
			todo = 1,
			include = 1,
		  },
		  show_help = 0,               
		  show_numbers = 1,           
		  split_pos = 'leftabove',   
		  split_width = 10,         
		  refresh_always = 1,      
		  fold_level_start = 2,   
		  hide_line_numbers = 1, 
		  focus_on_open = 1,		
    }		
    end
  }
}
