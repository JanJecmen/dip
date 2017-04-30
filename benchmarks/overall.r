library(ggplot2)
library(Hmisc)
library(extrafont)
loadfonts(device = "win")

# args <- commandArgs(trailingOnly = TRUE)
args <- "../Desktop/bench/"

files <- sort(list.files(path = args[[1]], pattern = "^benchmark.*\\.csv$"))
before <- files[[1]]
after <- files[[length(files)]]

hashes <- sapply(strsplit(sapply(strsplit(files, "_", fixed = TRUE), tail, n = 1), ".", fixed = TRUE), head, n = 1)
files <- file.path(args[[1]], files)

before <- read.csv(file.path(args[[1]], before))
before$time <- as.numeric(before$time)

after <- read.csv(file.path(args[[1]], after))
after$time <- as.numeric(after$time)

gnur <- before[grepl("2 R_ENABLE_JIT=2 vanilla-r", before$experiment),]
gnur$experiment <- NULL
gnur <- aggregate(. ~ benchmark, data=gnur, mean)

before <- before[grepl("3 R_ENABLE_JIT=2 rir", before$experiment),]
before$experiment <- NULL
before <- aggregate(. ~ benchmark, data=before, mean)
before$time <- before$time / gnur$time
before$Status <- "before"
before$benchmark <- as.ordered(before$benchmark)

after <- after[grepl("3 R_ENABLE_JIT=2 rir", after$experiment),]
after$experiment <- NULL
after <- aggregate(. ~ benchmark, data=after, mean)
after$time <- after$time / gnur$time
after$Status <- "final"
after$benchmark <- as.ordered(after$benchmark)

ordering <- before$benchmark[order(reorder(as.ordered(before$benchmark), -before$time))]

d <- rbind(before, after)

gnur$time <- gnur$time / gnur$time

plot <- ggplot(d)

plot +
  geom_line(data=gnur, aes(x = benchmark, y = time, group = 1)) + 
  geom_bar(aes(x = benchmark,
               y = time,
               order = sort(Status),
               fill = Status),
           stat="identity",
           position=position_dodge(),
           width = 0.75) +
  scale_fill_brewer(palette="Paired") +
  scale_x_discrete(limits = ordering) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.33, hjust = 1)) +
  xlab("Benchmark") +
  ylab("Speedup vs. GNU R") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "overall.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "overall.png"), scale=1.5)
