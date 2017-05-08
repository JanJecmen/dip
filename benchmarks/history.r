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
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))# + theme(aspect.ratio=297/210)

ggsave(file.path(args[[1]], "speedup_history.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "speedup_history.png"), scale=1.5)


nbody <- combined[grepl("nbody-naive.r", combined$benchmark),]

ggplot(nbody, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "nbody-naive.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "nbody-naive.png"), scale=1.5)


kn <- combined[grepl("knucleotide-brute.r", combined$benchmark),]

ggplot(kn, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "knucleotide-brute.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "knucleotide-brute.png"), scale=1.5)


pid <- combined[grepl("pidigits.r", combined$benchmark),]

ggplot(pid, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "pidigits.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "pidigits.png"), scale=1.5)


kn3 <- combined[grepl("knucleotide-brute3.r", combined$benchmark),]

ggplot(kn3, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "knucleotide-brute3.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "knucleotide-brute3.png"), scale=1.5)


rc <- combined[grepl("reversecomplement.r", combined$benchmark),]

ggplot(rc, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "reversecomplement.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "reversecomplement.png"), scale=1.5)


knr <- combined[grepl("knucleotide.r", combined$benchmark),]

ggplot(knr, aes(x=reorder(version, i), y=time, color=experiment, group=interaction(benchmark, experiment))) +
  facet_wrap(~benchmark) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  scale_color_brewer(palette="Paired", name="Experiment") +
  ylim(0, NA) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Revision") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "knucleotide.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "knucleotide.png"), scale=1.5)


