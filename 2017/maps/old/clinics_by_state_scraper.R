gutt <- "https://data.guttmacher.org/states/table?state=AL+AK+AZ+AR+CA+CO+CT+DE+DC+FL+GA+HI+ID+IL+IN+IA+KS+KY+LA+ME+MD+MA+MI+MN+MS+MO+MT+NE+NV+NH+NJ+NM+NY+NC+ND+OH+OK+OR+PA+RI+SC+SD+TN+TX+UT+VT+VA+WA+WV+WI+WY&topics=57&dataset=data"


clinic_states<- read_html(gutt) %>%
  html_nodes(xpath='//*[@id="tableWrapper"]/div[1]/table') %>%
  html_table() %>%
  as.data.frame()

