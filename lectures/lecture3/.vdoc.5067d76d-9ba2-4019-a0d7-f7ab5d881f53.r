#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: setup
#| include: false

library(tidyverse)
library(kableExtra)
library(DT)
library(gapminder)
library(ggthemes)
library(cowplot)
library(patchwork)
library(fpp3)
library(fontawesome)
library(countrycode)
library(flair)

# Add a continent column based on country names
gapminder_extended <- read_csv("../../data/gapminder_all.csv") |> 
  mutate(continent = countrycode(country, origin = "country.name", destination = "continent"))
gapminder <- gapminder_extended |> filter(year <= 2024) |> drop_na()

arrival_hourly <- read_csv("../../data/ED_hourly_arrival.csv")


#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: false
# Load the built-in Anscombe dataset
data(anscombe)

# Display the first few rows
head(anscombe)

#
#
#
#
# Compute summary statistics for each pair (x1,y1), (x2,y2), (x3,y3), (x4,y4)
summary_stats <- data.frame(
  set = paste0("Set", 1:4),
  mean_x = sapply(1:4, function(i) mean(anscombe[[paste0("x", i)]])),
  mean_y = sapply(1:4, function(i) mean(anscombe[[paste0("y", i)]])),
  sd_x   = sapply(1:4, function(i) sd(anscombe[[paste0("x", i)]])),
  sd_y   = sapply(1:4, function(i) sd(anscombe[[paste0("y", i)]])),
  cor_xy = sapply(1:4, function(i) cor(anscombe[[paste0("x", i)]], anscombe[[paste0("y", i)]]))
)
summary_stats
```
#
#
#
#
#
#| echo: false
par(mfrow = c(2, 2))  # Arrange plots in a 2x2 grid
for (i in 1:4) {
  x <- anscombe[[paste0("x", i)]]
  y <- anscombe[[paste0("y", i)]]
  plot(x, y,
       main = paste("Anscombe Set", i),
       xlim = c(4, 20), ylim = c(3, 13),
       pch = 19, col = "blue")
  abline(lm(y ~ x), col = "red", lwd = 2)
}
par(mfrow = c(1, 1))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: false
knitr::include_url("https://datavizproject.com/", height = "500px")
#
#
#
#
#
#
#| echo: false
knitr::include_url("https://www.data-to-viz.com/", height = "500px")
#
#
#
#
#
#
#| echo: false
knitr::include_url("https://www.r-graph-gallery.com/", height = "500px")
#
#
#
#
#| echo: false
knitr::include_url("https://clauswilke.com/dataviz/directory-of-visualizations.html")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
gapminder
#
#
#
#
#
#
gapminder_2024 <- gapminder |> filter(year == "2024") |> select(-year)
gapminder_2024
#
#
#
#
ggplot()
#
#
#
#
#
ggplot(data = gapminder_2024)
#
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap, y = lex))
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap, y = lex)) +
  geom_point()
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap, y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: false
knitr::include_url("https://ggplot2.tidyverse.org/reference/index.html", height = "500px")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10()
```
#
#
#
#
#
#
ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  scale_color_colorblind()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  scale_color_colorblind() +
  facet_wrap(vars(continent))
#
#
#
#
#
#
#
#
ggplot(filter(gapminder, year %in% c(2002, 2007)), 
       aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  scale_color_colorblind() +
  facet_wrap(vars(continent, year))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(gapminder_2024, 
       aes(x = gdp_pcap, y = lex, 
           color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  labs(title = "Health and wealth grow together",
       subtitle = "Data from 2007",
       x = "Wealth (GDP per capita)",
       y = "Health (life expectancy)",
       color = "Continent",
       size = "Population",
       caption = "Source: The Gapminder Project")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() +
  theme_dark()
#
#
#
#
#
#
#
#
#
ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, color = continent, size = pop)) +
  geom_point() +
  scale_x_log10() + 
  theme_minimal()
#
#
#
#
#
#
#
#
#
#
#
knitr::include_url("https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/", height = "500px")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop))  
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop)) +
  geom_point() #<<
#
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()
```
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop)) +
  geom_point() +
  scale_x_log10() #<<
```
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()+
  scale_x_log10()
