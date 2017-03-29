library(ggplot2)
library(Hmisc)

args <- commandArgs(trailingOnly = TRUE)

files <- sort(list.files(path = args[[1]], pattern = "^benchmark.*\\.csv$"))
hashes <- sapply(strsplit(sapply(strsplit(files, "_", fixed = TRUE), tail, n = 1), ".", fixed = TRUE), head, n = 1)
files <- file.path(args[[1]], files)

combined <- NULL

for (i in seq_along(files)) {
    d <- read.csv(files[i])
    d <- d[d$experiment == "3 R_ENABLE_JIT=2 rir",]
    d$i <- i
    d$time <- as.numeric(d$time)
    d$version <- hashes[i]
    d$experiment <- NULL
    if (is.null(combined))
        combined <- d
    else
        combined <- rbind.data.frame(combined, d)
}

ggplot(combined, aes(x=version, y=time, group=benchmark)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  facet_wrap(~benchmark) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  ylab("time [s]")

ggsave("speedup_history.pdf")
ggsave("speedup_history.png", scale=1.5)
