library(tidyverse)

url <- "http://bioconductor.org/packages/devel/bioc/VIEWS"
dcf <- as_tibble(read.dcf(url(url)))

dcf <- dcf[, c("Package", "Maintainer")]
dcf$Maintainer <- gsub("[[:space:]]+", " ", dcf$Maintainer)
dcf$Maintainer <- gsub(" and ", ", ", dcf$Maintainer)

m <- strsplit(dcf$Maintainer, ",")
dcf <- dcf[rep(seq_along(m), lengths(m)),]

m <- unlist(m)
pattern <- "^(.*) <(.*)>"
dcf$Name <- sub(pattern, "\\1", m)
dcf$EMail <- sub(pattern, "\\2", m)

## cannonical name
idx <- match(tolower(dcf$Name), tolower(dcf$Name))
dcf$Name <- dcf$Name[idx]
length(unique(dcf$Package))
length(unique(dcf$Name))                # 1060
tbl <- as_tibble(table(table(dcf$Name)))
colnames(tbl) <- c("Packages", "Developers")
tbl$Packages <- as.integer(tbl$Packages)

who <- c(character(9), names(tail(sort(table(dcf$Name)), 4)))
who[length(who)] <- "Core"
plt <- ggplot(tbl, aes(Packages, Developers, label=who)) + geom_point() +
    scale_x_log10() + scale_y_log10() +
    geom_text(angle=60, hjust = "outward", nudge_y = .05) +
    ggtitle("Packages per developer")
ggsave("packages-per-developer.pdf", plt, "pdf")

