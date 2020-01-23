TDerma = {}

TDerma.Colours = {
	DEFAULT = {
		//Main Body Colours
		ACCENT = 		Color(184, 127, 066),
		BACKGROUND = 	Color(064, 062, 059),
		FOREGROUND = 	Color(112, 110, 107),
		TEXT_LIGHT =	Color(255, 255, 255),
		TEXT_DARK = 	Color(064, 062, 059),

		//Alt colours (usually not used often)
		WHITE =	 Color(255, 255, 255),
		BLACK = Color(000, 000, 000),
		CLOSE_BUTTON = Color(000, 000, 000),
	},

	ALT1 = {

	},

	ALT2 = {

	},
	
}

surface.CreateFont("TDerma.Title", {
	font = "Dubai", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = ScreenScale(9),
	weight = 750,
})

surface.CreateFont("TDerma.Body", {
	font = "Dubai", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = ScreenScale(7),
	weight = 750,
})

surface.CreateFont("TDerma.Sub", {
	font = "Dubai", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = ScreenScale(7),
	weight = 500,
})