library(readr)

ages <- read_csv("data/ages.csv")

## The data

head(ages)

# If you haven't installed the ggplot2 package yet, uncomment and run the line below
#install.packages("ggplot2")

library(ggplot2)

ggplot(data=ages) +
  geom_point(mapping=aes(x=actor_age, y=actress_age)) + 
  expand_limits(x = 0, y = 0) +
  geom_abline(intercept=0, col="light gray") 

head(ages)


ggplot(ages, aes(x=actor)) +
  geom_bar()


ggplot(data=ages,
aes(x=actor, fill=Genre)) +
geom_bar()

## Aesthetics

ggplot(data=ages,
   aes(x=actor, color=Genre)) +
   geom_bar()

ggplot(data=ages,
       aes(x=actor), fill=Genre) +
       geom_bar()

ggplot(data=ages,
       aes(x=actor, fill=Genre)) +
       geom_bar()

ggplot(data=ages,
       aes(x=actor, fill=Genre)) +
       geom_bar(position="dodge")

## Spinogram

ggplot(data=ages,
       aes(x=actor, fill=Genre)) +
       geom_bar(position="fill")

## Box plot

ggplot(ages, aes(x=actor, y=actress_age)) +
       geom_boxplot()

## Violin plot

ggplot(ages, aes(x=actor, y=actress_age)) +
       geom_violin()

## Scaling

ggplot(data=ages, aes(x=actor_age)) +
       geom_histogram(binwidth=1)


ggplot(data=ages, aes(x=actor_age)) +
       geom_histogram() + scale_x_log10()

## Kernel density plot

ggplot(data=ages,
       aes(x=actress_age)) +
       geom_density(fill="red")

ggplot(data=ages,
       aes(x=actress_age, fill=actor)) +
        geom_density(alpha=.3)

## Dot plot

ggplot(ages,
       aes(x=actress_age, y=Movie)) +
       geom_point()

## Line plot

library(dplyr)

avg_age <- ages %>% 
    group_by(actor) %>%
    mutate(age_diff = actor_age-actress_age) %>% 
    summarize(average_age_diff = mean(age_diff))
                       
ggplot(avg_age, aes(x=actor, y=average_age_diff, group=1)) +
    geom_line()


ggplot(avg_age, aes(x=actor, y=average_age_diff, group=1)) +
       geom_line() +
       geom_point()

## Scatterplot with fit
                       
ggplot(ages,
       aes(x=actor_age, y=actress_age)) +
       geom_point() +
       geom_smooth()

ggplot(ages,
       aes(x=actor_age, y=actress_age)) +
       geom_point() +
       geom_smooth(method="lm", formula=y~x)

## Grouping

ggplot(data=ages,
       aes(x=actor_age, y=actress_age, color=actor)) +
       geom_point()

ggplot(data=ages,
       aes(x=actor_age, y=actress_age, color=actor, shape=Genre)) +
       geom_point()

ggplot(data=ages,
       aes(x=actor_age, y=actress_age, color=actor, shape=actor)) +
       geom_point()

## Scatterplot with color and size

ggplot(data=ages,
       aes(x=actor_age, y=actress_age, color=actor, size=budget)) +
       geom_point()

## Coords
                       
ggplot(data = avg_age, aes(x= actor, y=average_age_diff)) +
       geom_bar(stat="identity") +
       coord_flip()

## Facets

ggplot(data=ages) +
       geom_point(mapping=aes(x=actor_age, y=actress_age)) + 
       expand_limits(x = 0, y = 0) +
       geom_abline(intercept=0, col="light gray") +
       facet_grid(Genre~actor)

ggplot(data=ages) +
       geom_point(mapping=aes(x=actor_age, y=actress_age, size=budget)) + 
       expand_limits(x = 0, y = 0) +
       geom_abline(intercept=0, col="light gray") +
       facet_grid(Genre~actor)

ggplot(data=ages) +
       geom_point(mapping=aes(x=actor_age, y=actress_age)) + 
       expand_limits(x = 0, y = 0) +
       geom_abline(intercept=0, col="light gray") +
       facet_grid(.~actor)

ggplot(data=ages) +
       geom_point(mapping=aes(x=actor_age, y=actress_age)) + 
       expand_limits(x = 0, y = 0) +
       geom_abline(intercept=0, col="light gray") +
       facet_grid(actor~.)

ggplot(data=ages) +
      geom_point(mapping=aes(x=actor_age, y=actress_age)) + 
      expand_limits(x = 0, y = 0) +
      geom_abline(intercept=0, col="light gray") +
      facet_wrap(~actor, ncol=4)

## Global versus Local

ggplot(ages,
       aes(x=actor_age, y=actress_age)) +
       geom_point()

ggplot(ages,
       aes(x=actor_age, y=actress_age)) +
       geom_point(aes(color=actor))

# Let's make a copy of the  minus the actor variable so it can't be faceted
                       
ages_copy <- ages %>% select(-actor)
                       
ggplot(data=ages,
       aes(x=actor_age, y=actress_age, color=actor)) +
       geom_point(data=ages_copy, color="grey") +
       geom_point() +
       facet_wrap(~actor) +
      theme(legend.position="none") # This removes the legend

# Challenge yourself with these exercises
# http://code.r-journalism.com/chapter-4/#section-ggplot2