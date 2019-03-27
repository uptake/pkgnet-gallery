# Welcome to the [pkgnet](https://uptakeopensource.github.io/pkgnet/index.html) Gallery Repository!

Please visit [the pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) to view the gallery. See below for how to contribute.

# FAQs

### How can I contribute an example to the gallery? 
#### 1. Create an exhibit

To create the exhibit with one command, use `create_exhibit.R` It creates both the report and image and saves them in an exhibit folder.  Use it right from the terminal via Rscript. 

```console
$ git clone https://github.com/UptakeOpenSource/pkgnet-gallery.git
$ cd pkgnet-gallery
$ Rscript create_exhibit.R <package name>
```

Optionally, if you have the R package downloaded locally, you can create an exhibit with code coverage information.

```console
$ Rscript create_exhibit.R <package name> --package_path=<path to package>
```

See the help documentation for more information: 
```console
$ Rscript create_exhibit.R -h
```

#### 2. Host your exhibit
If you would like to host your examples on this repository, include their addition to the `exhibits` folder in your [pull request](https://help.github.com/en/articles/creating-a-pull-request).

If you have the means and desire to host your exhibits yourself, you are welcome to do that.

#### 3. Add HTML Code (just a little)
Add html code to `vignettes/pkgnet-gallery.Rmd` that links to your exhibit (either hosted elsewhere or in this repository) in following this format:

```HTML
<td width="33%">[Your Package Name]<br>
	<a href="[URL to your package report]">
		<img width="300" src="[URL to your image]">
	</a>
</td>
```

Be sure to keep three (3) exhibits per row at maximum. 

#### 3. Submit!
[Submit a pull request](https://help.github.com/en/articles/creating-a-pull-request)!

### Why is this a seperate repository? 
There are a few reasons:     
1. We would like to enable gallery updates more often than  [CRAN](https://CRAN.R-project.org/package=pkgnet) version updates.   
2. We would like to keep [the pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) in line with the last stable version of `pkgnet` (i.e. the [CRAN](https://CRAN.R-project.org/package=pkgnet) version).   
3. We would like to keep the [pkgnet github repository](https://github.com/UptakeOpenSource/pkgnet) small in size. 

By having the gallery content hosted here, we achieve all three of these things.

### Why are there so many seemingly extra files in this repository?
We want to make the transition from [the main pkgnet website](https://uptakeopensource.github.io/pkgnet/index.html) to the gallery page within that website as seamless as possible.  To do so, we create the gallery page with the same R package, [pkgdown](https://pkgdown.r-lib.org/index.html), that we use to create the main page with very similar configuration files. Since creating a section of a website outside of the R package directory is not standard functionality for [pkgdown](https://pkgdown.r-lib.org/index.html), we replicate a few files and folder structures [pkgdown](https://pkgdown.r-lib.org/index.html) expects here. 

### Isn't there a better why to do this?
Most likely.  We've love for you to submit your ideas on the issues page (preferably on the [main pkgnet repository](https://github.com/UptakeOpenSource/pkgnet/issues)). 
