# Chunks for R Markdown file

Part 1
-----------------

```{r loading}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
```

Let's look at the data in R Markdown with a new package called [`DT`](https://rstudio.github.io/DT/) that uses the Datatables [jquery library](https://datatables.net/).

```{r display_data}
library(DT)
datatable(payroll)
```

Part 2
-----------------


```{r loading, warning=F, message=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
```

Let's look at the data in R Markdown with a new package called [`DT`](https://rstudio.github.io/DT/) that uses the Datatables [jquery library](https://datatables.net/).

```{r display_data, warning=F}
library(DT)
datatable(payroll)
```

Part 3
-----------------

# Boston employee pay in 2014

```{r loading, warning=F, message=F, echo=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
payroll_total <- select(payroll, NAME, TITLE, DEPARTMENT, TOTAL.EARNINGS)
```

```{r display_data, warning=F, message=F, echo=F}
library(DT)
datatable(payroll_total)

```


Part 4
-----------------

```{r loading, warning=F, message=F, echo=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)

payroll$TOTAL.EARNINGS <- gsub("\\$", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- gsub(",", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- as.numeric(payroll$TOTAL.EARNINGS)

payroll_total <- select(payroll, NAME, TITLE, DEPARTMENT, TOTAL.EARNINGS)

most_pay <- payroll_total %>%
arrange(desc(TOTAL.EARNINGS)) %>%
head(1)
```

The Boston city employee who was paid the most in 2014 was a `r most_pay$TITLE` at `r most_pay$DEPARTMENT`.

This person made $`r prettyNum(most_pay$TOTAL.EARNINGS,big.mark=",",scientific=FALSE)`.

```{r display_data, warning=F, message=F, echo=F}
library(DT)
datatable(payroll_total)

```

Part 5
-----------------

# Departments with the highest average pay

```{r loading, warning=F, message=F, echo=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
```

```{r cleaning_data, warning=F, echo=F}
payroll$REGULAR <- gsub("\\$", "", payroll$REGULAR)
payroll$REGULAR <- gsub(",", "", payroll$REGULAR)
payroll$REGULAR <- as.numeric(payroll$REGULAR)
payroll$RETRO <- gsub("\\$", "", payroll$RETRO)
payroll$RETRO <- gsub(",", "", payroll$RETRO)
payroll$RETRO <- as.numeric(payroll$RETRO)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OVERTIME <- gsub("\\$", "", payroll$OVERTIME)
payroll$OVERTIME <- gsub(",", "", payroll$OVERTIME)
payroll$OVERTIME <- as.numeric(payroll$OVERTIME)
payroll$INJURED <- gsub("\\$", "", payroll$INJURED)
payroll$INJURED <- gsub(",", "", payroll$INJURED)
payroll$INJURED <- as.numeric(payroll$INJURED)
payroll$DETAIL <- gsub("\\$", "", payroll$DETAIL)
payroll$DETAIL <- gsub(",", "", payroll$DETAIL)
payroll$DETAIL <- as.numeric(payroll$DETAIL)
payroll$QUINN <- gsub("\\$", "", payroll$QUINN)
payroll$QUINN <- gsub(",", "", payroll$QUINN)
payroll$QUINN <- as.numeric(payroll$QUINN)
payroll$TOTAL.EARNINGS <- gsub("\\$", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- gsub(",", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- as.numeric(payroll$TOTAL.EARNINGS)
```

```{r analysis, warning=F, message=F, echo=F}
top5 <- payroll %>%
group_by(DEPARTMENT) %>%
summarize(Average.Earnings=mean(TOTAL.EARNINGS, na.rm=T)) %>%
arrange(desc(Average.Earnings)) %>%
  head(5)

```

```{r table, warning=F, echo=F}
library(knitr)
kable(top5)
```

Part 6
-----------------

---
title: "R Markdown page"
author: "Andrew"
date: "2/23/2017"
output:
  html_document:
    theme: united
    highlight: tango
---

# Departments with the highest average pay

```{r loading, warning=F, message=F, echo=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
```

