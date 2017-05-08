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
  gnur <- d[grepl("2 R_ENABLE_JIT=2 vanilla-r", d$experiment),]
  rir <- d[grepl("3 R_ENABLE_JIT=2 rir", d$experiment),]
  d <- d[1,]
  d$experiment <- NULL
  d$benchmark <- NULL
  d$time <- NULL
  d$i <- i
  gnur <- aggregate(. ~ benchmark, gnur[-1], mean)
  rir <- aggregate(. ~ benchmark, rir[-1], mean)
  d$speedup <- mean(gnur$time / rir$time)
  d$version <- hashes[i]
  if (is.null(combined)) {
    combined <- d
  } else {
    combined <- rbind.data.frame(combined, d);
  }
}

aspect <- 1/3

ggplot(combined, aes(x=reorder(version, i), y=speedup, group = 1)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Speedup [-]") +
  theme(text = element_text(family="DejaVu Sans")) +
  theme(aspect.ratio=aspect)

ggsave(file.path(args[[1]], "avg_speedup.pdf"), device=cairo_pdf, width = 7, height = 7*aspect)
ggsave(file.path(args[[1]], "avg_speedup.png"), scale=1.5, width = 7, height = 7*aspect)


d <- read.csv(files[1])
rir <- d[grepl("3 R_ENABLE_JIT=2 rir", d$experiment),]
rir <- aggregate(. ~ benchmark, rir[-1], mean)
base <- rir$time
combined <- NULL

for (i in seq_along(files)) {
  d <- read.csv(files[i])
  rir <- d[grepl("3 R_ENABLE_JIT=2 rir", d$experiment),]
  d <- d[1,]
  d$experiment <- NULL
  d$benchmark <- NULL
  d$time <- NULL
  d$i <- i
  rir <- aggregate(. ~ benchmark, rir[-1], mean)
  d$speedup <- mean(base / rir$time)
  d$version <- hashes[i]
  if (is.null(combined)) {
    combined <- d
  } else {
    combined <- rbind.data.frame(combined, d);
  }
}

