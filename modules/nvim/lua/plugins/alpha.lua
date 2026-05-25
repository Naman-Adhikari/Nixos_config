return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")

		dashboard.section.header.val = {
			[[/$$        /$$$$$$   /$$$$$$  /$$$$$$$$      /$$    /$$ /$$$$$$ /$$      /$$]],
			[[| $$       /$$__  $$ /$$__  $$|__  $$__/     | $$   | $$|_  $$_/| $$$    /$$$]],
			[[| $$      | $$  \ $$| $$  \__/   | $$        | $$   | $$  | $$  | $$$$  /$$$$]],
			[[| $$      | $$  | $$|  $$$$$$    | $$ /$$$$$$|  $$ / $$/  | $$  | $$ $$/$$ $$]],
			[[| $$      | $$  | $$ \____  $$   | $$|______/ \  $$ $$/   | $$  | $$  $$$| $$]],
			[[| $$      | $$  | $$ /$$  \ $$   | $$          \  $$$/    | $$  | $$\  $ | $$]],
			[[| $$$$$$$$|  $$$$$$/|  $$$$$$/   | $$           \  $/    /$$$$$$| $$ \/  | $$]],
			[[|________/ \______/  \______/    |__/            \_/    |______/|__/     |__/]],

			[[                                                                                                                                  ]],
			[[                                                                                                          Kdc;;:;:dN]],
			[[	                                                                                                       Kc'.....   .dW]],
			[[                         	                                                                           O..:ol'.      lW]],
			[[                         	                                                                          K'.OXNN0;       x]],
			[[                         	                                                                         W:..kKXX0k'      .W]],
			[[                         	                                                                         d.. lkX0kodc.     0]],
			[[                         	                                                                        l   .xXXKXX0o.     dM]],
			[[                         	                                                                       0.    .Oxk0Kkl.     'O]],
			[[                         	                                                                        x.    .cdxkl,..  ..  .;O]],
			[[                         	                                                                        W:      .. .,'xdo.      .OW]],
			[[                         	                                                                        c.            lxxOl'      ,K]],
			[[                         	                                                                        x'             ':dxxo:      cX]],
			[[                         	                                                                        Kl                'oxdd,      c]],
			[[                         	                                                                        N: .               .cxdkll.     :N]],
			[[                         	                                                                         'c'.      :           'dxdx.     lX]],
			[[                         	                                                                         ,l..      c.  ..       ,kOlx       dW]],
			[[                         	                                                                        '...                     ;oOc0,:    .W]],
			[[                         	                                  OddX                  MMWNKOdlc;,'......                         .ookld.  .0]],
			[[                         	                                 Nl, .0W             WNOo:'.      ....                               :oxod: .lN]],
			[[                         	                                 N'.   xMM       W0dc'..                               .           .  .ldkoo;ck]],
			[[                         	                                  :  .l,;kWM   MK.                                     ..               'lo.. .0M]],
			[[                                                  	         O .Olxc..:.oO0X.      ...                             ..                     ,M]],
			[[                         	                                  Ml 'xckc     'od..                                    ...                    .K]],
			[[                         	                                   k..;l.  ..   .O.                                         .                .O]],
			[[                         	                                  O..,;:;k0d0.,'  .                                                           .K]],
			[[                         	                                    l'....d,l:;d        .                                                     d]],
			[[                         	                                     l ..'::;'....             lostfromlight  .....                         .k]],
			[[]],
		}

		-- highlight
		vim.cmd([[highlight AlphaHeader guifg=#d4d6d6]])

		dashboard.section.mru.val = { { type = "padding", val = 0 } }

		dashboard.section.header.opts = {
			hl = "AlphaHeader",
			position = "center",
		}

		alpha.setup(dashboard.config)
	end,
}