```{r cleaning_data, warning=F, echo=F}
payroll$REGULAR <- gsub("\\$", "", payroll$REGULAR)
payroll$REGULAR <- gsub(",", "", payroll$REGULAR)
payroll$REGULAR <- as.numeric(payroll$REGULAR)
payroll$RETRO <- gsub("\\$", "", payroll$RETRO)
payroll$RETRO <- gsub(",", "", payroll$RETRO)
payroll$RETRO <- as.numeric(payroll$RETRO)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OVERTIME <- gsub("\\$", "", payroll$OVERTIME)
payroll$OVERTIME <- gsub(",", "", payroll$OVERTIME)
payroll$OVERTIME <- as.numeric(payroll$OVERTIME)
payroll$INJURED <- gsub("\\$", "", payroll$INJURED)
payroll$INJURED <- gsub(",", "", payroll$INJURED)
payroll$INJURED <- as.numeric(payroll$INJURED)
payroll$DETAIL <- gsub("\\$", "", payroll$DETAIL)
payroll$DETAIL <- gsub(",", "", payroll$DETAIL)
payroll$DETAIL <- as.numeric(payroll$DETAIL)
payroll$QUINN <- gsub("\\$", "", payroll$QUINN)
payroll$QUINN <- gsub(",", "", payroll$QUINN)
payroll$QUINN <- as.numeric(payroll$QUINN)
payroll$TOTAL.EARNINGS <- gsub("\\$", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- gsub(",", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- as.numeric(payroll$TOTAL.EARNINGS)
```

```{r analysis, warning=F, message=F, echo=F}
top5 <- payroll %>%
group_by(DEPARTMENT) %>%
summarize(Average.Earnings=mean(TOTAL.EARNINGS, na.rm=T)) %>%
arrange(desc(Average.Earnings)) %>%
  head(5)

```

```{r table, warning=F, echo=F}
library(knitr)
kable(top5)
```


Part 7
-----------------

---
title: "R Markdown page"
author: "Andrew"
date: "2/23/2017"
output:
  html_document: 
    toc: true
    toc_float: true
---


# Boston employee pay in 2014

```{r loading, warning=F, message=F, echo=F}
# load packages
library(tidyverse)

# Loading the Boston city payroll
payroll <- read.csv("http://andrewbatran.com/ccsu-2017/slides/class6/bostonpayroll2013.csv", stringsAsFactors=F)
payroll_total <- select(payroll, NAME, TITLE, DEPARTMENT, TOTAL.EARNINGS)
```

```{r display_data, warning=F, message=F, echo=F}
library(DT)
datatable(payroll_total)

```

# Departments with the highest average pay

```{r cleaning_data, warning=F, echo=F}
payroll$REGULAR <- gsub("\\$", "", payroll$REGULAR)
payroll$REGULAR <- gsub(",", "", payroll$REGULAR)
payroll$REGULAR <- as.numeric(payroll$REGULAR)
payroll$RETRO <- gsub("\\$", "", payroll$RETRO)
payroll$RETRO <- gsub(",", "", payroll$RETRO)
payroll$RETRO <- as.numeric(payroll$RETRO)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OTHER <- gsub("\\$", "", payroll$OTHER)
payroll$OTHER <- gsub(",", "", payroll$OTHER)
payroll$OTHER <- as.numeric(payroll$OTHER)
payroll$OVERTIME <- gsub("\\$", "", payroll$OVERTIME)
payroll$OVERTIME <- gsub(",", "", payroll$OVERTIME)
payroll$OVERTIME <- as.numeric(payroll$OVERTIME)
payroll$INJURED <- gsub("\\$", "", payroll$INJURED)
payroll$INJURED <- gsub(",", "", payroll$INJURED)
payroll$INJURED <- as.numeric(payroll$INJURED)
payroll$DETAIL <- gsub("\\$", "", payroll$DETAIL)
payroll$DETAIL <- gsub(",", "", payroll$DETAIL)
payroll$DETAIL <- as.numeric(payroll$DETAIL)
payroll$QUINN <- gsub("\\$", "", payroll$QUINN)
payroll$QUINN <- gsub(",", "", payroll$QUINN)
payroll$QUINN <- as.numeric(payroll$QUINN)
payroll$TOTAL.EARNINGS <- gsub("\\$", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- gsub(",", "", payroll$TOTAL.EARNINGS)
payroll$TOTAL.EARNINGS <- as.numeric(payroll$TOTAL.EARNINGS)
```

```{r analysis, warning=F, message=F, echo=F}
top5 <- payroll %>%
group_by(DEPARTMENT) %>%
summarize(Average.Earnings=mean(TOTAL.EARNINGS, na.rm=T)) %>%
arrange(desc(Average.Earnings)) %>%
  head(5)

```

```{r table, warning=F, echo=F}
library(knitr)
kable(top5)
```