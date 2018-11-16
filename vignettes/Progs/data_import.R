options(stringsAsFactors = FALSE)

data <- read.csv(system.file("extdata", "dirtydata.csv", package = "cctu"))
data %<>% clean_names() %>% remove_blank_rows_cols()

codes <- read.csv(system.file("extdata","codes.csv", package="cctu")) %>% clean_names()


for( x in unique(codes$var)){
  code_df <-  subset(codes, var==x)
  print(code_df)
  data[,x] <- factor( data[,x], levels=code_df$code, labels=code_df$label)
}

data$start_date <- as.POSIXct( data$start_date , format="%d/%m/%Y")