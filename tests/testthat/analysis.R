
attach_pop(1.1)
X <- sumby(endpoint, rx, data=data )
write_table(X)



attach_pop("1.1.1",verbose=TRUE)
X <- sumby(endpoint, rx, data=data )
write_table(X, clean_up = FALSE)

meta_table <- get_meta_table()

meta_table[2,"subtitle"] <- ""

ntabs <- nrow(meta_table)
meta_table[ntabs+1,"number"] <- "1.1.2"
meta_table[ntabs+1,"population"] <- " "
set_meta_table(meta_table)

write_table(X, number="1.1.2")


attach_pop("1.10")
sumby(response, rx, data=data )
#could actually just call the write_ggplot() now, but the line below is clearer
fig <- sumby(response, rx, data=data ) %>% attr("fig")
write_ggplot( fig, format="png")

attach_pop("2.1")
write_text("There were no deaths")