```
#
#
#
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop)) +
  geom_point() +
  scale_x_log10() +
  labs(x = "Income", y = "Life expectency",#<<
       title = "How Does Income Relate to Life Expectancy?") #<<
```
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()+
  scale_x_log10()+
    labs(x = "Income", y = "Life expectency", title = "How Does Income Relate to Life Expectancy?") 
```
#
#
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop)) +
  geom_point() +
  scale_x_log10() +
  labs(x = "Income", y = "Life expectency") +
  theme_classic() #<<
```
#
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()+
  scale_x_log10()+
  labs(x = "Income", y = "Life expectency") +
  theme_classic()
```
#
#
#
#
#
#
#
#
#
#
#
ggplot(data = gapminder_2024,                  
       mapping = aes(x = gdp_pcap,     
                     y = lex,       
                     color = continent,
                     size = pop)) +
  geom_point() +
  scale_x_log10() +
  labs(x = "Income", y = "Life expectency", title = "How Does Income Relate to Life Expectancy?") +
  theme_classic() +
    theme(legend.position = "bottom", #<<
        plot.title = element_text(face = "bold")) #<<
```
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()+
  scale_x_log10()+
  labs(x = "Income", y = "Life expectency",  title = "How Does Income Relate to Life Expectancy?")+
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"))
```
#
#
#
#
#
ggplot(data = gapminder_2024,
       mapping = aes(x = gdp_pcap,
                     y = lex,
                     color = continent,
                     size = pop)) +
  geom_point()+
  scale_x_log10()+
  labs(x = "Income", y = "Life expectency",  title = "How Does Income Relate to Life Expectancy?")+
  theme_classic() +
  theme(legend.position = "bottom",
        plot.title = element_text(face = "bold"))
#
#
#
#
#
arrival_hourly
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ed_arrival_tsb <- arrival_hourly |> 
  as_tsibble(index = hour, key= type_injury)

ed_arrival_tsb
#
#
#
#
#
#
ed_arrival_tsb |> autoplot(arrival) # create a time plot of hourly data
#
#
#
#
#
library(dygraphs)
library(tsbox)
tsbox::ts_xts(ed_arrival_tsb) |> 
  dygraphs::dygraph() |> 
  dygraphs::dyRangeSelector(dateWindow = c("2010-01-01", "2010-01-02"))
#
#
#
#
#
#| label: day-seasonal-plot-hourly
ed_arrival_tsb |> feasts::gg_season(arrival, period = "day") #seasonal plot
#
#
#
#
#
#| label: seasonal-plot-hourly
ed_arrival_tsb |> feasts::gg_season(arrival, period = "week") #seasonal plot
#
#
#
#
#
#| label: day-sub-series
ed_arrival_tsb |> feasts::gg_subseries(arrival, period = "day")# subseries plot
#
#
#
#
#
#| label: week-sub-series
ed_arrival_tsb |> feasts::gg_subseries(arrival, period = "hour")# subseries plot
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
knitr::include_url("https://datavizproject.com/", height = "500px")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
p <- ggplot(gapminder, aes(x = gdp_pcap, y = lex, size = pop, color = continent)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(2, 12), guide = "none") +   # use "none" to avoid deprecation warning
  guides(color = "none") +
  scale_x_log10(labels = scales::dollar) +
  labs(title = 'Year: {closest_state}', x = 'GDP per capita', y = 'Life expectancy') +
  ggthemes::scale_color_colorblind()+
  ggthemes::theme_few()+
  transition_states(year, transition_length = 3, state_length = 6, wrap = FALSE) +
  ease_aes('linear')

yrs <- sort(unique(gapminder$year))
frames_per_year <- 12    # how many frames to allocate to each year (most are "hold" frames)
fps <- 24                 # frames per second (lower = slower)

anim <- animate(
  p,
  nframes      = length(yrs) * frames_per_year,
  fps          = fps,
  width        = 900, height = 600, res = 144,
  start_pause  = fps * 0.5,            # ~0.5s pause at start
  end_pause    = fps * 0.5,            # ~0.5s pause at end
  getwd()
  renderer     = gifski_renderer("../../img/lecture3/gapminder_animation.gif", loop = FALSE)
)

anim  # shows in the Plots pane
#
#
#
#
#
#
#
#
#
#
#
#
p <- ggplot(gapminder_2024, aes(x = gdp_pcap, y = lex, size = pop, color = continent))

p + geom_point()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
