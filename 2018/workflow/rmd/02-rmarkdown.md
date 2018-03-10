Sharing analyses with RMarkdown
========================================================
author: Andrew Ba Tran (@abtran)
date: 03/10/2018
autosize: true

Markdown
========================================================

Super simple way to add formating to plain text

- headers
- bold
- bullet lists
- links

Created by John Gruber (of Daring Fireball) as a simple way for non-programming types to write in an easy-to-read format that could be converted directly into HTML.


Markdown
========================================================
<img src="images/markdown.png">

R code
========================================================
```
boston_payroll %>%
  group_by(TITLE) %>%
  summarise_each(funs(mean), REGULAR, OVERTIME)
```

.Rmd files
========================================================

<div style="float:left; padding-right:20px"><img src="images/rmdfiles.png"></div>
An R Markdown (.Rmd) file is a record of your analysis process. 

It contains the code that a scientist needs to reproduce your work along with the narration that a reader needs to understand your work.

### Literate Programming

Presentability is baked in
... not a separate process you never get around to

Show your work (everyone's doing it)
========================================================

<img src="images/somanyrepos.png" height="500">

Reproducible research
========================================================

The idea that data analyses, and more generally, stories, are published with their data and software code so that others may verify the findings and build upon them.

* Look for insight deeper than the summary report
* Verify details yourself
* Learn new techniques from looking at other processes
* Figure out ways to apply the analysis to your own needs
* Your future self will thank you for documenting your process now


Reproducible research as a perk
========================================================

<div style="float:left; padding-right:20px"><img src="http://rmarkdown.rstudio.com/images/bandThree2.png"></div> At the click of a button, or the type of a command, you can rerun the code in an R Markdown file to reproduce your work and export the results as a finished report.

R Markdown supports dozens of static and dynamic output formats including 
- HTML
- PDF
- MS Word
- Beamer
- HTML5 slides
- Tufte-style handouts
- books
- dashboards
- scientific articles (white pages)
- websites

Produce slick-looking PDF reports
========================================================

Be sure to get [LaTex](https://www.latex-project.org/get/) installed first.

<img src="images/pdf_output.png">

IPython Notebooks 
========================================================

<img src="images/pythonnotebook.png" height="500">

How .rmd files render in Github
========================================================

<img src="images/markdownoutput.png" height="500">

That's fine, I'm not mad
========================================================

```
library(DT)
library(readr)
payroll <- read_csv("../data/bostonpayroll2013.csv")
datatable(payroll)
```
<img src="images/payroll.png" height="300">


Output .Rmd files to HTML
========================================================

<img src="images/link.gif">

# Links not attachments


Reporters sometimes aren't very organized
========================================================
<img src="images/bad_desktop.png">

Host the files on an internal server
========================================================
<img src="images/S3.png">
<p>I have the code above aliased so I can type in a keyword and it will move all html files in a certain directory to an S3 server while preserving the structure of the subdirectories.</p>
<img src="images/url.png">


Host the HTML of your analysis
========================================================
- Internally or
- On Github pages
- Share with reporters and editors, let them explore your analysis further
- Let them download customized spreadsheets with buttons in the `DT` [(datatable) package](https://rstudio.github.io/DT/extensions.html)
- If your analysis gets updated, keep the file name then they only have to refresh their link
- Then get into Shiny!


1. Open a new .Rmd file
========================================================

at **File > New File > R Markdown**. 

<img src="images/menu.png">

1. Open a new .Rmd file
========================================================

Title the R Markdown file and select **HTML** as the output for now.

<img src="images/html.png">

.Rmd structure
========================================================
<div style="float:left; width:50%; padding-right:20px"><img src="images/layout2.png"></div>

========================================================

**YAML HEADER**

Optional section of render options written as **key:value** pairs.

- At start of file
- Between lines of **---** (3 dashes)

**CODE CHUNKS**

Chunks of embedded R code. Each chunk:

- begins with three **'** - (the key to the left of 1)
- ends with a single **'**

**TEXT**

Narration formatted with markdown mixed woth code chunks.


2. Write document
========================================================

Edit the default template by putting in your own code and text.

Intersperse the text with your code to tell a story.

2b. Label your chunks of code
========================================================
<img src="images/labels.png">

2c. Notebooks style
========================================================

You can run individual chunks of code before generating the full report to see how it looks.

Click the green arrow next to each chunk.

<img src="images/chunky.png">


3. Knit document to create report
========================================================
Use knit button or type **render()** to knit

<img src="images/knit_button.png">

3b. Check out the build log
========================================================
Down in the console. Warnings and errors will appear.

Also measures progress by chunks, which is why it's important to label them.

<img src="images/console.png">

4. Preview output in IDE window
========================================================

<img src="images/preview.png">

5. Output file
========================================================
You have a .Rmd file and clicking knit HTML also generated a .html file

<img src="images/testpage.png">

Specific features
========================================================

You need to load libraries just like you would a normal script.

Let's look at the data in R Markdown with a new package called [`DT`](https://rstudio.github.io/DT/) that uses the Datatables [jquery library](https://datatables.net/).

Example from **Part 1** in the `chunks.MD` file.

Open and knit `chunks/01-chunk.Rmd`

Specific features
========================================================

Adding `warning=F` and `message=F` hid the little messages.

Example from **Part 2** in the `chunks.MD` file.

Open and knit `chunks/02-chunk.Rmd`

Specific features
========================================================

If the person you're sharing this with has no interest in the code and only the quick results, use `echo=F` to hide the chunk of code and just display the output.

Example from **Part 3** in the `chunks.MD` file.

Open and knit `chunks/03-chunk.Rmd`


Specific features
========================================================

Embed lines of R code within the narrative with

<img src="images/inline.png">

Example from **Part 4** in the `chunks.MD` file.

Open and knit `chunks/04-chunk.Rmd`


Specific features
========================================================

Make pretty tables with the `knitr` package and the `kable` function.

Example from **Part 5** in the `chunks.MD` file.

Open and knit `chunks/05-chunk.Rmd`


Specific features
========================================================

Change the appearance and style of the HTML document by changing the theme up top.

Options from the [Bootswatch](http://bootswatch.com/) theme library includes:

- `default`
- `cerulean`
- `journal`
- `cosmo`

highlights 

- `tango`
- `pygments`
- `kate`

Example from **Part 6** in the `chunks.MD` file.

Open and knit `chunks/02-chunk.Rmd`

Specific features
========================================================

Add a floating table of contents by changing `html_document` to `toc: true` and `toc_float: true`.

Example from **Part 7** in the `chunks.MD` file.

Open and knit `chunks/07-chunk.Rmd`


Quick notes
========================================================

Exporting as a PDF will require LaTex installed first
  * Get it from [latex-project.org](https://www.latex-project.org/get/) or [MacTex](http://www.tug.org/mactex/)

Check out [all the features](http://rmarkdown.rstudio.com/html_document_format.html#overview) of R Markdown at RStudio

**Publish your results to Github pages**

Read more [on how](https://andrewbtran.github.io/NICAR/2018/workflow/docs/03-integrating_github.html)

**Try to publish directly to Wordpress**

I haven't actually made this work but maybe you [can try](https://yihui.name/knitr/demo/wordpress/#comment-1102994305)
