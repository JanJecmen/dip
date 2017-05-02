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
tmp <- mean(before$time)
before$Status <- "before"
before$benchmark <- factor(before$benchmark, levels=c(levels(before$benchmark), "AVERAGE"))
before <- rbind(before, list("AVERAGE", tmp, "mean before"))
before$benchmark <- as.ordered(before$benchmark)

after <- after[grepl("3 R_ENABLE_JIT=2 rir", after$experiment),]
after$experiment <- NULL
after <- aggregate(. ~ benchmark, data=after, mean)
after$time <- after$time / gnur$time
tmp <- mean(after$time)
after$Status <- "final"
after$benchmark <- factor(after$benchmark, levels=c(levels(after$benchmark), "AVERAGE"))
after <- rbind(after, list("AVERAGE", 0, "mean final"))
after$benchmark <- as.ordered(after$benchmark)

ordering <- after$benchmark[order(reorder(after$benchmark, -after$time))]
after[nrow(after),"time"] <- tmp

d <- rbind(before, after)

gnur$benchmark <- factor(gnur$benchmark, levels=c(levels(gnur$benchmark), "AVERAGE"))
gnur <- rbind(gnur, list("AVERAGE", 1))
gnur$time <- 1

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
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Benchmark") +
  ylab("Speedup vs. GNU R") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "overall.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "overall.png"), scale=1.5)
