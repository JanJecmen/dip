library(ggplot2)
library(Hmisc)
library(extrafont)
loadfonts(device = "win")

data <- read.csv("../Desktop/bench/warmup_benchmark_2017-04-25_16-58-35_ff73d75.csv")
data$time <- as.numeric(data$time)

ggplot(data, aes(x=run, y=time, color=experiment, group=interaction(benchmark, experiment))) +
  stat_summary(fun.data = "mean_cl_boot", geom = "smooth") +
  facet_wrap(~benchmark) +
  scale_color_brewer(palette="Blues", name="Experiment") +
  scale_x_discrete(limits = 1:12) +
  theme(axis.text.x = element_text(size = 5, angle = 90, vjust = 0.5, hjust = 1)) +
  xlab("Run") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

#ggsave(file.path(args[[1]], "warmup.pdf"), device=cairo_pdf)
#ggsave(file.path(args[[1]], "warmup.png"), scale=1.5)

data <- data[data$run == 1,]

ggplot(d, aes(x = experiment,
              y = speedup,
              color = experiment,
              fill = experiment,
              group = benchmark)) +
  scale_x_discrete(labels = 1:4) +
  geom_bar(stat = "identity", color = "black", width = 0.8) +
  theme_minimal() +
  facet_wrap(~benchmark, scales = "free")


ggplot(data, aes(x=experiment, y=time, fill=experiment, group=benchmark)) +
  scale_x_discrete(labels = 1:3) +
  facet_wrap(~benchmark, scales = "free") +
  geom_bar(color="black", stat = "summary", fun.y = "mean", width = 0.5) +
  scale_fill_brewer(palette="Blues", name="Experiment") +
  xlab("Experiment") +
  ylab("Time [s]") +
  theme(text = element_text(family="DejaVu Sans"))

ggsave(file.path(args[[1]], "no_warmup.pdf"), device=cairo_pdf)
ggsave(file.path(args[[1]], "no_warmup.png"), scale=1.5)
