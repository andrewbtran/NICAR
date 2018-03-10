Integrating Github
========================================================
author: Andrew Ba Tran (@abtran)
date: 03/10/2018
autosize: true

========================================================
<img src="images/git.png">

Version control system (vcs)

Git has been "repurposed" beyond software development

Journalists use it for methodology, but also to share raw and summarized data.

For teams to collaborate
========================================================
<img src="images/anchorman-teamjump.gif" height="600">

It's kinda complicated
========================================================
<img src="images/smokey.png" height="600">


So why?
========================================================

Tough to justify for someone solo.

But it's worth learning because of the capabilities for communicating your analysis and for future collaboration.

Setting up Github
========================================================

A walkthrough explaining how to get connected later:

## [http://happygitwithr.com/](http://happygitwithr.com/)


Options
========================================================

- [Github](http://www.github.com)
- [BitBucket](https://bitbucket.org/)
- [GitLab](https://about.gitlab.com/)

Show off! Allow collaboration!
========================================================

<img src="images/catpat.gif" height="600">

Show off! Collaborate!
========================================================

- The R Community is active on Github
- The more often you use it, the more often you can use others' code and data
- Easily import from Github repos into your workflow
- Simple to run [Shiny Apps locally](https://github.com/yonicd/gunflow) with `runGithub` function

Markdown and Rmarkdown
========================================================
Github loves Markdown. Even Rmarkdown.

Renders it as HTML.

========================================================
<img src="images/gh_pages.png" height="600">

Hosting with Github Pages
========================================================

## Turn http://github.com/username/reponame/index.html

## Into http://username.github.io/reponame/index.html

Hosting with Github Pages
========================================================
<img src="images/gh2.png">

Hosting with Github Pages
========================================================
<img src="images/gh1.png">

How
========================================================
After uploading your repo, click on **Settings**

<img src="images/settings.png">

Scroll down to the Github Pages section
========================================================

Change the *Source* from `None` to `master branch` or `master branch\docs` (depending on where you want your root to be)

<img src="images/gh_pages_docs.png" height="400">

.gitignore large and unnecessary files
========================================================

- Don't include files larger than 100 mb
- Don't include your keys or passwords
- Try to exclude any extraneous files like r history

You can borrow [this one](https://github.com/wpinvestigative/kushner_eb5_census/blob/master/.gitignore)


Include readmes and data dictionaries
========================================================

- [Buzzfeed](https://github.com/BuzzFeedNews/everything) is a good model for how they index their story links and repos as a table

<img src="images/index.png">

Please don't create monster data repos
========================================================

<img src="images/fivethirtyeight.png">

