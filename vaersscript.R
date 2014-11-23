library(DBI)
library(RPostgreSQL)
library(dplyr)
library(maps)
library(maptools)
library(RColorBrewer)

vaers <- src_postgres(dbname = 'vaccinedb', host = '127.0.0.1', port = '5432', user = 'vagrant', password = 'vagrant')
vaersdata <- tbl(vaers, 'vaersdata')
vaersvax <- tbl(vaers, 'vaersvax')
vaerssymptoms <- tbl(vaers, 'vaerssymptoms')

stateevents <- vaersdata %>% select(state, vaers_id)
statetotals <- stateevents %>% count(state) %>% arrange(state)

statefluevents  <- vaersvax %>% group_by(vax_type) %>% filter(vax_type~"FLU*") %>% select(vaers_id, vax_type) %>% inner_join(select(vaersdata, vaers_id, state)) %>% select(state, vaers_id)
stateflutotals <- statefluevents %>% count(state) %>% arrange(state)

abb <- cbind(state.abb)
sname <- tolower(cbind(state.name))
abbtoname <- cbind(abb, sname)
abbtoname <- as.data.frame(as.matrix(abbtoname))

flupercent <- inner_join(stateflutotals, statetotals, by = 'state')
flupercplot <- collect(flupercent %>% mutate(percent = (n.x *100)/n.y))

colors  <- brewer.pal(9, "YlGn")
flupercplot$colorBuckets <- as.numeric(cut(flupercplot$percent, c(10, 15, 20, 25, 30, 35, 40, 45, 50, 100)))
fluleg.txt <- c("<10%", "10-14%", "15-19%", "20-24%", "25-29%", "30-34%", "35-39%", "40-44%", "45-49%", "50+%")

states.matched <- abbtoname$state.abb [match(map("state", plot = FALSE)$names, abbtoname$state.name)]
colorsmatched <- flupercplot$colorBuckets [match(states.matched, flupercplot$state)]
map("state", col = colors[na.omit(colorsmatched)], fill = TRUE)
legend("bottomright", fluleg.txt, horiz = FALSE, fill = colors)
title("Flu VAEs as Percentage of Total VAEs, 2013")


dbDisconnect(conn)
