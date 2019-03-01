
## Customizing charts
  
library(readr)

ages <- read_csv("data/ages.csv")

library(ggplot2)

ggplot(ages,
  aes(x=actress_age, y=Movie)) +
  geom_point()

## Reordering chart labels


# If you don't have forcats installed yet, uncomment the line below and run
# install.packages("forcats")

library(forcats)

ggplot(ages,
       aes(x=actress_age, y=fct_reorder(Movie, actress_age, desc=TRUE))) +
  geom_point()


## Lollipop plot


ggplot(ages,
  aes(x=actress_age, y=fct_reorder(Movie, actress_age, desc=TRUE))) +
  geom_segment(aes(x = 0, xend = actress_age, yend = fct_reorder(Movie, actress_age, desc=TRUE)),
  color = "gray50") +
  geom_point()

ggplot(ages,
  aes(x=actress_age, y=fct_reorder(Movie, actress_age, desc=TRUE))) +
  geom_segment(aes(x = 0, y=fct_reorder(Movie, actress_age, desc=TRUE),
    xend = actress_age, yend = fct_reorder(Movie, actress_age, desc=TRUE)),
  color = "gray50") +
  geom_point() +
# NEW CODE BELOW
  labs(x="Actress age", y="Movie", 
    title = "Actress ages in movies",
    subtitle = "for R for Journalists class",
    caption = "Data from Vulture.com and IMDB") +
  theme_minimal()

ggplot(ages,
       aes(x=actress_age, y=fct_reorder(Movie, actress_age, desc=TRUE))) +
  geom_segment(
    aes(x = 0,
        y=fct_reorder(Movie, actress_age, desc=TRUE),
        xend = actress_age,
        yend = fct_reorder(Movie, actress_age, desc=TRUE)),
    color = "gray50") +
  geom_point() +
  labs(x="Actress age", y="Movie", 
       title = "Actress ages in movies",
       subtitle = "for R for Journalists class",
       caption = "Data from Vulture.com and IMDB") +
  theme_minimal() +
  # NEW CODE BELOW
  geom_text(aes(label=actress_age), hjust=-.5) +
  theme(panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), 
        axis.line = element_blank(),
        axis.text.x = element_blank())

## Saving ggplots


ggsave("actress_ages.png")

ggsave("actress_ages_adjusted.png", width=20, height=30, units="cm")

# First, let's permanently reorder the data frame so we don't have to keep using fct_reorder

library(dplyr)

ages_reordered <- ages %>% 
mutate(Movie=fct_reorder(Movie, desc(actor_age)))

ggplot(ages_reordered) +
  geom_segment(aes(x = actress_age, y = Movie, xend = actor_age, yend = Movie),
               color = "gray50") +
  geom_point(aes(x=actress_age, y=Movie), color="dark green") +
  geom_point(aes(x=actor_age, y=Movie), color="dark blue") +
  labs(x="", y="", title = "Actor and actress ages in movies",
    subtitle = "for R for Journalists class",
    caption = "Data from Vulture.com and IMDB") +
  theme_minimal() +
  geom_text(aes(x=actress_age, y=Movie, label=actress_age), hjust=ifelse(ages$actress_age<ages$actor_age, 1.5, -.5)) +
  geom_text(aes(x=actor_age, y=Movie, label=actor_age), hjust=ifelse(ages$actress_age<ages$actor_age, -.5, 1.5)) +
  theme(panel.border = element_blank(), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(), 
    axis.line = element_blank(),
    axis.text.x = element_blank())

## Scales


ggplot(ages, aes(x=actor_age, y=actress_age)) + geom_point() +
  scale_x_continuous(breaks=seq(20,30,2), limits=c(20,30)) +
  scale_y_continuous(breaks=seq(20,40,4), limits=c(20,40))

ggplot(ages, aes(x=actor)) + geom_bar() +
scale_x_discrete(limits=c("Tom Hanks", "Tom Cruise", "Denzel Washington"))

## Scales for color and fill

library(dplyr)

avg_age <- ages %>% 
  group_by(actor) %>%
  mutate(age_diff = actor_age-actress_age) %>% 
  summarize(average_age_diff = mean(age_diff))

ggplot(avg_age, aes(x=actor, y=average_age_diff, fill=actor)) + 
  geom_bar(stat="identity") +
  theme(legend.position="none") + # This removes the legend
  scale_fill_manual(values=c("aquamarine", "darkorchid", "deepskyblue2", "lemonchiffon2", "orange", "peachpuff3", "tomato"))


ggplot(avg_age, aes(x=actor, y=average_age_diff, fill=actor)) + 
  geom_bar(stat="identity") +
  theme(legend.position="none") + 
  scale_fill_brewer()

ggplot(avg_age, aes(x=actor, y=average_age_diff, fill=actor)) + 
  geom_bar(stat="identity") +
  theme(legend.position="none") + 
  scale_fill_brewer(palette="Pastel1")

## Annotations
  
ggplot(ages, aes(x=actor_age, y=actress_age)) + 
  geom_point() +
  geom_hline(yintercept=50, color="red") +
  annotate("text", x=40, y=51, label="Random text for some reason", color="red")

## Themes


# If you don't have ggthemes installed yet, uncomment the line below and run it
#install.packages("ggthemes")

library(ggthemes)
ggplot(ages, aes(x=actor_age, y=actress_age, color=actor)) + 
  geom_point() +
  theme_economist() +
  scale_colour_economist()

ggplot(ages, aes(x=actor_age, y=actress_age, color=actor)) + 
       geom_point() +
       theme_fivethirtyeight()

## Your turn
                                             
# Challenge yourself with these exercises
# http://code.r-journalism.com/chapter-4/#section-customizing-charts