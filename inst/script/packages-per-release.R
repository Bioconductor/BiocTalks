library(tidyverse)

path <- "~/b/git/manifest"
releases <- c(paste0("1_", 6:9), paste0("2_", 0:14), paste0("3_", 0:6))
branches <- paste0("RELEASE_", releases)
names(branches) <- sub("_", ".", releases)
n <- vapply(branches, function(branch) {
    system2("git", c("-C", path, "checkout", branch))
    sum(grepl("Package:", readLines(file.path(path, "software.txt"))))
}, integer(1))

cnts <- tibble(
    Release = factor(names(n), levels=names(n)),
    Packages = n
)
plt <- ggplot(cnts, aes(Release, Packages)) +
    geom_point() +
    theme(axis.text.x=element_text(angle=60, hjust=1)) +
    ggtitle("Packages per release")
plt

ggsave("packages-per-release.pdf", plt, "pdf")
