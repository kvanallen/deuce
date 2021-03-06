#' Download Current WTA Calendar
#'
#' This function downloads the WTA calendar
#' 
#' @param ... other options passed to fetch_wta_tournaments
#'
#'
#' @export
#' 
fetch_wta_tournaments <- function(...){
	
	url <- "http://www.wtatennis.com/calendar"
	
	
	page <- xml2::read_html(url)
	
	links <- page %>%
		rvest::html_nodes(xpath = "//table[contains(@id, 'table-calendar')]") %>%
		rvest::html_nodes("a")
		
	links <- grep("/tournament/", links, fixed = T, value = T)
	links <- links[seq(1, length(links), by = 2)]
	
	site.url <- sub('(.*)(tournament.*)(".*)', "\\2", links)
	locations <- sub("(.*>)(.*)(</a>)","\\2", links)
	
	url.df <- data.frame(
		site.url = file.path("http://www.wtatennis.com", site.url),
		location = locations,
		stringsAsFactors = F
	)
	
	table <- page %>%
		rvest::html_nodes(xpath = "//table[contains(@id, 'table-calendar')]") %>%
		rvest::html_table(fill = T)
	
	table <- table[[1]]


	table$name <- gsub(".", "", table$Tournament, fixed = T)
	table$name <- gsub("-", "", table$name, fixed = T)
	table$name <- gsub(",", "", table$name, fixed = T)
	table$name <- gsub("'", "", table$name, fixed = T)
	
	table$location <- table$Location
	
	year <- sub("(.*\\()(....)(\\))", "\\2", table$Date)[1]
	
	table$start_date <- lubridate::dmy(paste(substr(table$Date, 1, 6), year))
		
	table$start_date <- lubridate::dmy(paste(substr(table$Date, 1, 6), year))	
	table$start_date[lubridate::yday(table$start_date) > 330] <- table$start_date[lubridate::yday(table$start_date) > 330] - year(1)
	
	table$end_date <- lubridate::dmy(paste(substr(table$Date, 10, 16), year))
	
	table <- table %>% 
		select(name, location, start_date, end_date) %>%
		filter(location != "")
	
	# Event details
	surface_draw <- function(x){
			
		page <- xml2::read_html(x)
	
		surface <- page %>%
			rvest::html_node(xpath =  "//div[contains(@class, 'field-tournament-surface')]") %>%
			rvest::html_text()
			
		surface <- ifelse(grepl("hard", surface, ignore.case = T), "Hard",
						ifelse(grepl("clay", surface, ignore.case = T), "Clay", "Grass"))
			
		draw <- page %>%
		  rvest::html_node(xpath =  "//div[contains(@class, 'field-draw-size-singles-main')]") %>%
		  rvest::html_text()
				
		draw <- as.numeric(sub("(.*\\:.)([0-9]+)", "\\2", draw))
		
	data.frame(surface = surface, draw = draw, stringsAsFactors = F)	
	}
	
	
	surface.draw.df <- do.call("rbind", lapply(url.df$site.url, surface_draw))
		
	table <- cbind(table, surface.draw.df)
	
	# Check draws: https://en.wikipedia.org/wiki/2018_WTA_Tour
	
	table$draw[table$name == "BRISBANE Brisbane International presented by Suncorp"] <- 30
	table$draw[table$name == "SYDNEY Sydney International"] <- 30
	table$draw[table$name == "ST PETERSBURG St Petersburg Ladies Trophy"] <- 28
	table$draw[table$name == "DOHA Qatar Total Open 2018"] <- 56
	table$draw[table$name == "DUBAI Dubai Duty Free Tennis Championships"] <- 28
	table$draw[table$name == "INDIAN WELLS BNP Paribas Open"] <- 96
	table$draw[table$name == "MIAMI Miami Open presented by Itau"] <- 96
	table$draw[table$name == "CHARLESTON Volvo Car Open"] <- 56
	table$draw[table$name == "STUTTGART Porsche Tennis Grand Prix"] <- 28
	table$draw[table$name == "ROME Internazionali BNL dItalia"] <- 56
	table$draw[table$name == "EASTBOURNE The International Eastbourne"] <- 48
	table$draw[table$name == "SAN JOSE Mubadala Silicon Valley Classic"] <- 28
	table$draw[table$name == "MONTREAL Coupe Rogers présentée par Banque Nationale"] <- 56
	table$draw[table$name == "CINCINNATI Western & Southern Open"] <- 56
	table$draw[table$name == "NEW HAVEN Connecticut Open"] <- 30
	table$draw[table$name == "HIROSHIMA Japan Womens Open Tennis"] <- 28
	table$draw[table$name == "WUHAN Wuhan Open"] <- 56
	table$draw[table$name == "BEIJING China Open"] <- 60
	table$draw[table$name == "MOSCOW VTB Kremlin Cup"] <- 28

		
table 
}
