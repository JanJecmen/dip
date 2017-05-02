library(ggplot2)
library(Hmisc)
library(extrafont)
loadfonts(device = "win")

# args <- commandArgs(trailingOnly = TRUE)
args <- "../Desktop/bench/"

files <- sort(list.files(path = args[[1]], pattern = "^benchmark.*\\.csv$"))

if (length(files) < 2) {
  cat("Not plotting history, less than 2 records found...\n")
  q()
}

hashes <- sapply(strsplit(sapply(strsplit(files, "_", fixed = TRUE), tail, n = 1), ".", fixed = TRUE), head, n = 1)
files <- file.path(args[[1]], files)

combined <- NULL

for (i in seq_along(files)) {
  d <- read.csv(files[i])
  d <- d[grepl("R_ENABLE_JIT=2", d$experiment),]
  d$i <- i
  d$time <- as.numeric(d$time)
  d$version <- hashes[i]
  if (is.null(combined))
    combined <- d
  else
    combined <- rbind.data.frame(combined, d)
}

ggplot(combined, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  facet_wrap(~benchmark) +
  scale_color_brewer(palette="Paired", name="Experiment") +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "speedup_history.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "speedup_history.png"), scale=1.5)
