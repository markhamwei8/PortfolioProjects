# create a bar chart race for Vancouver house price:
library(tidyverse)
library(ggplot2)
library(gganimate)
library(dplyr)
library(readr)
library(gifski)
library(av)
library(magick)


# Use the conflicted package to manage conflicts
library(conflicted)

# Set dplyr::filter and dplyr::lag as the default choices
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")


# STEP 1: COLLECT DATA:

df_vancouver <- read.csv("vancouver_year_property_price_long.csv", encoding="UTF-8")

# check with their structure:
str(df_vancouver)

# Keep only top 10 each year for the NEW data frame;
df_vancouver1 <- df_vancouver %>%
  group_by(Year) %>%
  arrange(desc(Average_Price)) %>%
  mutate(rank = row_number()) %>%
  filter(rank <= 10)

# STEP 2: Create animation and save it 
# p1 is the ggplot object with the transition layer:
p1 <- ggplot(df_vancouver1, aes(x = -rank, y = Average_Price, fill = Property_Type)) +
  geom_col(width = 0.8) +
  coord_flip(clip = "off", expand = FALSE) +
  geom_text(aes(label = Average_Price, y = Average_Price + 20), hjust = 0) +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal(base_size = 15) +
  theme(legend.position = "none",
        plot.title = element_text(size = 22, face = "bold"),
        plot.subtitle = element_text(size = 18)) +
  labs(title = 'Vancouver House Price Change',
       subtitle = 'Year: {closest_state}') +
  transition_states(Year, transition_length = 4, state_length = 1) +
  ease_aes('cubic-in-out')

## STEP 3:Save the animation of p1 as GIF:
# Create the animation object ("my_animation1) by calling animate() on p1

my_animation1 <- animate(p1, nframes = 100, fps = 10, renderer = gifski_renderer())

# Save the animation object into gif format:
anim_save("vancouver_bcrace1.gif", my_animation1, width = 800, height = 600)

